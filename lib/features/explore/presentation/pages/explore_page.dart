import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/map_helper.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/features/explore/data/models/store_model.dart';
import 'package:healio_app/features/explore/presentation/blocs/e_store_bloc.dart';
import 'package:healio_app/features/explore/presentation/blocs/search_cubit.dart';
import 'package:healio_app/features/explore/presentation/blocs/search_state.dart';
import 'package:healio_app/features/explore/presentation/widgets/explore_page_shimmer.dart';
import 'package:healio_app/features/explore/presentation/widgets/explore_search_bar.dart';
import 'package:healio_app/features/explore/presentation/widgets/sliding_store_card.dart';
import 'package:healio_app/features/explore/presentation/widgets/sliding_up_header.dart';
import 'package:healio_app/features/explore/presentation/widgets/stores_list.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  MapLibreMapController? mapController;
  final _panelCtrl = PanelController();
  Symbol? _selectedSymbol;
  bool isShowCard = false;
  bool _isMapStyleLoaded = false;
  final ValueNotifier<double> _panelPositionNotifier = ValueNotifier(0.0);
  final _hideOffset = 200;
  final double _distanceThreshold = 10000.0;
  LatLng? _lastSearchedLocation;
  LatLng? _currentCameraTarget;
  bool isClear = false;

  @override
  void initState() {
    super.initState();
    MapHelper.requestLocationPermission();

    _lastSearchedLocation = const LatLng(21.03357551700003, 105.81911236900004);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_panelCtrl.isAttached) {
        _panelCtrl.animatePanelToPosition(0.7);
      }
    });
  }

  void onCloseCard() async {
    if (isShowCard && _selectedSymbol != null) {
      final LatLng position = _selectedSymbol!.options.geometry!;
      final Map dataStore = _selectedSymbol!.data as Map;

      await mapController?.removeSymbol(_selectedSymbol!);

      _selectedSymbol = await mapController?.addSymbol(
          SymbolOptions(
            geometry: position,
            iconImage: dataStore['iconId'] ?? 'marker-normal',
            iconSize: 1,
            zIndex: 10,
          ),
          dataStore);
      setState(() {
        isShowCard = false;
        _selectedSymbol = null;
      });
    }
  }

  void _onMapCreated(MapLibreMapController controller) async {
    mapController = controller;
    mapController!.onSymbolTapped.add(_onSymbolTapped);

    try {
      final normalIcon = await MapHelper.createNoRatingIcon();
      await mapController!.addImage('marker-normal', normalIcon);

      final ByteData bytesSelected =
      await rootBundle.load('assets/icons/convenience-store.png');
      await mapController!.addImage(
          'marker-selected', bytesSelected.buffer.asUint8List());
    } catch (e) {
      print("Lỗi nạp ảnh: $e");
    }
  }

  void _onSymbolTapped(Symbol symbol) async {
    if (_selectedSymbol != null) {
      final data = _selectedSymbol!.data;
      String iconId = data?['iconId'] ?? 'marker-normal';

      await mapController?.updateSymbol(
          _selectedSymbol!, SymbolOptions(iconImage: iconId, iconSize: 1));
    }

    final LatLng position = symbol.options.geometry!;
    final Map dataStore = symbol.data as Map;

    await mapController?.removeSymbol(symbol);

    _selectedSymbol = await mapController?.addSymbol(
        SymbolOptions(
          geometry: position,
          iconImage: "marker-selected",
          iconSize: 0.8,
          zIndex: 10,
        ),
        dataStore);

    setState(() {
      isShowCard = true;
    });
  }

  Future<void> _onStyleLoadedCallback(List<StoreModel> stores) async {
    if (mapController == null) return;

    await mapController!.setSymbolIconAllowOverlap(true);
    await mapController!.setSymbolIconIgnorePlacement(true);

    _isMapStyleLoaded = true;

    // Nếu load map xong mà đã có data thì hiển thị luôn
    if (stores.isNotEmpty && context.read<EStoreBloc>().state.searchStores == null) {
      MapHelper.addStoreMarkers(mapController, stores);
    }
  }

  void _clearSearch() {
    context.read<SearchFilterCubit>().clearSearch();

    setState(() {
      isShowCard = false;
      _selectedSymbol = null;
    });

    if(!_panelCtrl.isPanelClosed){
      _panelCtrl.close();
    }

    context.read<EStoreBloc>().add(ClearSearch());
  }

  void _onSearchPressed() async {
    final result = await context.push('/explore/search');

    if (result == 'search') {
      final state = context.read<SearchFilterCubit>().state;

      if (state.lat == null && state.lng == null) {
        Position? lastPosition = await Geolocator.getLastKnownPosition();
        if (lastPosition != null) {
          context.read<SearchFilterCubit>().updateSearch(state.copyWith(lng: lastPosition.longitude, lat: lastPosition.latitude));
          _lastSearchedLocation = LatLng(lastPosition.latitude, lastPosition.longitude);
        } else{
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high
          );
          _lastSearchedLocation = LatLng(position.latitude, position.longitude);
          context.read<SearchFilterCubit>().updateSearch(state.copyWith(lng: position.longitude, lat: position.latitude));
        }
      }

      final finalState = context.read<SearchFilterCubit>().state;

      if (finalState.category != 'All treatments' && finalState.date != null && finalState.startTime != null && finalState.endTime != null) {
        context.read<EStoreBloc>().add(SearchByFilter(userLat: finalState.lat!, userLng: finalState.lng!, radiusKm: 20, category: finalState.category.trim(), date: finalState.date, startTime: finalState.startTime, endTime: finalState.endTime));
      } else if (finalState.category == 'All treatments' && finalState.date != null && finalState.startTime != null && finalState.endTime != null) {
        context.read<EStoreBloc>().add(SearchByFilter(userLat: finalState.lat!, userLng: finalState.lng!, radiusKm: 20, date: finalState.date, startTime: finalState.startTime, endTime: finalState.endTime));
      } else if (finalState.category == 'All treatments' && finalState.date != null && finalState.startTime == null && finalState.endTime == null) {
        context.read<EStoreBloc>().add(SearchByFilter(userLat: finalState.lat!, userLng: finalState.lng!, radiusKm: 20, date: finalState.date));
      } else if (finalState.category != 'All treatments' && finalState.date == null && finalState.startTime == null && finalState.endTime == null) {
        context.read<EStoreBloc>().add(SearchByFilter(userLat: finalState.lat!, userLng: finalState.lng!, radiusKm: 20, category: finalState.category.trim()));
      } else if (finalState.category == 'All treatments' && finalState.date == null && finalState.startTime != null && finalState.endTime != null ) {
        context.read<EStoreBloc>().add(SearchByFilter(startTime: finalState.startTime, endTime: finalState.endTime, userLat: finalState.lat!, userLng: finalState.lng!, radiusKm: 20));
      } else if (finalState.category == 'All treatments' && finalState.date == null && finalState.startTime == null && finalState.endTime == null && finalState.locationName != 'Current location') {
        context.read<EStoreBloc>().add(SearchByFilter(userLat: finalState.lat!, userLng: finalState.lng!, radiusKm: 20));
      }
    } else if (result == 'clear') {
      _clearSearch();
    }
  }

  Widget _buildPanelContent(EStoreState state, ScrollController scrollController) {
    if (state.searchStores == null) {
      return StoresList(scrollCtrl: scrollController, stores: state.aroundStores);
    } else if (state.searchStores!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 200.0, left: 15, right: 15),
        child: Center(
          child: Column(
            children: [
              PhosphorIcon(PhosphorIcons.magnifyingGlass(), size: 60, color: Colors.deepPurpleAccent),
              const SizedBox(height: 20),
              Text('We didn\'t find a match', style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 22)),
              Text('Try a new search', style: GoogleFonts.quicksand(fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.3), fontSize: 14)),
              const SizedBox(height: 20),
              FilledButton(
                onPressed:() => _clearSearch(),
                style: FilledButton.styleFrom(backgroundColor: Colors.black, minimumSize: const Size(120, 40)),
                child: Text('Clear search', style: GoogleFonts.quicksand(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              )
            ],
          ),
        ),
      );
    } else {
      return StoresList(scrollCtrl: scrollController, stores: state.searchStores!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tileKey = dotenv.env['GOONG_MAP_TILE_KEY'];
    final String styleUrl = "https://tiles.goong.io/assets/goong_map_highlight.json?api_key=$tileKey";

    return BlocBuilder<SearchFilterCubit, SearchFilterState>(
      builder: (context, searchState){
        return BlocConsumer<EStoreBloc, EStoreState>(
          listenWhen: (previous, current) => previous.isLoading != current.isLoading || previous.isSearching != current.isSearching,
          listener: (context, state) async {
            if (state.error != null) {
              SnackBarHelper.showError(state.error.toString());
            }

            if (mapController == null || !_isMapStyleLoaded) return;

            if (!state.isLoading && state.aroundStores.isNotEmpty && state.searchStores == null && !state.isSearching) {
              mapController!.clearSymbols();
              await MapHelper.addStoreMarkers(mapController, state.aroundStores);
              MapHelper.flyToMe(mapController);
            }
            else if (!state.isSearching) {
              mapController?.clearSymbols();

              if(searchState.lng != null && searchState.lat != null){
                MapHelper.flyToPosition(mapController, searchState.lat!, searchState.lng!, 11);
              }

              if (state.searchStores != null && state.searchStores!.isNotEmpty) {
                await MapHelper.addStoreMarkers(mapController, state.searchStores!);
              } else if (state.searchStores == null) {
                await MapHelper.addStoreMarkers(mapController, state.aroundStores);
                MapHelper.flyToMe(mapController);
              }
            }
          },
          builder: (context, state) {
            return Scaffold(
              body: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: MapLibreMap(
                      styleString: styleUrl,
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(21.03357551700003, 105.81911236900004),
                        zoom: 8,
                      ),
                      myLocationEnabled: true,
                      trackCameraPosition: true,
                      myLocationTrackingMode: MyLocationTrackingMode.none,
                      myLocationRenderMode: MyLocationRenderMode.normal,
                      rotateGesturesEnabled: false,
                      tiltGesturesEnabled: false,
                      onMapCreated: _onMapCreated,
                      onStyleLoadedCallback: () => _onStyleLoadedCallback(state.aroundStores),
                      onCameraMove: (position){
                        _currentCameraTarget = position.target;
                      },
                      onCameraIdle: () async{
                        if (mapController == null || _lastSearchedLocation == null || _currentCameraTarget == null) return;

                        final currentTarget = _currentCameraTarget!;

                        double distanceInMeters = Geolocator.distanceBetween(
                          _lastSearchedLocation!.latitude,
                          _lastSearchedLocation!.longitude,
                          currentTarget.latitude,
                          currentTarget.longitude,
                        );

                        if (distanceInMeters > _distanceThreshold && !isClear) {
                          _lastSearchedLocation = currentTarget;
                          context.read<SearchFilterCubit>().updateSearch(searchState.copyWith(lat: currentTarget.latitude, lng: currentTarget.longitude, location: 'Map area'));

                          final finalState = context.read<SearchFilterCubit>().state;

                          if (finalState.category != 'All treatments' && finalState.date != null && finalState.startTime != null && finalState.endTime != null) {
                            context.read<EStoreBloc>().add(SearchByFilter(userLat: finalState.lat!, userLng: finalState.lng!, radiusKm: 20, category: finalState.category.trim(), date: finalState.date, startTime: finalState.startTime, endTime: finalState.endTime));
                          } else if (finalState.category == 'All treatments' && finalState.date != null && finalState.startTime != null && finalState.endTime != null) {
                            context.read<EStoreBloc>().add(SearchByFilter(userLat: finalState.lat!, userLng: finalState.lng!, radiusKm: 20, date: finalState.date, startTime: finalState.startTime, endTime: finalState.endTime));
                          } else if (finalState.category == 'All treatments' && finalState.date != null && finalState.startTime == null && finalState.endTime == null) {
                            context.read<EStoreBloc>().add(SearchByFilter(userLat: finalState.lat!, userLng: finalState.lng!, radiusKm: 20, date: finalState.date));
                          } else if (finalState.category != 'All treatments' && finalState.date == null && finalState.startTime == null && finalState.endTime == null) {
                            context.read<EStoreBloc>().add(SearchByFilter(userLat: finalState.lat!, userLng: finalState.lng!, radiusKm: 20, category: finalState.category.trim()));
                          } else if (finalState.category == 'All treatments' && finalState.date == null && finalState.startTime != null && finalState.endTime != null ) {
                            context.read<EStoreBloc>().add(SearchByFilter(startTime: finalState.startTime, endTime: finalState.endTime, userLat: finalState.lat!, userLng: finalState.lng!, radiusKm: 20));
                          } else if (finalState.category == 'All treatments' && finalState.date == null && finalState.startTime == null && finalState.endTime == null && finalState.locationName != 'Current location') {
                            context.read<EStoreBloc>().add(SearchByFilter(userLat: finalState.lat!, userLng: finalState.lng!, radiusKm: 20));
                          }
                        }
                      },
                    ),
                  ),

                  state.isSearching
                  ? Positioned(
                      top: 120,
                      child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey)
                          ),
                          child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.black, size: 35)
                      ),
                  )
                  : (state.searchStores != null && state.searchStores!.isEmpty)
                    ? Positioned(
                      top: 120,
                      child: Container(
                        height: 35,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey)
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 5,
                          children: [
                            Text(
                              '0 results',
                              style: GoogleFonts.quicksand(fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            Icon(
                              Icons.fiber_manual_record,
                              size: 4,
                              color: Colors.black,
                            ),
                            GestureDetector(
                              onTap: () => _clearSearch(),
                              child: Text(
                                'Clear search',
                                style: GoogleFonts.quicksand(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.deepPurpleAccent),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                    : const SizedBox.shrink(),

                  Positioned(
                    top: 50,
                    left: 10,
                    right: 10,
                    child: state.isLoading
                        ? const SearchBarShimmer()
                        : ExploreSearchBar(
                      onOpen: () => _panelCtrl.open(),
                      onSearchPressed: () => _onSearchPressed(),
                      category: searchState.category,
                      location: searchState.locationName,
                      datetime: searchState.dateText + ' - ' + searchState.timeText,
                    ),
                  ),

                  if (isShowCard && _selectedSymbol != null)
                    ValueListenableBuilder<double>(
                      valueListenable: _panelPositionNotifier,
                      builder: (context, pos, child) {
                        return Positioned(
                          bottom: 160,
                          left: 20,
                          right: 20,
                          child: Transform.translate(
                            offset: Offset(0, pos * _hideOffset),
                            child: Opacity(
                              opacity: (1.0 - pos * 2).clamp(0.0, 1.0),
                              child: SlidingStoreCard(
                                store: _selectedSymbol!.data!['store'],
                                onClose: onCloseCard,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                  if (!state.isLoading)
                    Positioned(
                      bottom: 100,
                      right: 10,
                      child: Transform.translate(
                        offset: Offset(0, _panelPositionNotifier.value * _hideOffset),
                        child: IconButton(
                          onPressed: () => MapHelper.flyToMe(mapController),
                          style: IconButton.styleFrom(backgroundColor: Colors.white),
                          icon: const Icon(Icons.my_location, color: Colors.black, size: 20),
                        ),
                      ),
                    ),

                  state.isLoading
                      ? SlidingUpShimmer(panelCtrl: _panelCtrl, panelPositionNotifier: _panelPositionNotifier)
                      : SlidingUpPanel(
                    maxHeight: 700,
                    minHeight: 80,
                    snapPoint: 0.7,
                    controller: _panelCtrl,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                    defaultPanelState: PanelState.CLOSED,
                    onPanelSlide: (double pos) {
                      _panelPositionNotifier.value = pos;
                    },
                    header: const SlidingUpHeader(),
                    panelBuilder: (ScrollController scrollController) {
                      return _buildPanelContent(state, scrollController);
                    },
                  ),
                ],
              ),
            );
          },
        );
    });
  }
}

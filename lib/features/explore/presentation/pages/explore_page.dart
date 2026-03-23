import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:healio_app/core/utils/map_helper.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/features/home/data/models/store_model.dart';
import 'package:healio_app/features/home/presentation/bloc/e_store_bloc.dart';
import 'package:healio_app/features/explore/presentation/pages/search_page.dart';
import 'package:healio_app/features/explore/presentation/widgets/explore_page_shimmer.dart';
import 'package:healio_app/features/explore/presentation/widgets/explore_search_bar.dart';
import 'package:healio_app/features/explore/presentation/widgets/sliding_store_card.dart';
import 'package:healio_app/features/explore/presentation/widgets/sliding_up_header.dart';
import 'package:healio_app/features/explore/presentation/widgets/stores_list.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
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
  final _hideOffset = 200; // Vị trí dấu đi card thông tin cửa hàng

  void onCloseCard() async{
    if(isShowCard){
      final LatLng position = _selectedSymbol!.options.geometry!;
      final Map dataStore = _selectedSymbol!.data as Map;

      await mapController?.removeSymbol(_selectedSymbol!);

      _selectedSymbol = await mapController?.addSymbol(
          SymbolOptions(
            geometry: position,
            iconImage: dataStore['iconId'],
            iconSize: 1,
            zIndex: 10,
          ),
          dataStore
      );
      setState(() {
        isShowCard = false;
        _selectedSymbol = null;
      });
    }
  }

  void _onMapCreated(MapLibreMapController controller) async{
    mapController = controller;
    mapController!.onSymbolTapped.add(_onSymbolTapped);

    try {
      final normalIcon = await MapHelper.createNoRatingIcon();
      await mapController!.addImage('marker-normal', normalIcon);

      final ByteData bytesSelected = await rootBundle.load('assets/icons/convenience-store.png');
      await mapController!.addImage('marker-selected', bytesSelected.buffer.asUint8List());

      if(mounted){
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã nạp ảnh marker thành công')));
      }
    } catch (e) {
      print("Lỗi nạp ảnh: $e");
    }
  }

  void _onSymbolTapped(Symbol symbol) async{

    if (_selectedSymbol != null) {
      final data = _selectedSymbol!.data;
      String iconId = data!['iconId'];

      await mapController?.updateSymbol(
          _selectedSymbol!,
          SymbolOptions(iconImage: iconId, iconSize: 1)
      );
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
        dataStore
    );

    setState(() {
      isShowCard = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Quán: ${dataStore['store']['name']}"),
        )
    );
  }

  Future<void> _onStyleLoadedCallback(List<StoreModel> stores) async{
    if (mapController == null) return;

    await mapController!.setSymbolIconAllowOverlap(true);
    await mapController!.setSymbolIconIgnorePlacement(true);

    _isMapStyleLoaded = true;

    if(stores.isNotEmpty){
      MapHelper.addStoreMarkers(mapController, stores);
    }
  }

  @override
  void initState() {
    super.initState();
    MapHelper.requestLocationPermission();
  }

  @override
  Widget build(BuildContext context) {

    final tileKey = dotenv.env['GOONG_MAP_TILE_KEY'];
    final String styleUrl = "https://tiles.goong.io/assets/goong_map_highlight.json?api_key=$tileKey";

    return BlocConsumer<EStoreBloc, EStoreState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) async{
        if(state.error != null){
          SnackBarHelper.showError(state.error.toString());
        }
        if (state.aroundStores.isNotEmpty && _isMapStyleLoaded && mapController != null) {
          // Clear marker cũ nếu bạn muốn vẽ lại từ đầu
          // mapController!.clearSymbols();

          await MapHelper.addStoreMarkers(mapController, state.aroundStores);

          MapHelper.flyToMe(mapController);
        }
      },
      builder: (context, state){
        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: MapLibreMap(
                    styleString: styleUrl, // sử dụng api tile map của goong để hiển thị
                    initialCameraPosition: const CameraPosition(
                        target: LatLng(21.03357551700003, 105.81911236900004),
                        zoom: 10
                    ),
                    myLocationEnabled: true, // hiển thị vị trí của tôi
                    myLocationTrackingMode: MyLocationTrackingMode.tracking,
                    onMapCreated: _onMapCreated,
                    onStyleLoadedCallback:() => _onStyleLoadedCallback(state.aroundStores),
                    myLocationRenderMode: MyLocationRenderMode.normal,
                    rotateGesturesEnabled: false, // Chặn người dùng dùng 2 ngón tay để xoay bản đồ
                    tiltGesturesEnabled: false, // Chặn người dùng vuốt dọc để nghiêng bản đồ (3D)
                  )
                ),
              Positioned(
                  top: 50,
                  left: 10,
                  right: 10,
                  child: state.isLoading
                    ? const SearchBarShimmer()
                    : ExploreSearchBar(
                        onOpen:() => _panelCtrl.open(),
                        onSearchPressed: () {
                          context.push('/explore/search');
                        },
                    )
              ),
              if(isShowCard)
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
              state.isLoading
                ? const SizedBox.shrink()
                : Positioned(
                  bottom: 100,
                  right: 10,
                  child: Transform.translate(
                    offset: Offset(0, _panelPositionNotifier.value * _hideOffset),
                    child: IconButton(
                        onPressed: () async{
                          MapHelper.flyToMe(mapController);
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.my_location, color: Colors.black, size: 20,)
                    ),
                  ),
                ),
              state.isLoading
                ? SlidingUpShimmer(panelCtrl: _panelCtrl, panelPositionNotifier: _panelPositionNotifier)
                : SlidingUpPanel(
                    maxHeight: 700,
                    minHeight: 80,
                    controller: _panelCtrl,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                    defaultPanelState: PanelState.CLOSED,
                    onPanelSlide: (double pos) {
                      setState(() {
                        _panelPositionNotifier.value = pos;
                      });
                    },
                    header: SlidingUpHeader(onVerticalDragUpdate: (details) => _panelCtrl.panelPosition -= details.primaryDelta! / 600),
                    panelBuilder: (ScrollController scrollController){
                      return StoresList(scrollCtrl: scrollController, stores: state.aroundStores,);
                    },
                )
            ],
          ),
        );
      },
    );
  }
}


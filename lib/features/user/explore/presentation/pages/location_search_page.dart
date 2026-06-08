import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotrue/gotrue.dart';
import 'package:healio_app/core/services/recently_search_service.dart';
import 'package:healio_app/core/utils/map_helper.dart';
import 'package:healio_app/features/user/auth/domain/usecases/check_user_session_usecase.dart';
import 'package:healio_app/features/user/explore/presentation/blocs/search_cubit.dart';
import 'package:healio_app/features/user/explore/presentation/blocs/search_state.dart';
import 'package:healio_app/features/user/profile/presentation/blocs/user_address_bloc.dart';
import 'package:healio_app/features/user/explore/presentation/pages/add_my_address_page.dart';
import 'package:healio_app/features/user/explore/presentation/pages/my_address_page.dart';
import 'package:healio_app/features/user/explore/presentation/widgets/location_search_card.dart';
import 'package:healio_app/features/user/explore/presentation/widgets/recent_location_card.dart';
import 'package:healio_app/features/user/widgets/section_header.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../core/injector/dependency_injector.dart';
import '../../../../../core/utils/snackbar_helper.dart';
import '../widgets/search_text_field_1.dart';

class LocationSearchPage extends StatefulWidget {
  const LocationSearchPage({super.key});

  @override
  State<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  final _searchController = TextEditingController();
  late final Session? session;
  Future<List<Map<String, dynamic>>> recentLocations =
      RecentlySearchService.getRecentLocations();

  List<dynamic> places = [];
  var details = {};
  bool isShow = false;
  bool isLoading = false;
  bool isGranted = true;

  @override
  void initState() {
    super.initState();
    session = inj<CheckUserSessionUseCase>().call();
  }

  Future<void> fetchData(String input) async {
    try {
      setState(() {
        isLoading = true;
      });
      final url = Uri.parse(
        'https://rsapi.goong.io/Place/AutoComplete?location=21.013715429594125%2C%20105.79829597455202&input=$input&api_key=i9WBxoabU5xQF7ViPKwrEIp5roEEUfs0ZvxBOf7C',
      );
      var response = await http.get(url);

      setState(() {
        final jsonResponse = jsonDecode(response.body);
        places = jsonResponse['predictions'] as List<dynamic>;
        isShow = true;
        isLoading = false;
      });
    } catch (e) {
      SnackBarHelper.showError(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: PhosphorIcon(PhosphorIcons.arrowLeft(), size: 25),
        ),
        title: Text(
          AppLocalizations.of(context)!.location,
          style: GoogleFonts.quicksand(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<SearchFilterCubit, SearchFilterState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  SearchTextField1(
                    controller: _searchController,
                    prefixIcon: isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2.5,
                            ),
                          )
                        : PhosphorIcon(PhosphorIcons.mapPin(), size: 21),
                    isReadOnly: false,
                    isAutoFocus: true,
                    suffixIcon: Icon(Icons.cancel_outlined, size: 20),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        fetchData(value);
                      }
                    },
                  ),
                  const SizedBox(height: 30),

                  isShow == false
                      ? Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                isGranted
                                    ? LocationSearchCard(
                                        onTap: () async {
                                          if (state.locationName !=
                                              'Current location') {
                                            final status =
                                                MapHelper.checkPermission();
                                            if (status ==
                                                PermissionStatus.granted) {
                                              final currentPosition =
                                                  await Geolocator.getCurrentPosition();

                                              context
                                                  .read<SearchFilterCubit>()
                                                  .updateSearch(
                                                    state.update(
                                                      location:
                                                          'Current location',
                                                      category: state.category,
                                                      timeText: state.timeText,
                                                      dateText: state.dateText,
                                                      date: state.date,
                                                      startTime:
                                                          state.startTime,
                                                      endTime: state.endTime,
                                                      lng: currentPosition
                                                          .latitude,
                                                      lat: currentPosition
                                                          .longitude,
                                                      address: null,
                                                    ),
                                                  );
                                            }
                                            context.pop();
                                          } else {
                                            setState(() {
                                              isGranted = false;
                                            });
                                          }
                                        },
                                        iconData: PhosphorIcons.navigationArrow(
                                          PhosphorIconsStyle.fill,
                                        ),
                                        title: 'Current location',
                                        iconColor: Colors.deepPurpleAccent,
                                        backgroundColor: Colors.deepPurple
                                            .withValues(alpha: 0.12),
                                      )
                                    : Row(
                                        spacing: 10,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.error_outline_rounded),
                                          Expanded(
                                            child: Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.locationPermission,
                                              maxLines: 5,
                                              style: GoogleFonts.quicksand(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                if (session != null)
                                  BlocBuilder<
                                    UserAddressBloc,
                                    UserAddressState
                                  >(
                                    // listenWhen: (previous, current) => previous != current,
                                    // listener: (BuildContext context, state) {
                                    //   if(state.error != null){
                                    //     SnackBarHelper.showError(state.error.toString());
                                    //   }
                                    // },
                                    builder: (context, addressState) {
                                      if (addressState.isLoading) {
                                        return SizedBox.shrink();
                                      }

                                      return Column(
                                        children: [
                                          const SizedBox(height: 30),
                                          SectionHeader(
                                            title: AppLocalizations.of(
                                              context,
                                            )!.myAddresses,
                                            titleButton: AppLocalizations.of(
                                              context,
                                            )!.manage,
                                            onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    BlocProvider.value(
                                                      value: context
                                                          .read<
                                                            UserAddressBloc
                                                          >(),
                                                      child: MyAddressPage(),
                                                    ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 20),
                                          addressState.homeAddress != null
                                              ? LocationSearchCard(
                                                  onTap: () {
                                                    if (state.locationName
                                                            .toLowerCase() !=
                                                        'home') {
                                                      context
                                                          .read<
                                                            SearchFilterCubit
                                                          >()
                                                          .updateSearch(
                                                            state.update(
                                                              location: 'Home',
                                                              category: state
                                                                  .category,
                                                              timeText: state
                                                                  .timeText,
                                                              dateText: state
                                                                  .dateText,
                                                              date: state.date,
                                                              startTime: state
                                                                  .startTime,
                                                              endTime:
                                                                  state.endTime,
                                                              lng: addressState
                                                                  .homeAddress!
                                                                  .lng,
                                                              lat: addressState
                                                                  .homeAddress!
                                                                  .lat,
                                                              address: addressState
                                                                  .homeAddress!
                                                                  .name,
                                                            ),
                                                          );
                                                    }
                                                    context.pop();
                                                  },
                                                  iconData: PhosphorIcons.house(
                                                    PhosphorIconsStyle.fill,
                                                  ),
                                                  title: 'Home',
                                                  iconColor:
                                                      Colors.deepPurpleAccent,
                                                  backgroundColor: Colors
                                                      .deepPurpleAccent
                                                      .withValues(alpha: 0.15),
                                                )
                                              : LocationSearchCard(
                                                  onTap: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          BlocProvider.value(
                                                            value: context
                                                                .read<
                                                                  UserAddressBloc
                                                                >(),
                                                            child:
                                                                AddMyAddressPage(
                                                                  addressName:
                                                                      'Home',
                                                                ),
                                                          ),
                                                    ),
                                                  ),
                                                  iconData: PhosphorIcons.house(
                                                    PhosphorIconsStyle.fill,
                                                  ),
                                                  title: AppLocalizations.of(
                                                    context,
                                                  )!.addHome,
                                                  iconColor: Colors.black54,
                                                  backgroundColor: Colors.grey
                                                      .withValues(alpha: 0.15),
                                                ),

                                          const SizedBox(height: 15),
                                          addressState.workAddress != null
                                              ? LocationSearchCard(
                                                  onTap: () {
                                                    if (state.locationName
                                                            .toLowerCase() !=
                                                        'work') {
                                                      context
                                                          .read<
                                                            SearchFilterCubit
                                                          >()
                                                          .updateSearch(
                                                            state.update(
                                                              location: 'Work',
                                                              category: state
                                                                  .category,
                                                              timeText: state
                                                                  .timeText,
                                                              dateText: state
                                                                  .dateText,
                                                              date: state.date,
                                                              startTime: state
                                                                  .startTime,
                                                              endTime:
                                                                  state.endTime,
                                                              lng: addressState
                                                                  .workAddress!
                                                                  .lng,
                                                              lat: addressState
                                                                  .workAddress!
                                                                  .lat,
                                                              address: addressState
                                                                  .workAddress!
                                                                  .name,
                                                            ),
                                                          );
                                                    }
                                                    context.pop();
                                                  },
                                                  iconData:
                                                      PhosphorIcons.briefcase(
                                                        PhosphorIconsStyle.fill,
                                                      ),
                                                  title: AppLocalizations.of(
                                                    context,
                                                  )!.work,
                                                  iconColor:
                                                      Colors.deepPurpleAccent,
                                                  backgroundColor: Colors
                                                      .deepPurpleAccent
                                                      .withValues(alpha: 0.15),
                                                )
                                              : LocationSearchCard(
                                                  onTap: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          BlocProvider.value(
                                                            value: context
                                                                .read<
                                                                  UserAddressBloc
                                                                >(),
                                                            child:
                                                                AddMyAddressPage(
                                                                  addressName:
                                                                      'Work',
                                                                ),
                                                          ),
                                                    ),
                                                  ),
                                                  iconData:
                                                      PhosphorIcons.briefcase(
                                                        PhosphorIconsStyle.fill,
                                                      ),
                                                  title: AppLocalizations.of(
                                                    context,
                                                  )!.addWork,
                                                  iconColor: Colors.black54,
                                                  backgroundColor: Colors.grey
                                                      .withValues(alpha: 0.15),
                                                ),

                                          const SizedBox(height: 15),
                                          if (addressState
                                              .anotherAddress
                                              .isNotEmpty)
                                            ListView.separated(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: addressState
                                                  .anotherAddress
                                                  .length,
                                              itemBuilder: (context, index) {
                                                return LocationSearchCard(
                                                  onTap: () {},
                                                  iconData:
                                                      PhosphorIcons.briefcase(
                                                        PhosphorIconsStyle
                                                            .fill,
                                                      ),
                                                  title: addressState
                                                      .anotherAddress[index]
                                                      .name,
                                                  iconColor:
                                                      Colors.deepPurpleAccent,
                                                  backgroundColor: Colors
                                                      .deepPurpleAccent
                                                      .withValues(
                                                        alpha: 0.15,
                                                      ),
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) {
                                                    return const SizedBox(
                                                      height: 15,
                                                    );
                                                  },
                                            ),
                                        ],
                                      );
                                    },
                                  ),

                                FutureBuilder(
                                  future: recentLocations,
                                  builder: (context, snap) {
                                    if (snap.connectionState ==
                                        ConnectionState.waiting) {
                                      return SizedBox.shrink();
                                    }

                                    if (!snap.hasData) {
                                      return SizedBox.shrink();
                                    } else {
                                      final locations = snap.data;
                                      if (locations!.isEmpty) {
                                        return SizedBox.shrink();
                                      } else {
                                        return Column(
                                          children: [
                                            const SizedBox(height: 30),
                                            SectionHeader(
                                              title: AppLocalizations.of(
                                                context,
                                              )!.recent,
                                              titleButton: AppLocalizations.of(
                                                context,
                                              )!.clear,
                                              onPressed: () {
                                                RecentlySearchService.clearRecentLocations();
                                                setState(() {
                                                  recentLocations =
                                                      RecentlySearchService.getRecentLocations();
                                                });
                                              },
                                            ),
                                            const SizedBox(height: 20),
                                            ListView.separated(
                                              itemBuilder: (context, index) {
                                                return RecentLocationCard(
                                                  mainText:
                                                      locations[index]['name'],
                                                  secondText:
                                                      locations[index]['address'],
                                                  onTap: () {
                                                    context
                                                        .read<
                                                          SearchFilterCubit
                                                        >()
                                                        .updateSearch(
                                                          state.copyWith(
                                                            location:
                                                                locations[index]['name'],
                                                            lng:
                                                                locations[index]['lng'],
                                                            lat:
                                                                locations[index]['lat'],
                                                            address:
                                                                locations[index]['address'],
                                                          ),
                                                        );
                                                    context.pop();
                                                  },
                                                );
                                              },
                                              separatorBuilder:
                                                  (
                                                    BuildContext context,
                                                    int index,
                                                  ) {
                                                    return const SizedBox(
                                                      height: 20,
                                                    );
                                                  },
                                              itemCount: locations.length,
                                              shrinkWrap: true,
                                            ),
                                          ],
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      : Expanded(child: _buildListView(state)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListView(SearchFilterState state) {
    return ListView.separated(
      itemCount: places.length < 5 ? places.length : 5,
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 0),
      itemBuilder: (_, index) {
        final coordinate = places[index];

        return ListTile(
          horizontalTitleGap: 5,
          leading: Container(
            margin: const EdgeInsets.only(right: 10),
            height: 40,
            width: 40,
            child: Center(
              child: PhosphorIcon(
                PhosphorIcons.mapPin(PhosphorIconsStyle.fill),
                size: 21,
                color: Colors.black54,
              ),
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.withValues(alpha: 0.15),
            ),
          ),
          title: Text(
            coordinate['structured_formatting']['main_text'],
            softWrap: true,
            style: GoogleFonts.quicksand(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            coordinate['structured_formatting']['secondary_text'],
            softWrap: true,
            style: GoogleFonts.quicksand(
              color: Colors.black.withValues(alpha: 0.3),
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: () async {
            setState(() {
              isLoading = true;
            });

            try {
              final url = Uri.parse(
                'https://rsapi.goong.io/place/detail?place_id=${coordinate['place_id']}&api_key=i9WBxoabU5xQF7ViPKwrEIp5roEEUfs0ZvxBOf7C',
              );
              var response = await http.get(url);
              final jsonResponse = jsonDecode(response.body);

              details = jsonResponse['result'];
              _searchController.text = details['name'];
            } catch (e) {
              SnackBarHelper.showError(e.toString());
            } finally {
              if (!mounted) return;

              setState(() {
                isLoading = false;
              });

              context.read<SearchFilterCubit>().updateSearch(
                state.copyWith(
                  location: details['name'],
                  lng: details['geometry']['location']['lng'],
                  lat: details['geometry']['location']['lat'],
                  address:
                      coordinate['structured_formatting']['secondary_text'],
                ),
              );
              context.pop();
            }
          },
        );
      },
    );
  }
}

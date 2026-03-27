import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotrue/gotrue.dart';
import 'package:healio_app/core/utils/date_time_helper.dart';
import 'package:healio_app/core/utils/map_helper.dart';
import 'package:healio_app/features/auth/domain/usecases/check_user_session_usecase.dart';
import 'package:healio_app/features/explore/presentation/blocs/search_cubit.dart';
import 'package:healio_app/features/explore/presentation/blocs/search_state.dart';
import 'package:healio_app/features/explore/presentation/widgets/recent_search_card.dart';
import 'package:healio_app/features/explore/presentation/widgets/search_text_field_2.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/injector/dependency_injector.dart';
import '../../../../core/services/recently_search_service.dart';
import '../widgets/explore_grid.dart';
import '../../../widgets/section_header.dart';
import '../../../home/presentation/widgets/top_categories_grid.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  late final Session? session;
  Future<List<Map<String, dynamic>>> recentSearchFuture = RecentlySearchService.getRecentSearch();

  void _categorySearchOnTap(SearchFilterState state) async{
    final result = await context.push<String>('/explore/search/category-search');

    if(result != null){
      setState(() {
        context.read<SearchFilterCubit>().updateSearch(state.copyWith(category: result));
      });
    }
  }

  void _locationSearchOnTap() {
    context.push('/explore/search/location-search');
  }

  void _timeSearchOnTap(SearchFilterState state) {
    context.push(
        '/explore/search/time-search',
        extra: {
          'date' : state.date,
          'startTime' : state.startTime,
          'endTime' : state.endTime,
          'timeText' : state.timeText,
          'dateText' : state.dateText
        }
    );
  }

  void _searchOnPressed(SearchFilterState state) async{
    if(state.category != 'All treatments' || state.dateText.toLowerCase() != 'any date' || state.timeText.toLowerCase() != 'anytime' || state.locationName.toLowerCase() != 'current location'){
      await RecentlySearchService.addRecentSearch(state.locationName, state.lat, state.lng, state.date, state.startTime, state.endTime, state.category, state.dateText, state.timeText);
    }
    if(state.locationName != 'Current location' && state.address != null && state.lng != null && state.lat != null){
      await RecentlySearchService.addRecentLocation(state.locationName, state.address!, state.lat!, state.lng!);
    }
    context.pop('search');
  }

  @override
  void initState() {
    super.initState();
    session = inj<CheckUserSessionUseCase>().call();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchFilterCubit, SearchFilterState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Search',
                              style: GoogleFonts.quicksand(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.pop(),
                              child: Icon(Icons.close_rounded, size: 25,),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 35,),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: SearchTextField2(
                              content: state.category,
                              iconWidget: PhosphorIcon(
                                PhosphorIcons.magnifyingGlass(), size: 20,),
                              onTap: () => _categorySearchOnTap(state)
                          )
                      ),
                      const SizedBox(height: 10,),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: SearchTextField2(
                            content: state.locationName,
                            iconWidget: PhosphorIcon(
                              PhosphorIcons.mapPin(), size: 20,),
                            onTap: () => _locationSearchOnTap(),
                          )
                      ),
                      const SizedBox(height: 10,),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: SearchTextField2(
                            content: state.timeText.toLowerCase() != 'custom'
                                ? state.timeText
                                : DateTimeHelper.transformTime24To12(state.startTime!.hour) + ' - ' + DateTimeHelper.transformTime24To12(state.endTime!.hour),
                            secondContent: state.dateText,
                            iconWidget: PhosphorIcon(
                              PhosphorIcons.calendarBlank(), size: 20,),
                            onTap: () => _timeSearchOnTap(state),
                          )
                      ),

                      FutureBuilder(
                          future: recentSearchFuture,
                          builder: (context, snap){
                            if(snap.connectionState == ConnectionState.waiting){
                              return SizedBox.shrink();
                            }

                            if(!snap.hasData){
                              return SizedBox.shrink();
                            } else{
                              final searchList = snap.data;

                              if(searchList!.isEmpty){
                                return SizedBox.shrink();
                              } else{
                                return Column(
                                  children: [
                                    const SizedBox(height: 30,),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: SectionHeader(
                                          title: 'Recent',
                                          titleButton: 'Clear',
                                          onPressed: () async {
                                            await RecentlySearchService.clearRecentSearch();
                                            setState(() {
                                              recentSearchFuture = RecentlySearchService.getRecentSearch();
                                            });
                                          },
                                        )
                                    ),
                                    const SizedBox(height: 15,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: ListView.separated(
                                        itemBuilder: (context, index){
                                          final startParts = searchList[index]['startTime'].toString().split(':');
                                          final endParts = searchList[index]['endTime'].toString().split(':');

                                          return RecentSearchCard(
                                            category: searchList[index]['category'],
                                            location: searchList[index]['address'],
                                            time: searchList[index]['timeText'],
                                            date: searchList[index]['dateText'],
                                            onTap: () {
                                              context.read<SearchFilterCubit>().updateSearch(
                                                  state.update(
                                                    category: searchList[index]['category'],
                                                    location: searchList[index]['address'],
                                                    timeText: searchList[index]['timeText'],
                                                    dateText: searchList[index]['dateText'],
                                                    date: searchList[index]['date'],
                                                    startTime: TimeOfDay(hour: int.parse(startParts[0]), minute: int.parse(startParts[1])),
                                                    endTime: TimeOfDay(hour: int.parse(endParts[0]), minute: int.parse(endParts[1])),
                                                    lat: searchList[index]['lat'],
                                                    lng: searchList[index]['lng']
                                                  )
                                              );
                                              context.pop('search');
                                            },
                                          );
                                        },
                                        separatorBuilder: (BuildContext context, int index) {
                                          return const SizedBox(height: 15,);
                                        },
                                        itemCount: searchList.length,
                                        shrinkWrap: true,
                                      )
                                    ),
                                  ],
                                );
                              }
                            }
                          }
                      ),

                      const SizedBox(height: 30,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SectionHeader(
                            title: 'Explore',
                            titleButton: 'See all',
                            onPressed: () {}),
                      ),
                      const SizedBox(height: 15,),
                      const ExploreGrid(),

                      const SizedBox(height: 30,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SectionHeader(
                            title: 'Top categories',
                            titleButton: 'See all',
                            onPressed: () {}
                        ),
                      ),
                      const SizedBox(height: 15,),
                      const TopCategoriesGrid(),
                      const SizedBox(height: 100),
                    ],
                  ),
                )
            ),
            bottomSheet: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                child: Row(
                  spacing: 10,
                  children: [
                    Flexible(
                        fit: FlexFit.tight,
                        child: OutlinedButton(
                            onPressed: () {
                              context.pop('clear');
                            },
                            style: FilledButton.styleFrom(
                                backgroundColor: Colors.white,
                                minimumSize: Size(double.infinity, 50),
                                side: BorderSide(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    width: 1
                                )
                            ),
                            child: Text('Clear all', style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            ),)
                        )
                    ),
                    Flexible(
                        fit: FlexFit.tight,
                        child: FilledButton(
                            onPressed: () => _searchOnPressed(state),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.black,
                              minimumSize: Size(double.infinity, 50),
                            ),
                            child: Text('Search', style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),)
                        )
                    )
                  ],
                ),
              ),
            )
          );
        }
    );
  }
}

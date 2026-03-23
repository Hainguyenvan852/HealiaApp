import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotrue/gotrue.dart';
import 'package:healio_app/core/utils/date_time_helper.dart';
import 'package:healio_app/features/auth/domain/usecases/check_user_session_usecase.dart';
import 'package:healio_app/features/explore/presentation/widgets/recent_search_card.dart';
import 'package:healio_app/features/explore/presentation/widgets/search_text_field_2.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/injector/dependency_injector.dart';
import '../widgets/explore_grid.dart';
import '../../../widgets/section_header.dart';
import '../../../home/presentation/widgets/top_categories_grid.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _category = 'All treatments and venues';
  String _location = 'Current location';
  String _time = '';
  String _date = 'Anytime';
  late final Session? session;

  void _categorySearchOnTap() async{
    final result = await context.push<String>('/explore/search/category-search');

    if(result != null){
      setState(() {
        _category = result;
      });
    }
  }

  void _locationSearchOnTap() async{
    final result = await context.push<dynamic>('/explore/search/location-search');

    setState(() {
      if(result != null){
        if(result is String){
          _location = result;
        } else{
          _location = result['name'];
        }
      }
    });
  }

  void _timeSearchOnTap() async{
    final result = await context.push<Map<String, dynamic>>('/explore/search/time-search');

    setState(() {
      if(result != null){
        if(DateFormat('MMM dd,yyyy').format(result['date']) == DateFormat('MMM dd,yyyy').format(DateTime.now())){
          _date = 'Today';
        } else if (DateFormat('MMM dd,yyyy').format(result['date']) == DateFormat('MMM dd,yyyy').format(DateTime.now().add(Duration(days: 1)))){
          _date = 'Tomorrow';
        } else{
          _date = DateFormat('MMM dd,yyyy').format(result['date']);
        }

        if(result['time-type'] == 'Custom'){
          TimeOfDay startTime = result['start-time'];
          TimeOfDay endTime = result['end-time'];

          _time = DateTimeHelper.transformTime24To12(startTime.hour) + ' - ' + DateTimeHelper.transformTime24To12(endTime.hour);
        } else{
          _time = result['time-type'];
        }
      }
    });
  }


  @override
  void initState() {
    super.initState();
    session = inj<CheckUserSessionUseCase>().call();
  }

  @override
  Widget build(BuildContext context) {
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
                    content: _category,
                    iconWidget: PhosphorIcon(PhosphorIcons.magnifyingGlass(), size: 20,),
                    onTap:() => _categorySearchOnTap()
                )
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SearchTextField2(
                  content: _location,
                  iconWidget: PhosphorIcon(PhosphorIcons.mapPin(), size: 20,),
                  onTap: () => _locationSearchOnTap(),
                )
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SearchTextField2(
                  content: _date,
                  secondContent: _time,
                  iconWidget: PhosphorIcon(PhosphorIcons.calendarBlank(), size: 20,),
                  onTap: () => _timeSearchOnTap(),
                )
              ),

              if(session != null)
                Column(
                children: [
                  const SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SectionHeader(title: 'Recent', titleButton: 'Clear', onPressed: (){},)
                  ),
                  const SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: RecentSearchCard(category: 'All treatments', location: 'Haiphong, Hai Phong, Vietnam', time: 'Thu 26 Mar'),
                  ),
                  const SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: RecentSearchCard(category: 'Nails', location: 'Haiphong, Hai Phong, Vietnam', time: 'Thu 26 Mar'),
                  ),
                ],
              ),

              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SectionHeader(title: 'Explore', titleButton: 'See all', onPressed: (){}),
              ),
              const SizedBox(height: 15,),
              const ExploreGrid(),

              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SectionHeader(title: 'Top categories', titleButton: 'See all', onPressed: (){}),
              ),
              const SizedBox(height: 15,),
              const TopCategoriesGrid(),
              const SizedBox(height: 40),
            ],
          ),
        ),
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
                    onPressed: (){
                      setState(() {
                        _category = 'All treatments and venues';
                        _location = 'Current location';
                        _time = '';
                        _date = 'Anytime';
                      });
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
                    onPressed: () => {},
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
    ),
    );
  }
}

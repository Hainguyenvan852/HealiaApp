import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/features/home/presentation/bloc/store_bloc.dart';
import 'package:healio_app/features/explore/presentation/widgets/explore_grid.dart';
import 'package:healio_app/features/home/presentation/widgets/home_header.dart';
import 'package:healio_app/features/home/presentation/widgets/home_page_shimmer.dart';
import 'package:healio_app/features/widgets/section_header.dart';
import 'package:healio_app/features/home/presentation/widgets/store_horizontal_list.dart';
import 'package:healio_app/features/home/presentation/widgets/top_categories_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late TimeOfDay? _selectedCustomTimeStart;
  late TimeOfDay? _selectedCustomTimeEnd;

  Map<String, String> _selectedTime = {
    'type' : 'anytime'
  };

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _selectedCustomTimeStart = null;
    _selectedCustomTimeEnd = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreBloc, StoreState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state){
          if(state.error != null){
            SnackBarHelper.showError(state.error.toString());
          }
        },
        builder: (context, state){
          if(state.isLoading){
            return HomePageShimmer();
          }
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50,),
                      const HomeHeader(),

                      if(state.recentlyStores.isNotEmpty)
                        const SizedBox(height: 40,),
                      if(state.recentlyStores.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: const SectionHeader(title: 'Recently viewed', titleButton: 'See all',),
                        ),
                      if(state.recentlyStores.isNotEmpty)
                        const SizedBox(height: 10,),
                      if(state.recentlyStores.isNotEmpty)
                        StoreHorizontalList(stores: state.recentlyStores),

                      const SizedBox(height: 40,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: const SectionHeader(title: 'Recommended', titleButton: 'See all',),
                      ),
                      const SizedBox(height: 10,),
                      StoreHorizontalList(stores: state.recommendStores),


                      const SizedBox(height: 40,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: const SectionHeader(title: 'New to Healia', titleButton: 'See all',),
                      ),
                      const SizedBox(height: 10,),
                      StoreHorizontalList(stores: state.newlyStores),

                      const SizedBox(height: 40,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: const SectionHeader(title: 'Trending', titleButton: 'See all',),
                      ),
                      const SizedBox(height: 10,),
                      StoreHorizontalList(stores: state.trendingStores),

                      const SizedBox(height: 40,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SectionHeader(title: 'Explore', titleButton: 'See all', onPressed: (){},),
                      ),
                      const SizedBox(height: 10,),
                      const ExploreGrid(),

                      const SizedBox(height: 40,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SectionHeader(title: 'Top categories', titleButton: 'See all', onPressed: (){}),
                      ),
                      const SizedBox(height: 10,),
                      const TopCategoriesGrid(),
                      const SizedBox(height: 40),
                    ]
                ),
              ),
            ),
          );
        }
    );
  }
}

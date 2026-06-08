import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/features/user/home/presentation/bloc/store_bloc.dart';
import 'package:healio_app/features/user/explore/presentation/widgets/explore_grid.dart';
import 'package:healio_app/features/user/home/presentation/widgets/home_header.dart';
import 'package:healio_app/features/user/home/presentation/widgets/home_page_shimmer.dart';
import 'package:healio_app/features/user/widgets/section_header.dart';
import 'package:healio_app/features/user/home/presentation/widgets/store_horizontal_list.dart';
import 'package:healio_app/features/user/home/presentation/widgets/top_categories_grid.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import '../../../explore/presentation/blocs/e_store_bloc.dart';
import '../../../explore/presentation/blocs/search_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _onCategoryTap(BuildContext context) {
    final searchCubit = context.read<SearchFilterCubit>();
    if (searchCubit.state.category != 'All treatments') {
      searchCubit.updateSearch(
        searchCubit.state.copyWith(category: 'All treatments'),
      );
      final finalState = searchCubit.state;

      context.go('/explore');

      context.read<EStoreBloc>().add(
        SearchByFilter(
          userLat: finalState.lat ?? 21.024536278826037,
          userLng: finalState.lng ?? 105.83668830463456,
          radiusKm: 20,
          category: finalState.category.trim(),
          date: finalState.date,
          startTime: finalState.startTime,
          endTime: finalState.endTime,
        ),
      );
    } else {
      context.go('/explore');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreBloc, StoreState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state.error != null) {
          SnackBarHelper.showError(state.error.toString());
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return HomePageShimmer();
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  HomeHeader(onTap: () => context.go('/explore')),

                  if (state.recentlyStores.isNotEmpty)
                    const SizedBox(height: 40),
                  if (state.recentlyStores.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SectionHeader(
                        title: AppLocalizations.of(context)!.recentlyViewed,
                        titleButton: AppLocalizations.of(context)!.seeAll,
                      ),
                    ),
                  if (state.recentlyStores.isNotEmpty)
                    const SizedBox(height: 10),
                  if (state.recentlyStores.isNotEmpty)
                    StoreHorizontalList(stores: state.recentlyStores),

                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SectionHeader(
                      title: AppLocalizations.of(context)!.recommended,
                      titleButton: AppLocalizations.of(context)!.seeAll,
                    ),
                  ),
                  const SizedBox(height: 10),
                  StoreHorizontalList(stores: state.recommendStores),

                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SectionHeader(
                      title: AppLocalizations.of(context)!.newToHealia,
                    ),
                  ),
                  const SizedBox(height: 10),
                  StoreHorizontalList(stores: state.newlyStores),

                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SectionHeader(
                      title: AppLocalizations.of(context)!.trending,
                    ),
                  ),
                  const SizedBox(height: 10),
                  StoreHorizontalList(stores: state.trendingStores),

                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SectionHeader(
                      title: AppLocalizations.of(context)!.explore,
                      titleButton: AppLocalizations.of(context)!.seeAll,
                      onPressed: () => _onCategoryTap(context),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const ExploreGrid(),

                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SectionHeader(
                      title: AppLocalizations.of(context)!.topCategories,
                      titleButton: AppLocalizations.of(context)!.seeAll,
                      onPressed: () => _onCategoryTap(context),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const TopCategoriesGrid(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

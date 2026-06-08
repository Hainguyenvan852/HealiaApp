import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:healio_app/features/user/explore/presentation/blocs/e_store_bloc.dart';
import 'package:healio_app/features/user/explore/presentation/blocs/search_cubit.dart';

class ExploreGrid extends StatelessWidget {
  const ExploreGrid({super.key});

  void _onCategoryTap(BuildContext context, String category) {
    final searchCubit = context.read<SearchFilterCubit>();
    searchCubit.updateSearch(searchCubit.state.copyWith(category: category));

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
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          crossAxisCount: 2,
          mainAxisExtent: 120,
        ),
        children: [
          // Hair & styling
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => _onCategoryTap(context, 'Hair'),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.asset(
                      'assets/images/hair-salon-banner.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 15,
                bottom: 15,
                child: Text(
                  AppLocalizations.of(context)!.hairSalons,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          // Barbering
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => _onCategoryTap(context, 'Barber'),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.asset(
                      'assets/images/barber-banner.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 15,
                bottom: 15,
                child: Text(
                  AppLocalizations.of(context)!.barbers,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          // Nails
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => _onCategoryTap(context, 'Nail'),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.asset(
                      'assets/images/nail-banner.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 15,
                bottom: 15,
                child: Text(
                  AppLocalizations.of(context)!.nails,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          // Massage
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => _onCategoryTap(context, 'Massage'),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.asset(
                      'assets/images/massage-banner.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 15,
                bottom: 15,
                child: Text(
                  AppLocalizations.of(context)!.massage,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          // Medspas
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => _onCategoryTap(context, 'Medspas'),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.asset(
                      'assets/images/medspa-banner.webp',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 15,
                bottom: 15,
                child: Text(
                  AppLocalizations.of(context)!.medspas,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          // Spa & sauna
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => _onCategoryTap(context, 'Spa'),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.asset(
                      'assets/images/spa-banner.webp',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 15,
                bottom: 15,
                child: Text(
                  AppLocalizations.of(context)!.spaAndSauna,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/l10n/app_localizations.dart';

import '../../../explore/presentation/blocs/e_store_bloc.dart';
import '../../../explore/presentation/blocs/search_cubit.dart';

class TopCategoriesGrid extends StatelessWidget {
  const TopCategoriesGrid({super.key});

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
          crossAxisCount: 3,
          mainAxisExtent: 150,
        ),
        children: [
          GestureDetector(
            onTap: () => _onCategoryTap(context, 'Aesthetic'),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    'assets/images/aesthetic.png',
                    fit: BoxFit.cover,
                    height: 90,
                    width: 90,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  textAlign: TextAlign.center,
                  AppLocalizations.of(context)!.aesthetics,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _onCategoryTap(context, 'Barber'),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    'assets/images/barbering.png',
                    fit: BoxFit.cover,
                    height: 90,
                    width: 90,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  textAlign: TextAlign.center,
                  AppLocalizations.of(context)!.barbering,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _onCategoryTap(context, 'Body'),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    'assets/images/body.png',
                    fit: BoxFit.cover,
                    height: 90,
                    width: 90,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 90,
                  child: Text(
                    textAlign: TextAlign.center,
                    AppLocalizations.of(context)!.body,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _onCategoryTap(context, 'Hair'),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    'assets/images/hair-and-styling.webp',
                    fit: BoxFit.cover,
                    height: 90,
                    width: 90,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 90,
                  child: Text(
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    AppLocalizations.of(context)!.hairAndStyling,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _onCategoryTap(context, 'Makeup'),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    'assets/images/makeup.jpg',
                    fit: BoxFit.cover,
                    height: 90,
                    width: 90,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  textAlign: TextAlign.center,
                  AppLocalizations.of(context)!.makeup,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _onCategoryTap(context, 'Massage'),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    'assets/images/massage.jpg',
                    fit: BoxFit.cover,
                    height: 90,
                    width: 90,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  textAlign: TextAlign.center,
                  AppLocalizations.of(context)!.massage,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _onCategoryTap(context, 'Nails'),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    'assets/images/nail.jpeg',
                    fit: BoxFit.cover,
                    height: 90,
                    width: 90,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  textAlign: TextAlign.center,
                  AppLocalizations.of(context)!.nails,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _onCategoryTap(context, 'Spa'),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    'assets/images/spa.png',
                    fit: BoxFit.cover,
                    height: 90,
                    width: 90,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 90,
                  child: Text(
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    AppLocalizations.of(context)!.spaAndSauna,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _onCategoryTap(context, 'Tattoo'),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    'assets/images/tattoo.png',
                    fit: BoxFit.cover,
                    height: 90,
                    width: 90,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 90,
                  child: Text(
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    AppLocalizations.of(context)!.tattooAndPiercing,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

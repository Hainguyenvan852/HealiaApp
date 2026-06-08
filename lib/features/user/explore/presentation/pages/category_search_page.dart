import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/features/user/explore/presentation/widgets/category_search_card.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CategorySearchPage extends StatefulWidget {
  const CategorySearchPage({super.key});

  @override
  State<CategorySearchPage> createState() => _CategorySearchPageState();
}

class _CategorySearchPageState extends State<CategorySearchPage> {
  final _categoryCtrl = TextEditingController();

  @override
  void dispose() {
    _categoryCtrl.dispose();
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
          AppLocalizations.of(context)!.search,
          style: GoogleFonts.quicksand(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                AppLocalizations.of(context)!.treatments,
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              CategorySearchCard(
                title: AppLocalizations.of(context)!.hairAndStyling,
                prefixIcon: Transform.flip(
                  flipX: true,
                  child: PhosphorIcon(
                    PhosphorIcons.hairDryer(),
                    size: 20,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context, 'Hair & styling');
                },
              ),
              const SizedBox(height: 20),
              CategorySearchCard(
                title: AppLocalizations.of(context)!.nails,
                prefixIcon: Image.asset(
                  'assets/icons/nail.png',
                  color: Colors.deepPurpleAccent,
                  width: 23,
                  height: 23,
                ),
                onTap: () {
                  Navigator.pop(context, 'Nails');
                },
              ),
              const SizedBox(height: 20),
              CategorySearchCard(
                title: AppLocalizations.of(context)!.eyebrowsAndEyelashes,
                prefixIcon: Image.asset(
                  'assets/icons/eyelashes.png',
                  color: Colors.deepPurpleAccent,
                  height: 20,
                  width: 20,
                ),
                onTap: () {
                  Navigator.pop(context, 'Eyebrows & eyelashes');
                },
              ),
              const SizedBox(height: 20),
              CategorySearchCard(
                title: AppLocalizations.of(context)!.massage,
                prefixIcon: Image.asset(
                  'assets/icons/massage-bed.png',
                  color: Colors.deepPurpleAccent,
                  height: 20,
                  width: 20,
                ),
                onTap: () {
                  Navigator.pop(context, 'Massage');
                },
              ),
              const SizedBox(height: 20),
              CategorySearchCard(
                title: AppLocalizations.of(context)!.spaAndSauna,
                prefixIcon: PhosphorIcon(
                  PhosphorIcons.flowerLotus(),
                  size: 20,
                  color: Colors.deepPurpleAccent,
                ),
                onTap: () {
                  Navigator.pop(context, 'Spa & sauna');
                },
              ),
              const SizedBox(height: 20),
              CategorySearchCard(
                title: AppLocalizations.of(context)!.barbering,
                prefixIcon: Image.asset(
                  'assets/icons/barber-chair.png',
                  color: Colors.deepPurpleAccent,
                  height: 20,
                  width: 20,
                ),
                onTap: () {
                  Navigator.pop(context, 'Barbering');
                },
              ),
              const SizedBox(height: 20),
              CategorySearchCard(
                title: AppLocalizations.of(context)!.makeup,
                prefixIcon: Image.asset(
                  'assets/icons/lipstick.png',
                  color: Colors.deepPurpleAccent,
                  height: 20,
                  width: 20,
                ),
                onTap: () {
                  Navigator.pop(context, 'Makeup');
                },
              ),
              const SizedBox(height: 20),
              CategorySearchCard(
                title: AppLocalizations.of(context)!.body,
                prefixIcon: PhosphorIcon(
                  PhosphorIcons.person(PhosphorIconsStyle.light),
                  size: 20,
                  color: Colors.deepPurpleAccent,
                ),
                onTap: () {
                  Navigator.pop(context, 'Body');
                },
              ),
              const SizedBox(height: 20),
              CategorySearchCard(
                title: AppLocalizations.of(context)!.aesthetics,
                prefixIcon: PhosphorIcon(
                  PhosphorIcons.sparkle(),
                  size: 20,
                  color: Colors.deepPurpleAccent,
                ),
                onTap: () {
                  Navigator.pop(context, 'Aesthetics');
                },
              ),
              const SizedBox(height: 20),
              CategorySearchCard(
                title: AppLocalizations.of(context)!.tattooAndPiercing,
                prefixIcon: PhosphorIcon(
                  PhosphorIcons.asclepius(),
                  size: 20,
                  color: Colors.deepPurpleAccent,
                ),
                onTap: () {
                  Navigator.pop(context, 'Tattoo & piercing');
                },
              ),
              const SizedBox(height: 20),
              CategorySearchCard(
                title: AppLocalizations.of(context)!.facialAndSkincare,
                prefixIcon: PhosphorIcon(
                  PhosphorIcons.smiley(),
                  size: 20,
                  color: Colors.deepPurpleAccent,
                ),
                onTap: () {
                  Navigator.pop(context, 'Facial & skincare');
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

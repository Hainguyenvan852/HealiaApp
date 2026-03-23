import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/features/explore/presentation/widgets/category_search_card.dart';
import 'package:healio_app/features/explore/presentation/widgets/search_text_field_1.dart';
import 'package:healio_app/features/explore/presentation/widgets/venue_search_card.dart';
import 'package:healio_app/features/home/data/models/store_model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

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
          'Search',
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
              const SizedBox(height: 20),
              SearchTextField1(
                controller: _categoryCtrl,
                prefixIcon: PhosphorIcon(
                  PhosphorIcons.magnifyingGlass(),
                  size: 21,
                ),
                isReadOnly: false,
                isAutoFocus: true,
                suffixIcon: Icon(Icons.cancel_outlined, size: 20),
              ),
              const SizedBox(height: 30),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Treatments',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CategorySearchCard(
                        title: 'Hair & styling',
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
                        title: 'Nails',
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
                        title: 'Eyebrows & eyelashes',
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
                        title: 'Massage',
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
                        title: 'Barber',
                        prefixIcon: Image.asset(
                          'assets/icons/barber-chair.png',
                          color: Colors.deepPurpleAccent,
                          height: 20,
                          width: 20,
                        ),
                        onTap: () {
                          Navigator.pop(context, 'Barber');
                        },
                      ),
                      const SizedBox(height: 20),
                      CategorySearchCard(
                        title: 'Makeup',
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
                        title: 'Body',
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
                        title: 'Tattoo & piercing',
                        prefixIcon: Image.asset(
                          'assets/icons/heart-arrow.png',
                          color: Colors.deepPurpleAccent,
                          height: 22,
                          width: 22,
                        ),
                        onTap: () {
                          Navigator.pop(context, 'Tattoo & piercing');
                        },
                      ),
                      const SizedBox(height: 20),
                      CategorySearchCard(
                        title: 'Facial & skincare',
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
                      Text(
                        'Venues',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      VenueSearchCard(store: StoreModel(id: 0, name: 'Hair Cloud', email: '', address: 'Tambon Si Phum', district: '', city: '', introduction: '', phoneNumber: '', ratingNumber: 0, imageUrl: 'https://12280-whatsnew.wpnet.stylenet.com/wp-content/uploads/sites/262/2022/09/whats_new_hair_salon_murfreesboro_4.jpg', rating: 0, distance: 0, primaryCategory: 'Hair Salon', longitude: 0, latitude: 0)),
                      const SizedBox(height: 20),
                      VenueSearchCard(store: StoreModel(id: 0, name: 'Lynn Hair Wash & Eyelash Extensions HoiAn', email: '', address: '8/10 Nguyễn Thị Minh Khai, Phố Hội An', district: '', city: 'Tambon Si Phum', introduction: '', phoneNumber: '', ratingNumber: 0, imageUrl: 'https://12280-whatsnew.wpnet.stylenet.com/wp-content/uploads/sites/262/2022/09/whats_new_hair_salon_murfreesboro_4.jpg', rating: 0, distance: 0, primaryCategory: 'Beauty Salon', longitude: 0, latitude: 0)),
                      const SizedBox(height: 20),
                      VenueSearchCard(store: StoreModel(id: 0, name: 'Lynn Hair Wash & Eyelash Extensions HoiAn', email: '', address: '8/10 Nguyễn Thị Minh Khai, Phố Hội An', district: '', city: 'Tambon Si Phum', introduction: '', phoneNumber: '', ratingNumber: 0, imageUrl: 'https://12280-whatsnew.wpnet.stylenet.com/wp-content/uploads/sites/262/2022/09/whats_new_hair_salon_murfreesboro_4.jpg', rating: 0, distance: 0, primaryCategory: 'Beauty Salon', longitude: 0, latitude: 0)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

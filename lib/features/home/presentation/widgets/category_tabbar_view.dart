import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/features/home/data/models/service_model.dart';

class CategoryTabBarView extends StatelessWidget {
  const CategoryTabBarView({super.key, required this.services});
  final List<ServiceModel>? services;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: services != null ? services!.length : 0,
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    services![index].name,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    services![index].duration.toString(),
                    style: GoogleFonts.quicksand(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    services![index].priceType != 'fix'
                        ? (services![index].priceType != 'from'
                              ? 'Free'
                              : 'From ' + services![index].price.toString())
                        : services![index].price.toString(),
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                minimumSize: Size(50, 30),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black.withValues(alpha: 0.15)),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Book',
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Divider(
            height: 1,
            color: Colors.black.withValues(alpha: 0.15),
          ),
        );
      },
    );
  }
}
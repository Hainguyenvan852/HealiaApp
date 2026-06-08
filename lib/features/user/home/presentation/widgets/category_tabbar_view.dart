import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/currency_formart.dart';
import 'package:healio_app/core/utils/date_time_helper.dart';
import 'package:healio_app/features/user/home/data/models/service_model.dart';

class CategoryTabBarView extends StatelessWidget {
  const CategoryTabBarView({super.key, required this.services});
  final List<ServiceModel>? services;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(top: 10),
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
                    DateTimeHelper.minuteToHourAndMinute(services![index].duration),
                    style: GoogleFonts.quicksand(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    CurrencyFormart.formatVND(services![index].price),
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
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
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/features/home/data/models/store_model.dart';

import 'image_slide.dart';

class StoreCard2 extends StatelessWidget {
  const StoreCard2({super.key, required this.store});
  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StoreImageSlider(store: store,),
        const SizedBox(height: 15,),
        store.ratingNumber != 0
        ? Row(
            spacing: 5,
            children: [
              Expanded(child: Text(store.name, style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),)),
              Icon(FontAwesomeIcons.solidStar, color: Colors.orange, size: 14,),
              Text(store.rating.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(store.ratingNumber.toString(),
                style: TextStyle(color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold),
              )
            ],
          )
        : Row(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child:
                Text(store.name, style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
            ),)),
            Text('No rating yet',
              style: TextStyle(color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Row(
            spacing: 5,
            children: [
              Text(store.distance > 5 ? '> 5 km' : '${store.distance.toStringAsFixed(1)} km',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
              ),),
              Icon(Icons.fiber_manual_record, size: 5, color: Colors.grey.shade700,),
              Expanded(
                child: Text(store.address,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                ),),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20,),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 15
          ),
          decoration: BoxDecoration(
              color: Color.fromRGBO(247, 247, 247, 1),
              borderRadius: BorderRadius.circular(5)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('The Dao Massage', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                  ),),
                  Text('330,000 đ', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),)
                ],
              ),
              Text('1 hr - 2 hr', style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              ),)
            ],
          ),
        ),
        const SizedBox(height: 10,),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 15
          ),
          decoration: BoxDecoration(
              color: Color.fromRGBO(247, 247, 247, 1),
              borderRadius: BorderRadius.circular(5)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('The Dao Massage', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                  ),),
                  Text('330,000 đ', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),)
                ],
              ),
              Text('1 hr - 2 hr', style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              ),)
            ],
          ),
        ),
        const SizedBox(height: 10,),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 15
          ),
          decoration: BoxDecoration(
              color: Color.fromRGBO(247, 247, 247, 1),
              borderRadius: BorderRadius.circular(5)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('The Dao Massage', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                  ),),
                  Text('330,000 đ', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),)
                ],
              ),
              Text('1 hr - 2 hr', style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              ),)
            ],
          ),
        ),
        TextButton(
            onPressed: (){},
            style: TextButton.styleFrom(
                foregroundColor: Colors.purple
            ),
            child: Text('See all services',
              style: TextStyle(
                  fontWeight: FontWeight.bold
              ),
            )
        )
      ],
    );
  }
}

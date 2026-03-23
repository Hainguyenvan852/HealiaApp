import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExploreGrid extends StatelessWidget {
  const ExploreGrid({super.key});

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
            mainAxisExtent: 120
        ),
        children: [
          Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: (){},
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.asset('assets/images/hair-salon-banner.jpeg', fit: BoxFit.cover,),
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                  bottom: 15,
                  child: Text(
                    'Hair salons',
                    style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                )
              ]
          ),
          Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: (){},
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.asset('assets/images/barber-banner.jpg', fit: BoxFit.cover,),
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                  bottom: 15,
                  child: Text(
                    'Barbers',
                    style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                )
              ]
          ),
          Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: (){},
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.asset('assets/images/nail-banner.jpg', fit: BoxFit.cover,),
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                  bottom: 15,
                  child: Text(
                    'Nails',
                    style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                )
              ]
          ),
          Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: (){},
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.asset('assets/images/massage-banner.png', fit: BoxFit.cover,),
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                  bottom: 15,
                  child: Text(
                    'Massage',
                    style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                )
              ]
          ),
          Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: (){},
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.asset('assets/images/medspa-banner.webp', fit: BoxFit.cover,),
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                  bottom: 15,
                  child: Text(
                    'Medspa',
                    style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                )
              ]
          ),
          Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: (){},
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.asset('assets/images/spa-banner.webp', fit: BoxFit.cover,),
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                  bottom: 15,
                  child: Text(
                    'Spa & sauna',
                    style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                )
              ]
          ),
        ],
      ),
    );
  }
}

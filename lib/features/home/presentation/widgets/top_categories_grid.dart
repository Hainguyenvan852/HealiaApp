import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopCategoriesGrid extends StatelessWidget {
  const TopCategoriesGrid({super.key});

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
                mainAxisExtent: 150
            ),
            children: [
              GestureDetector(
                onTap: (){},
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset('assets/images/aesthetic.png', fit: BoxFit.cover, height: 90, width: 90,),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      'Aesthetics',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){},
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset('assets/images/barbering.png', fit: BoxFit.cover, height: 90, width: 90,),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      'Barbering',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){},
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset('assets/images/body.png', fit: BoxFit.cover, height: 90, width: 90,),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      'Body',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){},
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset('assets/images/hair-and-styling.webp', fit: BoxFit.cover, height: 90, width: 90,),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: 90,
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        'Hair and styling',
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){},
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset('assets/images/makeup.jpg', fit: BoxFit.cover, height: 90, width: 90,),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      'Makeup',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){},
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset('assets/images/massage.jpg', fit: BoxFit.cover, height: 90, width: 90,),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      'Massage',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){},
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset('assets/images/nail.jpeg', fit: BoxFit.cover, height: 90, width: 90,),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      'Nail',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){},
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset('assets/images/spa.png', fit: BoxFit.cover, height: 90, width: 90,),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: 90,
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        'Spa and sauna',
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){},
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset('assets/images/tattoo.png', fit: BoxFit.cover, height: 90, width: 90,),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      'Tattoo',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ]
        )
    );
  }
}

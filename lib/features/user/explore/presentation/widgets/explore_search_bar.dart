import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExploreSearchBar extends StatelessWidget {
  const ExploreSearchBar({super.key, required this.onOpen, required this.onSearchPressed, required this.category, required this.location, required this.datetime,});
  final String category;
  final String location;
  final String datetime;
  final VoidCallback onOpen;
  final VoidCallback onSearchPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: GestureDetector(
              onTap: () => onSearchPressed(),
                child: Icon(FontAwesomeIcons.magnifyingGlass, size: 20,)
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
              child: GestureDetector(
                onTap: () => onSearchPressed(),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Row(
                        children: [
                          if(datetime.isNotEmpty)
                            Text(
                              datetime,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          if(datetime.isNotEmpty)
                            const SizedBox(width: 5,),
                          if(datetime.isNotEmpty)
                            Icon(
                              Icons.fiber_manual_record,
                              size: 5,
                              color: Colors.black,
                            ),
                          if(datetime.isNotEmpty)
                            const SizedBox(width: 5,),
                          Text(
                            location,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
          ),
          IconButton.outlined(
            onPressed: onOpen,
            icon: Icon(FontAwesomeIcons.list, size: 20,),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExploreSearchBar extends StatelessWidget {
  const ExploreSearchBar({super.key, required this.onOpen, required this.onSearchPressed,});
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
                child: Icon(FontAwesomeIcons.search, size: 20,)
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
                      Text('All treatments', style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      ),),
                      Text('Current location', style: TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold
                      ),)
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

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'search_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healio App',
      home: Scaffold(
        body: IndexedStack(
          index: selectedPage,
          children: [
            SearchScreen(),
            const SizedBox(),
            const SizedBox(),
            const SizedBox(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              border: BoxBorder.fromLTRB(top: BorderSide(
                  color: Colors.grey.shade300
              ))
          ),
          child: NavigationBar(
              height: 50,
              backgroundColor: Colors.white,
              destinations: [
                GestureDetector(
                  onTap: (){
                    if(selectedPage != 0){
                      setState(() {
                        selectedPage = 0;
                      });
                    }
                  },
                  child: Icon(FontAwesomeIcons.home, size: 22, color: (selectedPage == 0) ? Colors.purple : Colors.black,),
                ),
                GestureDetector(
                    onTap: (){
                      if(selectedPage != 1){
                        setState(() {
                          selectedPage = 1;
                        });
                      }
                    },
                    child: Icon(FontAwesomeIcons.search, size: 22, color: (selectedPage == 1) ? Colors.purple : Colors.black,)
                ),
                GestureDetector(
                    onTap: (){
                      if(selectedPage != 2){
                        setState(() {
                          selectedPage = 2;
                        });
                      }
                    },
                    child: Icon(FontAwesomeIcons.calendar, size: 22, color: (selectedPage == 2) ? Colors.purple : Colors.black,)
                ),
                GestureDetector(
                    onTap: (){
                      if(selectedPage != 3){
                        setState(() {
                          selectedPage = 3;
                        });
                      }
                    },
                    child: Icon(FontAwesomeIcons.user, size: 22, color: (selectedPage == 3) ? Colors.purple : Colors.black,)
                ),
              ]
          ),
        ),
      ),
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
    );
  }
}

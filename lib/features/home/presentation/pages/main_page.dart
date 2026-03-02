import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:healio_app/features/auth/domain/usecases/check_user_session_usecase.dart';

import '../../../../core/injector/dependency_injector.dart';


class MainPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainPage({super.key, required this.navigationShell});

  void _onTap(BuildContext context, int index) {
    
    final session = inj<CheckUserSessionUseCase>().call();

    if (index == 3 && session == null) {
      context.push('/login');
      return;
    }

    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
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
                onTap: () => _onTap(context, 0),
                child: Icon(FontAwesomeIcons.home, size: 22, color: (navigationShell.currentIndex == 0) ? Colors.purple : Colors.black,),
              ),
              GestureDetector(
                  onTap: () => _onTap(context, 1),
                  child: Icon(FontAwesomeIcons.search, size: 22, color: (navigationShell.currentIndex == 1) ? Colors.purple : Colors.black,)
              ),
              GestureDetector(
                  onTap: () => _onTap(context, 2),
                  child: Icon(FontAwesomeIcons.calendar, size: 22, color: (navigationShell.currentIndex == 2) ? Colors.purple : Colors.black,)
              ),
              GestureDetector(
                  onTap: () => _onTap(context, 3),
                  child: Icon(FontAwesomeIcons.user, size: 22, color: (navigationShell.currentIndex == 3) ? Colors.purple : Colors.black,)
              ),
            ]
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:go_router/go_router.dart';
// import 'package:healio_app/features/auth/domain/usecases/check_user_session_usecase.dart';
// import 'package:healio_app/features/home/presentation/pages/appointment_page.dart';
// import 'package:healio_app/features/home/presentation/pages/home_page.dart';
// import 'package:healio_app/features/home/presentation/pages/profile_page.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// import '../../../../core/injector/dependency_injector.dart';
// import 'explore_page.dart';
//
//
// class MainPage extends StatefulWidget {
//   const MainPage({super.key});
//
//   @override
//   State<MainPage> createState() => _MainPageState();
// }
//
// class _MainPageState extends State<MainPage> {
//
//   int _currentIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _currentIndex,
//         children: [
//           const HomePage(),
//           ExplorePage(),
//           AppointmentPage(),
//           const ProfilePage()
//         ],
//       ),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//             border: BoxBorder.fromLTRB(top: BorderSide(
//                 color: Colors.grey.shade300
//             ))
//         ),
//         child: NavigationBar(
//             height: 50,
//             backgroundColor: Colors.white,
//             destinations: [
//               GestureDetector(
//                 onTap: (){
//                   if(_currentIndex != 0){
//                     setState(() {
//                       _currentIndex = 0;
//                     });
//                   }
//                 },
//                 child: Icon(FontAwesomeIcons.home, size: 22, color: (_currentIndex == 0) ? Colors.purple : Colors.black,),
//               ),
//               GestureDetector(
//                   onTap: (){
//                     if(_currentIndex != 1){
//                       setState(() {
//                         _currentIndex = 1;
//                       });
//                     }
//                   },
//                   child: Icon(FontAwesomeIcons.search, size: 22, color: (_currentIndex == 1) ? Colors.purple : Colors.black,)
//               ),
//               GestureDetector(
//                   onTap: (){
//                     if(_currentIndex != 2){
//                       setState(() {
//                         _currentIndex = 2;
//                       });
//                     }
//                   },
//                   child: Icon(FontAwesomeIcons.calendar, size: 22, color: (_currentIndex == 2) ? Colors.purple : Colors.black,)
//               ),
//               GestureDetector(
//                   onTap: (){
//                     if(_currentIndex != 3){
//                       final session = inj<CheckUserSessionUseCase>().call();
//                       if(session == null) {
//                         context.push('/login');
//                       } else{
//                         setState(() {
//                           _currentIndex = 3;
//                         });
//                       }
//                     }
//                   },
//                   child: Icon(FontAwesomeIcons.user, size: 22, color: (_currentIndex == 3) ? Colors.purple : Colors.black,)
//               ),
//             ]
//         ),
//       ),
//     );
//   }
// }

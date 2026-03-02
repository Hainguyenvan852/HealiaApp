// import 'package:flutter/material.dart';
// import 'package:healio_app/features/auth/presentation/pages/login_page.dart';
// import 'package:healio_app/features/home/presentation/pages/main_page.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class AuthGate extends StatefulWidget {
//   const AuthGate({super.key});
//
//   @override
//   State<AuthGate> createState() => _AuthGateState();
// }
//
// class _AuthGateState extends State<AuthGate> {
//   @override
//   Widget build(BuildContext context) {
//     return const MainPage();
//   }
// }

// StreamBuilder(
// stream: Supabase.instance.client.auth.onAuthStateChange,
// builder: (context, snapshot){
// if(snapshot.connectionState == ConnectionState.waiting){
// return Scaffold(
// body: Center(
// child: CircularProgressIndicator(
// color: Colors.black,
// ),
// ),
// );
// }
//
// final authEvent = snapshot.hasData ? snapshot.data!.event : null;
//
// if(authEvent == AuthChangeEvent.signedOut){
// return LoginPage();
// } else{
// return HomePage();
// }
// }
// )

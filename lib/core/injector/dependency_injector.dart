import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final inj = GetIt.instance;

Future<void> initDependencies() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: dotenv.env['']!,
      anonKey: dotenv.env['']!
  );
  final SupabaseClient supabase = Supabase.instance.client;



}
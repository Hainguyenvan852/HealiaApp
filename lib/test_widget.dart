import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/core/utils/date_time_helper.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

import 'features/explore/presentation/widgets/search_text_field_1.dart';


void main() {
  const uiStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,

    systemNavigationBarContrastEnforced: false,

    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  );

  runApp(AnnotatedRegion<SystemUiOverlayStyle>(
      value: uiStyle,
      child: MyApp()
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _searchController = TextEditingController();
  List<dynamic> places = [];
  var details = {};
  String selectedAddress = '';
  bool isShow = false;
  bool isLoading = false;


  Future<void> fetchData(String input) async {
    try {
      final url = Uri.parse(
          'https://rsapi.goong.io/Place/AutoComplete?location=21.013715429594125%2C%20105.79829597455202&input=$input&api_key=i9WBxoabU5xQF7ViPKwrEIp5roEEUfs0ZvxBOf7C');
      var response = await http.get(url);

      setState(() {
        final jsonResponse = jsonDecode(response.body);
        places = jsonResponse['predictions'] as List<dynamic>;
        isShow = true;
      });

    } catch (e) {
      SnackBarHelper.showError(e.toString());
    }
  }

  Widget _buildListView() {
    return ListView.separated(
      itemCount: places.length < 5 ? places.length : 5,
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, int index) =>
      const SizedBox(height: 0,),
      itemBuilder: (_, index) {
        final coordinate = places[index];

        return ListTile(
          horizontalTitleGap: 5,
          leading: Container(
            margin: const EdgeInsets.only(right: 10),
            height: 40,
            width: 40,
            child: Center(
              child: PhosphorIcon(PhosphorIcons.mapPin(PhosphorIconsStyle.fill), size: 21, color: Colors.black54),
            ),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withValues(alpha: 0.15)
            ),
          ),
          title: Text(
            coordinate['structured_formatting']['main_text'],
            softWrap: true,
            style: GoogleFonts.quicksand(
                color: Colors.black,
                fontWeight: FontWeight.w600
            ),
          ),
          subtitle: Text(
            coordinate['structured_formatting']['secondary_text'],
            softWrap: true,
            style: GoogleFonts.quicksand(
                color: Colors.black.withValues(alpha: 0.3),
                fontWeight: FontWeight.w600
            ),
          ),
          onTap: () async {

            setState(() {
              isLoading = true;
            });

            try {
              final url = Uri.parse(
                  'https://rsapi.goong.io/place/detail?place_id=${coordinate['place_id']}&api_key=i9WBxoabU5xQF7ViPKwrEIp5roEEUfs0ZvxBOf7C');
              var response = await http.get(url);
              final jsonResponse = jsonDecode(response.body);

              details = jsonResponse['result'];
              _searchController.text = coordinate['description'];
            } catch (e) {
              SnackBarHelper.showError(e.toString());
            } finally {
              if (!mounted) return;

              setState(() {
                selectedAddress = coordinate['description'];
                isLoading = false;
              });
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('vi', 'VN'),
        ],
        scaffoldMessengerKey: SnackBarHelper.messengerKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.quicksandTextTheme(ThemeData
              .light()
              .textTheme),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Builder(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: IconButton(
                    onPressed: (){},
                    icon: PhosphorIcon(PhosphorIcons.arrowLeft(), size: 25,)
                ),
              ),
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add Home',
                        style: GoogleFonts.quicksand(
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                        ),
                      ),

                      const SizedBox(height: 40,),
                      Text('Address *',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                      ),
                      const SizedBox(height: 5,),
                      SearchTextField1(
                        controller: _searchController,
                        prefixIcon: isLoading
                            ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5,)
                        )
                            : PhosphorIcon(PhosphorIcons.mapPin(), size: 21,),
                        isReadOnly: false,
                        isAutoFocus: true,
                        suffixIcon: Icon(Icons.cancel_outlined, size: 20,),
                        onChanged: (value) {
                          if(value.isNotEmpty){
                            fetchData(value);
                          }
                        },
                      ),

                      const SizedBox(height: 30,),
                      if (isShow == true)
                        Expanded(child: _buildListView()),
                    ],
                  ),
                ),
              ),
              bottomSheet: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Colors.black.withValues(alpha: 0.3),
                      width: 0.3
                    )
                  )
                ),
                child: FilledButton(
                    onPressed: () {
                      if(selectedAddress.isEmpty){
                        SnackBarHelper.showAlert('You haven\'t choose a address yet');
                      } else{

                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text('Save', style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),)
                ),
              ),
            );
          }
        )
    );
  }
}










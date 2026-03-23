import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotrue/gotrue.dart';
import 'package:healio_app/features/auth/domain/usecases/check_user_session_usecase.dart';
import 'package:healio_app/features/explore/presentation/widgets/location_search_card.dart';
import 'package:healio_app/features/explore/presentation/widgets/recent_location_card.dart';
import 'package:healio_app/features/widgets/section_header.dart';
import 'package:http/http.dart' as http;
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/injector/dependency_injector.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../widgets/search_text_field_1.dart';

class LocationSearchPage extends StatefulWidget {
  const LocationSearchPage({super.key});

  @override
  State<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {

  final _searchController = TextEditingController();
  late final Session? session;

  @override
  void initState() {
    super.initState();
    session = inj<CheckUserSessionUseCase>().call();
  }

  List<dynamic> places = [];
  var details = {};
  bool isShow = false;
  bool isLoading = false;

  Future<void> fetchData(String input) async {
    try {
      setState(() {
        isLoading = true;
      });
      final url = Uri.parse(
          'https://rsapi.goong.io/Place/AutoComplete?location=21.013715429594125%2C%20105.79829597455202&input=$input&api_key=i9WBxoabU5xQF7ViPKwrEIp5roEEUfs0ZvxBOf7C');
      var response = await http.get(url);

      setState(() {
        final jsonResponse = jsonDecode(response.body);
        places = jsonResponse['predictions'] as List<dynamic>;
        isShow = true;
        isLoading = false;
      });

    } catch (e) {
      SnackBarHelper.showError(e.toString());
      setState(() {
        isLoading = false;
      });
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
                isLoading = false;
              });

              context.pop(details);
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: PhosphorIcon(PhosphorIcons.arrowLeft(), size: 25,),
        ),
        title: Text('Location',
          style: GoogleFonts.quicksand(
              fontSize: 19,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
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
          
              isShow == false
              ? Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LocationSearchCard(
                        onTap: () => context.pop('Current location'),
                        iconData: PhosphorIcons.navigationArrow(PhosphorIconsStyle.fill),
                        title: 'Current location',
                        iconColor: Colors.deepPurpleAccent,
                        backgroundColor: Colors.deepPurple.withValues(alpha: 0.12 ),
                      ),

                      if(session != null)
                        Column(
                          children: [
                            const SizedBox(height: 30,),
                            SectionHeader(title: 'My addresses', titleButton: 'Manage'),
                            const SizedBox(height: 20,),
                            LocationSearchCard(
                              onTap: (){},
                              iconData: PhosphorIcons.house(PhosphorIconsStyle.fill),
                              title: 'Add home',
                              iconColor: Colors.black54,
                              backgroundColor: Colors.grey.withValues(alpha: 0.15),
                            ),
                            const SizedBox(height: 20,),
                            LocationSearchCard(
                              onTap: (){},
                              iconData: PhosphorIcons.house(PhosphorIconsStyle.fill),
                              title: 'Add work',
                              iconColor: Colors.black54,
                              backgroundColor: Colors.grey.withValues(alpha: 0.15),
                            ),
                          ],
                        ),

                      if(session != null)
                        Column(
                          children: [
                          const SizedBox(height: 30,),
                          SectionHeader(title: 'Recent', titleButton: 'Clear'),
                          const SizedBox(height: 20,),
                          RecentLocationCard(mainText: 'Haiphong', secondText: 'Haiphong, Hai Phong, Vietnam', onTap: () {},),
                          const SizedBox(height: 20,),
                          RecentLocationCard(mainText: 'Hai Ba Trung', secondText: 'Hai Ba Trung, Ha Noi, Vietnam', onTap: () {},),
                        ],
                      ),
                    ],
                  ),
                ),
              )
              : Expanded(child: _buildListView()),
            ],
          ),
        ),
      ),
    );
  }
}

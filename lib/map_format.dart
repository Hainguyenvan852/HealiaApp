import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:typed_data';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goong Sample',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Goong Sample '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Map<String, dynamic>> _stores = [
    {
      "id": "1",
      "name": "Nail Xinh Hà Nội",
      "lat": 21.028511,
      "lng": 105.854444,
    },
    {
      "id": "2",
      "name": "Lisa Nail & Spa",
      "lat": 21.030653,
      "lng": 105.847130,
    },
    {
      "id": "3",
      "name": "Omnia Hair Boutiqe",
      "lat": 21.018993452093497,
      "lng": 105.78528860875412,
    },
    {
      "id": "4",
      "name": "30Shine",
      "lat": 21.025603,
      "lng": 105.784688,
    },
  ];

  MapLibreMapController? mapController;

  LatLng? _currentPosition;
  LatLng? _destinationPoint;
  Symbol? _currentMarker;
  OverlayEntry? _popupOverlayEntry;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _currentPosition = LatLng(21.03357551700003, 105.81911236900004);
    });
  }

  void _onMapCreated(MaplibreMapController controller) async {
    mapController = controller;
    _loadMarkerImage();
    _addMarkerAtDestinationPoint();
  }

  Future<void> _loadMarkerImage() async {
    final ByteData bytes = await rootBundle.load('assets/icons/map_pin.png');
    mapController?.addImage('location', bytes.buffer.asUint8List());
  }

  void _onStyleLoadedCallback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Style loaded"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: const Duration(seconds: 1),
      ),
    );
    if (_currentPosition != null) {
      _addMarkerAtCurrentPosition();
    }
  }

  void _addMarkerAtCurrentPosition() async {
    if (mapController == null) {
      print("Map controller is not initialized");
      return;
    }

    const initialLatitude = 21.03357551700003;
    const initialLongitude = 105.81911236900004;

    try {
      mapController?.addSymbol(SymbolOptions(
        geometry: LatLng(initialLatitude, initialLongitude),
        iconImage: 'location',
        iconSize: 0.5,
        zIndex: 1, // Ensure marker is above circle
      ));
      print("Initial marker added at ($initialLatitude, $initialLongitude)");

    } catch (e) {
      print("Error adding initial marker: $e");
    }
  }

  void _addMarkerAtDestinationPoint() async {
    if (mapController == null) {
      print("Map controller is not initialized");
      return;
    }

    if (_destinationPoint == null) {
      print("Destination point is not set");
      return;
    }

    try {
      // Xóa marker hiện tại nếu có
      if (_currentMarker != null) {
        await mapController!.removeSymbol(_currentMarker!);
      }

      // Add a marker with a title
      _currentMarker = await mapController!.addSymbol(SymbolOptions(
        geometry: _destinationPoint!,
        iconImage: 'locationEnd', // Ensure this matches the loaded image name
        iconSize: 0.2,
        draggable: true,
      ));

      mapController!.onSymbolTapped.add((symbol) {
        _onMarkerTapped(symbol);
      });

      print("Marker added at ($_destinationPoint)");

      mapController!.onFeatureDrag.add((value,
        current,
        delta,
        eventType,
        origin,
        point,
        s
      ) {
        print("5656565656($origin)"); // Đây để log ra location khi draggable
      });

      // Di chuyển camera đến vị trí mới
      mapController!.animateCamera(CameraUpdate.newLatLng(_destinationPoint!));
    } catch (e) {
      print("Error adding marker: $e");
    }
  }

  void _onMarkerTapped(Symbol symbol) async {
    if (mapController == null) return;

    // Remove previous overlay if any
    _popupOverlayEntry?.remove();

    // Convert LatLng to screen coordinates
    LatLng markerLatLng = symbol.options.geometry!;
    Point<num> screenPosition = await mapController!.toScreenLocation(markerLatLng);

    // Create a new overlay entry
    _popupOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: screenPosition.x.toDouble() - 50, // Adjust based on the width of the popup
        top: screenPosition.y.toDouble() - 80, // Adjust based on the height of the popup
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.white,
            child: Text(
              symbol.options.textField ?? 'No Title',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );

    // Insert the overlay into the overlay stack
    Overlay.of(context).insert(_popupOverlayEntry!);

    // Add a handler to close the popup when tapping on another symbol
    mapController!.onSymbolTapped.add((tappedSymbol) {
      if (tappedSymbol != symbol) {
        _popupOverlayEntry?.remove();
      }
    });
  }

  final TextEditingController _searchController = TextEditingController();
  String mainText = "";
  String secondText = "";
  List<dynamic> places = [];
  var details = {};
  bool isShow = false;
  bool isHidden = true;

  Future<void> fetchData(String input) async {
    try {
      final url = Uri.parse(
          'https://rsapi.goong.io/Place/AutoComplete?location=21.013715429594125%2C%20105.79829597455202&input=$input&api_key=i9WBxoabU5xQF7ViPKwrEIp5roEEUfs0ZvxBOf7C');
      // print('url $url');
      var response = await http.get(url);
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      setState(() {
        final jsonResponse = jsonDecode(response.body);
        places = jsonResponse['predictions'] as List<dynamic>;
        print('url $url, size: ${places.length}');
        // _circleAnnotationManager?.deleteAll();
        isShow = true;
        isHidden = true;
      });
    } catch (e) {
      // ignore: avoid_print
      print('$e');
    }
  }

  Future<void> fetchDataDirection() async {
    if (_currentPosition != null && _destinationPoint != null) {
      final url = Uri.parse(
          'https://rsapi.goong.io/Direction?origin=${_currentPosition!.latitude},${_currentPosition!.longitude}&destination=${_destinationPoint!.latitude},${_destinationPoint!.longitude}&vehicle=bike&api_key=i9WBxoabU5xQF7ViPKwrEIp5roEEUfs0ZvxBOf7C');

      var response = await http.get(url);
      final jsonResponse = jsonDecode(response.body);
      var route = jsonResponse['routes'][0]['overview_polyline']['points'];

      List<PointLatLng> result = PolylinePoints.decodePolyline(route);
      List<List<double>> coordinates =
      result.map((point) => [point.longitude, point.latitude]).toList();
      _drawLine(coordinates);
    }
  }

  void _drawLine(List<List<double>> coordinates) {
    mapController?.removeLayer("line_layer");
    mapController?.removeSource("line_source");
    final geoJsonData = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "geometry": {
            "type": "LineString",
            "coordinates": coordinates,
          },
        },
      ],
    };

    mapController?.addSource(
      "line_source",
      GeojsonSourceProperties(
        data: geoJsonData,
      ),
    );

    mapController?.addLineLayer(
      "line_source",
      "line_layer",
      LineLayerProperties(
        lineColor: "#0000FF",
        lineWidth: 10,
        lineCap: "round",
        lineJoin: "round",
      ),
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      itemCount: places.length < 5 ? places.length : 5,
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, int index) =>
      const Divider(height: 1),
      itemBuilder: (context, index) {
        final coordinate = places[index];

        return ListTile(
          horizontalTitleGap: 5,
          title: Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.blue,
                size: 20,
              ),
              const SizedBox(
                width: 8,
              ),
              SizedBox(
                width: 320,
                child: Text(
                  coordinate['description'],
                  softWrap: true,
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
          onTap: () async {
            setState(() {
              isShow = false;
              isHidden = false;
            });
            final url = Uri.parse(
                'https://rsapi.goong.io/place/detail?place_id=${coordinate['place_id']}&api_key=i9WBxoabU5xQF7ViPKwrEIp5roEEUfs0ZvxBOf7C');
            var response = await http.get(url);
            final jsonResponse = jsonDecode(response.body);

            details = jsonResponse['result'];
            setState(() {
              _destinationPoint = LatLng(details['geometry']['location']['lat'],
                  details['geometry']['location']['lng']);
              _addMarkerAtDestinationPoint();
              // Thêm marker sau khi cập nhật _destinationPoint
            });

            _searchController.text = coordinate['description'];
            mainText = coordinate['structured_formatting']['main_text'];
            secondText = coordinate['structured_formatting']['secondary_text'];
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: MapLibreMap(
                onMapCreated: _onMapCreated,
                onStyleLoadedCallback: _onStyleLoadedCallback,
                initialCameraPosition: CameraPosition(// Vị trí ban đầu của bản đồ (Cái này sẽ bắt vị trí hiện tại của bạn)
                  target: LatLng(21.03357551700003,
                      105.81911236900004),
                  zoom: 13.0,
                ),

                styleString:
                'https://tiles.goong.io/assets/goong_map_highlight.json?api_key=oKtWmNNaHfeNIGQlpq5FAP9rtBTC5VDHN2w9NQR4', // URL của style
                attributionButtonPosition: null,
              ),
            ),
            Container(
              height: 70,
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.fromLTRB(5, 80, 5, 10),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 4),
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: Colors.blue,
                                size: 20,
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(left: 4, right: 8),
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: (String text) {
                                      print("onChanged: $text");
                                      fetchData(text);
                                      isHidden = true;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: "Nhập địa điểm",
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                          color: Colors.black54, fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Thực hiện hành động dẫn đường ở đây
                                  fetchDataDirection();
                                  print("Dẫn đường");
                                },
                                child: const Text(
                                  "Dẫn đường",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isShow == true)
              Container(
                margin: const EdgeInsets.fromLTRB(5, 160, 5, 0),
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                decoration: const BoxDecoration(color: Colors.white),
                child: _buildListView(),
              ),
          ],
        ),
        floatingActionButton: IconButton(
            onPressed: () async{
              mapController?.animateCamera(
                  CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: LatLng(_currentPosition!.latitude, _currentPosition!.latitude),
                          zoom: 13
                      )
                  ));
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            icon: const Icon(Icons.my_location, color: Colors.black, size: 20,)
        ),
      ),
    );
  }
}

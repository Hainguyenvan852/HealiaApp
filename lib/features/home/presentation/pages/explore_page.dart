import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:healio_app/features/home/presentation/widgets/explore_page_shimmer.dart';
import 'package:healio_app/features/home/presentation/widgets/image_slide.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:ui' as ui;

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {

  MapLibreMapController? mapController;
  final _panelCtrl = PanelController();
  Symbol? _selectedSymbol;
  bool isShowCard = false;
  final ValueNotifier<double> _panelPositionNotifier = ValueNotifier(0.0);
  final _hideOffset = 200; // Vị trí dấu đi card thông tin cửa hàng

  bool isLoading = false;

  final List<Map<String, dynamic>> _stores = [
    {
      "id": "1",
      "name": "Nail Xinh Hà Nội",
      "lat": 21.028511,
      "lng": 105.854444,
      'rating': 0
    },
    {
      "id": "2",
      "name": "Lisa Nail & Spa",
      "lat": 21.030653,
      "lng": 105.847130,
      'rating': 4.6
    },
    {
      "id": "3",
      "name": "Omnia Hair Boutiqe",
      "lat": 21.018993452093497,
      "lng": 105.78528860875412,
      'rating': 5.0
    },
    {
      "id": "4",
      "name": "30Shine",
      "lat": 21.025603,
      "lng": 105.784688,
      'rating': 0
    },
  ];

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async{
    await Permission.locationWhenInUse.request();
  }

  void _onMapCreated(MapLibreMapController controller) async{
    mapController = controller;
    mapController!.onSymbolTapped.add(_onSymbolTapped);

    try {
      final normalIcon = await createNoRatingIcon();
      await mapController!.addImage('marker-normal', normalIcon);

      final ByteData bytesSelected = await rootBundle.load('assets/icons/convenience-store.png');
      await mapController!.addImage('marker-selected', bytesSelected.buffer.asUint8List());

      if(mounted){
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã nạp ảnh marker thành công')));
      }
    } catch (e) {
      print("Lỗi nạp ảnh: $e");
    }
  }

  void _addStoreMarkers() async{
    if (mapController == null) return;

    Uint8List iconBytes;
    String iconId;
    List<SymbolOptions> optionsList = [];
    List<Map> dataList = [];

    for(var store in _stores){
      if(store['rating'] == 0 || store['rating'] == null || store['rating'] == '0'){
        optionsList.add(SymbolOptions(
          geometry: LatLng(store['lat'], store['lng']),
          iconImage: "marker-normal",
          iconSize: 1,
        ));
        dataList.add({
          'store': store,
          'iconId': 'marker-normal'
        });
        // await mapController?.addSymbol(
        //     SymbolOptions(
        //       geometry: LatLng(store['lat'], store['lng']),
        //       iconImage: 'marker-normal',
        //       iconSize: 1,
        //     ),
        //     {
        //       'store': store,
        //       'iconId': 'marker-normal'
        //     }
        // );
      } else{
        iconBytes = await createRatingIcon(store['rating'].toString());
        iconId = 'icon-rating-${_stores.indexOf(store)}';
        await mapController!.addImage(iconId, iconBytes);

        optionsList.add(SymbolOptions(
          geometry: LatLng(store['lat'], store['lng']),
          iconImage: iconId,
          iconSize: 1,
        ));
        dataList.add({
          'store': store,
          'iconId': iconId
        });

        // await mapController?.addSymbol(
        //     SymbolOptions(
        //       geometry: LatLng(store['lat'], store['lng']),
        //       iconImage: iconId,
        //       iconSize: 1,
        //     ),
        //     {
        //       'store': store,
        //       'iconId': iconId
        //     }
        // );
      }
    }

    await mapController?.addSymbols(optionsList, dataList);
  }

  Future<Map<String, dynamic>> _getCurrentPosition() async {

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){

    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Quyền truy cập vị trí bị từ chối.'))
        );
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );

    return {
      'latitude' : position.latitude,
      'longitude' : position.longitude
    };
  }

  Future<void> _onStyleLoadedCallback() async{
    if (mapController == null) return;

    await mapController!.setSymbolIconAllowOverlap(true);
    await mapController!.setSymbolIconIgnorePlacement(true);

    _addStoreMarkers();
  }

  void _onSymbolTapped(Symbol symbol) async{

    if (_selectedSymbol != null) {
      final data = _selectedSymbol!.data;
      String iconId = data!['iconId'];

      await mapController?.updateSymbol(
          _selectedSymbol!,
          SymbolOptions(iconImage: iconId, iconSize: 1)
      );
    }

    final LatLng position = symbol.options.geometry!;
    final Map dataStore = symbol.data as Map;

    await mapController?.removeSymbol(symbol);

    _selectedSymbol = await mapController?.addSymbol(
        SymbolOptions(
          geometry: position,
          iconImage: "marker-selected",
          iconSize: 0.8,
          zIndex: 10,
        ),
        dataStore
    );

    setState(() {
      isShowCard = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Quán: ${dataStore['store']['name']}"),
        )
    );
  }

  Future<Uint8List> createRatingIcon(String rating) async {
    // 1. CẤU HÌNH KÍCH THƯỚC (Bạn chỉnh sửa độ to nhỏ tại đây)
    const double width = 80;     // Chiều rộng
    const double height = 50;     // Chiều cao phần thân
    const double tailHeight = 15; // Độ dài cái đuôi
    const double tailWidth = 18;  // Độ rộng gốc cái đuôi
    const double cornerRadius = 25.0; // Độ bo góc (12 là vừa đẹp cho hình chữ nhật)

    // Tính toán kích thước tổng thể (bao gồm cả vùng đệm cho bóng đổ)
    const double shadowBlur = 8.0; // Độ nhòe bóng
    const double shadowOffset = 5.0; // Độ dịch bóng xuống dưới

    final double totalWidth = width + (shadowBlur * 2);
    final double totalHeight = height + tailHeight + (shadowBlur * 2) + shadowOffset;

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, Rect.fromPoints(Offset.zero, Offset(totalWidth, totalHeight)));

    // Dịch bút vẽ vào trong để chừa lề cho bóng đổ không bị cắt
    canvas.translate(shadowBlur, shadowBlur);

    // 2. KHỞI TẠO BÚT VẼ (Paints)

    // Bút vẽ nền trắng
    final Paint mainPaint = Paint()..color = Colors.white;

    // Bút vẽ bóng đổ (Màu đen, độ mờ 40%, nhòe 8px)
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, shadowBlur);

    // 3. VẼ ĐƯỜNG BAO (PATH) - HÌNH CHỮ NHẬT BO GÓC CÓ ĐUÔI
    final Path path = Path();

    // Bắt đầu từ cạnh trên (bỏ qua góc bo trái-trên)
    path.moveTo(cornerRadius, 0);

    // Cạnh trên -> Góc phải-trên
    path.lineTo(width - cornerRadius, 0);
    path.arcToPoint(const Offset(width, cornerRadius), radius: const Radius.circular(cornerRadius));

    // Cạnh phải -> Góc phải-dưới
    path.lineTo(width, height - cornerRadius);
    path.arcToPoint(const Offset(width - cornerRadius, height), radius: const Radius.circular(cornerRadius));

    // Cạnh dưới (bên phải đuôi) -> Bắt đầu vẽ ĐUÔI
    path.lineTo(width / 2 + tailWidth / 2, height);

    // Vẽ mũi nhọn đuôi
    path.lineTo(width / 2, height + tailHeight);

    // Vẽ cạnh kia của đuôi
    path.lineTo(width / 2 - tailWidth / 2, height);

    // Cạnh dưới (bên trái đuôi) -> Góc trái-dưới
    path.lineTo(cornerRadius, height);
    path.arcToPoint(const Offset(0, height - cornerRadius), radius: const Radius.circular(cornerRadius));

    // Cạnh trái -> Góc trái-trên
    path.lineTo(0, cornerRadius);
    path.arcToPoint(const Offset(cornerRadius, 0), radius: const Radius.circular(cornerRadius));

    path.close(); // Khép kín hình

    // 4. THỰC HIỆN VẼ

    // Bước A: Vẽ bóng đổ trước (Dịch xuống dưới một chút)
    canvas.drawPath(path.shift(const Offset(0, shadowOffset)), shadowPaint);

    // Bước B: Vẽ hình chính đè lên
    canvas.drawPath(path, mainPaint);

    // 5. VẼ CHỮ (SỐ ĐIỂM)
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: rating,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 30, // Cỡ chữ vừa vặn với khung
          fontWeight: FontWeight.bold, // Chữ đậm
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Căn giữa chữ vào phần THÂN (lấy chiều rộng/cao của thân trừ đi chữ rồi chia đôi)
    final double textX = (width - textPainter.width) / 2;
    final double textY = (height - textPainter.height) / 2;

    textPainter.paint(canvas, Offset(textX, textY));

    // 6. XUẤT ẢNH
    final ui.Picture picture = recorder.endRecording();
    final ui.Image img = await picture.toImage(totalWidth.toInt(), totalHeight.toInt());
    final ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  Future<Uint8List> createNoRatingIcon() async {
    // 1. Cấu hình kích thước bóng đổ
    const double shadowBlur = 8.0;      // Độ nhòe bóng (Tăng lên 8 để bóng mềm hơn)
    const double shadowOffsetY = 5.0;   // Độ dịch xuống (Để tạo độ nổi)

    // Kích thước bong bóng
    const double width = 60;
    const double height = 35;

    // Tính toán tổng kích thước ảnh cần xuất (bao gồm cả vùng bóng đổ bị lan ra ngoài)
    // Nếu không cộng thêm phần này, bóng sẽ bị cắt cụt ở các cạnh
    final double totalWidth = width + (shadowBlur * 2);
    final double totalHeight = height + (shadowBlur * 2) + shadowOffsetY;

    final recorder = ui.PictureRecorder();

    // Khởi tạo Canvas với vùng vẽ mở rộng
    final canvas = ui.Canvas(recorder, Rect.fromPoints(Offset.zero, Offset(totalWidth, totalHeight)));

    // Dịch bút vẽ vào bên trong để chừa lề cho bóng đổ
    canvas.translate(shadowBlur, shadowBlur);

    // 2. Cấu hình bút vẽ
    final paint = Paint()..color = Colors.white;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4) // Tăng độ đậm lên 0.4 (cũ là 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, shadowBlur);

    // Tạo hình dáng viên thuốc (RRect)
    final rrect = RRect.fromLTRBR(0, 0, width, height, const Radius.circular(30));

    // 3. VẼ
    canvas.drawRRect(rrect.shift(const Offset(0, shadowOffsetY)), shadowPaint);

    canvas.drawRRect(rrect, paint);

    final picture = recorder.endRecording();

    // Xuất ảnh với kích thước tổng (đã bao gồm bóng)
    final img = await picture.toImage(totalWidth.toInt(), totalHeight.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  void _flyToMe() async {
    Position? lastPosition = await Geolocator.getLastKnownPosition();
    if (lastPosition != null) {
      mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
              LatLng(lastPosition.latitude, lastPosition.longitude),
              13.0
          ),
          duration: const Duration(milliseconds: 800)
      );
    }

    Position realPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );

    mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(realPosition.latitude, realPosition.longitude),
                zoom: 13
            )
        ));
  }

  @override
  Widget build(BuildContext context) {

    final tileKey = dotenv.env['GOONG_MAP_TILE_KEY'];
    final String styleUrl = "https://tiles.goong.io/assets/goong_map_highlight.json?api_key=$tileKey";

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: MapLibreMap(
              styleString: styleUrl, // sử dụng api tile map của goong để hiển thị
              initialCameraPosition: const CameraPosition(
                  target: LatLng(21.03357551700003, 105.81911236900004),
                  zoom: 13
              ),
              myLocationEnabled: true, // hiển thị vị trí của tôi
              myLocationTrackingMode: MyLocationTrackingMode.tracking,
              onMapCreated: _onMapCreated,
              onStyleLoadedCallback: _onStyleLoadedCallback,
              myLocationRenderMode: MyLocationRenderMode.normal,
              rotateGesturesEnabled: false, // Chặn người dùng dùng 2 ngón tay để xoay bản đồ
              tiltGesturesEnabled: false, // Chặn người dùng vuốt dọc để nghiêng bản đồ (3D)
            ),
          ),
          Positioned(
            top: 50,
            left: 10,
            right: 10,
            child: isLoading
                ? const SearchBarShimmer()
                : Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: (){

                          },
                          icon: Icon(FontAwesomeIcons.search, size: 20,),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: (){

                            },
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
                          onPressed: (){
                            _panelCtrl.open();
                          },
                          icon: Icon(FontAwesomeIcons.list, size: 20,),
                        ),
                      ],
                    ),
                  )
          ),
          if(isShowCard)
            ValueListenableBuilder<double>(
              valueListenable: _panelPositionNotifier,
              builder: (context, pos, child) {
                return Positioned(
                  bottom: 160,
                  left: 20,
                  right: 20,
                  child: Transform.translate(
                    offset: Offset(0, pos * _hideOffset),
                    child: Opacity(
                      opacity: (1.0 - pos * 2).clamp(0.0, 1.0),
                      child: _salonInfoCard(
                        store: _selectedSymbol!.data!['store']
                      ),
                    ),
                  ),
                );
              },
            ),
          isLoading
              ? SizedBox.shrink()
              : Positioned(
                bottom: 100,
                right: 10,
                child: Transform.translate(
                  offset: Offset(0, _panelPositionNotifier.value * _hideOffset),
                  child: IconButton(
                      onPressed: () async{
                        _flyToMe();
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.my_location, color: Colors.black, size: 20,)
                  ),
                ),
              ),
          isLoading
              ? SlidingUpShimmer(panelCtrl: _panelCtrl, panelPositionNotifier: _panelPositionNotifier)
              : SlidingUpPanel(
                  maxHeight: 700,
                  minHeight: 80,
                  controller: _panelCtrl,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  defaultPanelState: PanelState.CLOSED,
                  onPanelSlide: (double pos) {
                    setState(() {
                      _panelPositionNotifier.value = pos;
                    });
                  },
                  header: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent, // Bắt sự kiện ngay cả vùng trống
                          onVerticalDragUpdate: (details) {
                            _panelCtrl.panelPosition -= details.primaryDelta! / 600;
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            color: Colors.transparent,
                            child: Container(
                              width: 60,
                              height: 4,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ActionChip(
                                    label: PhosphorIcon(
                                      PhosphorIcons.faders(),
                                      size: 20,
                                    ),
                                    onPressed: (){},
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)
                                    )
                                ),
                                const SizedBox(width: 10,),
                                ActionChip(
                                    label: Row(
                                      children: [
                                        Text(
                                          'Best match',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        const SizedBox(width: 5,),
                                        Icon(Icons.keyboard_arrow_down, size: 20,)
                                      ],
                                    ),
                                    onPressed: (){},
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25)
                                    )
                                ),
                                const SizedBox(width: 10,),
                                ActionChip(
                                    label: Row(
                                      children: [
                                        Text('Amenities',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        const SizedBox(width: 5,),
                                        Icon(Icons.keyboard_arrow_down, size: 20,)
                                      ],
                                    ),
                                    onPressed: (){},
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25)
                                    )
                                ),
                                const SizedBox(width: 10,),
                                ActionChip(
                                    label: Row(
                                      children: [
                                        Text('Price',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        const SizedBox(width: 5,),
                                        Icon(Icons.keyboard_arrow_down, size: 20,)
                                      ],
                                    ),
                                    onPressed: (){},
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25)
                                    )
                                ),
                                const SizedBox(width: 10,),
                                ActionChip(
                                    label: Row(
                                      children: [
                                        Text('Options',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        const SizedBox(width: 5,),
                                        Icon(Icons.keyboard_arrow_down, size: 20,)
                                      ],
                                    ),
                                    onPressed: (){},
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25)
                                    )
                                ),
                                const SizedBox(width: 10,),
                                ActionChip(
                                    label: Row(
                                      children: [
                                        PhosphorIcon(
                                          PhosphorIcons.sealCheck(),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 5,),
                                        Text('Only verified',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                    onPressed: (){},
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25)
                                    )
                                ),
                                const SizedBox(width: 10,),
                                ActionChip(
                                    label: Row(
                                      children: [
                                        Text('Type',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        const SizedBox(width: 5,),
                                        Icon(Icons.keyboard_arrow_down, size: 20,)
                                      ],
                                    ),
                                    onPressed: (){},
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25)
                                    )
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  panelBuilder: (ScrollController scrollController){
                    return _buildStoreList(controller: scrollController);
                  },
                )
        ],
      ),
    );
  }

  Widget _buildStoreList({
    required ScrollController controller
  }){
    return Padding(
      padding: const EdgeInsets.only(top: 80.0, left: 15, right: 15),
      child: CustomScrollView(
        controller: controller,
        slivers: [
          SliverToBoxAdapter(
            child: Center(
                child: Text(
                  '24 venues nearby',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold
                  ),
                )
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 10,),
          ),
          SliverList.separated(
            itemCount: 3,
            itemBuilder: (context, i){
              return _buildStoreCard();
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 20,);
            },
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 20,),
          ),
        ],
      )
    );
  }

  Widget _salonInfoCard({
    required Map store
  }) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Stack(
          children: [
            StoreImageSlider(),
            Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                    onTap: () async{
                      if(isShowCard){
                        final LatLng position = _selectedSymbol!.options.geometry!;
                        final Map dataStore = _selectedSymbol!.data as Map;

                        await mapController?.removeSymbol(_selectedSymbol!);

                        _selectedSymbol = await mapController?.addSymbol(
                            SymbolOptions(
                              geometry: position,
                              iconImage: dataStore['iconId'],
                              iconSize: 1,
                              zIndex: 10,
                            ),
                            dataStore
                        );
                        setState(() {
                          isShowCard = false;
                          // final data = _selectedSymbol!.data;
                          // String iconId = data!['iconId'];
                          // mapController!.updateSymbol(_selectedSymbol!, SymbolOptions(iconImage: iconId, iconSize: 1));
                          _selectedSymbol = null;
                        });
                      }
                    },
                    child: Icon(Icons.cancel, size: 25, color: Colors.white,)
                )
            ),
            Positioned(
              bottom: 15,
                left: 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${store['name']}', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    ),),
                    Row(
                      spacing: 5,
                      children: [
                        Text('3 mile', style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                        ),),
                        Icon(Icons.fiber_manual_record, size: 5, color: Colors.grey.shade700,),
                        Text('Ba Đình, Hà Nội', style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                        ),),
                      ],
                    ),
                  ],
                )
            ),
            Positioned(
              bottom: 35,
              right: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 5,
                children: [

                  const SizedBox(width: 115,),
                  Icon(FontAwesomeIcons.solidStar, color: Colors.orange, size: 14,),
                  Text('4.9', style: TextStyle(fontWeight: FontWeight.bold),),
                  Text('(994)', style: TextStyle(color: Colors.grey.shade700),)
                ],
            ),)
          ]
      ),
    );
  }

  Widget _buildStoreCard(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StoreImageSlider(),
        const SizedBox(height: 15,),
        Row(
          spacing: 5,
          children: [
            Expanded(child: Text('Dao\'s Care Spa - Ba Đình', style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16
            ),)),
            Icon(FontAwesomeIcons.solidStar, color: Colors.orange, size: 14,),
            Text('4.9',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('(994)',
              style: TextStyle(color: Colors.grey.shade700,
                fontWeight: FontWeight.bold),
              )
          ],
        ),
        Row(
          spacing: 5,
          children: [
            Text('3 mile', style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 15,
                fontWeight: FontWeight.bold
            ),),
            Icon(Icons.fiber_manual_record, size: 5, color: Colors.grey.shade700,),
            Text('Ba Đình, Hà Nội', style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 15,
                fontWeight: FontWeight.bold
            ),),
          ],
        ),
        const SizedBox(height: 20,),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15
          ),
          decoration: BoxDecoration(
            color: Color.fromRGBO(247, 247, 247, 1),
            borderRadius: BorderRadius.circular(5)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('The Dao Massage', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                  ),),
                  Text('330,000 đ', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),)
                ],
              ),
              Text('1 hr - 2 hr', style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
                fontSize: 15
              ),)
            ],
          ),
        ),
        const SizedBox(height: 10,),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 15
          ),
          decoration: BoxDecoration(
              color: Color.fromRGBO(247, 247, 247, 1),
              borderRadius: BorderRadius.circular(5)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('The Dao Massage', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                  ),),
                  Text('330,000 đ', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),)
                ],
              ),
              Text('1 hr - 2 hr', style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              ),)
            ],
          ),
        ),
        const SizedBox(height: 10,),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 15
          ),
          decoration: BoxDecoration(
              color: Color.fromRGBO(247, 247, 247, 1),
              borderRadius: BorderRadius.circular(5)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('The Dao Massage', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                  ),),
                  Text('330,000 đ', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),)
                ],
              ),
              Text('1 hr - 2 hr', style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              ),)
            ],
          ),
        ),
        TextButton(
            onPressed: (){},
            style: TextButton.styleFrom(
              foregroundColor: Colors.purple
            ),
            child: Text('See all services',
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            )
        )
      ],
    );
  }
}


import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:healio_app/features/explore/data/models/store_model.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:permission_handler/permission_handler.dart';

class MapHelper {
  // static Future<void> requestLocationPermission() async {
  //   await Permission.locationWhenInUse.request();
  // }

  static Future<void> addStoreMarkers(
    MapLibreMapController? mapController,
    List<StoreModel> _stores,
  ) async {
    if (mapController == null) return;

    Uint8List iconBytes;
    String iconId;
    List<SymbolOptions> optionsList = [];
    List<Map> dataList = [];

    for (var store in _stores) {
      if (store.rating == 0 || store.rating == '0') {
        optionsList.add(
          SymbolOptions(
            geometry: LatLng(store.latitude, store.longitude),
            iconImage: "marker-normal",
            iconSize: 1,
          ),
        );
        dataList.add({'store': store, 'iconId': 'marker-normal'});
      } else {
        iconBytes = await createRatingIcon(store.rating.toString());
        iconId = 'icon-rating-${_stores.indexOf(store)}';
        await mapController.addImage(iconId, iconBytes);

        optionsList.add(
          SymbolOptions(
            geometry: LatLng(store.latitude, store.longitude),
            iconImage: iconId,
            iconSize: 1,
          ),
        );
        dataList.add({'store': store, 'iconId': iconId});
      }
    }

    await mapController.addSymbols(optionsList, dataList);
  }

  static Future<Position> getCurrentPosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {}

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );

    return position;
  }

  static Future<Uint8List> createRatingIcon(String rating) async {
    // 1. CẤU HÌNH KÍCH THƯỚC (Bạn chỉnh sửa độ to nhỏ tại đây)
    const double width = 80; // Chiều rộng
    const double height = 50; // Chiều cao phần thân
    const double tailHeight = 15; // Độ dài cái đuôi
    const double tailWidth = 18; // Độ rộng gốc cái đuôi
    const double cornerRadius =
        25.0; // Độ bo góc (12 là vừa đẹp cho hình chữ nhật)

    // Tính toán kích thước tổng thể (bao gồm cả vùng đệm cho bóng đổ)
    const double shadowBlur = 8.0; // Độ nhòe bóng
    const double shadowOffset = 5.0; // Độ dịch bóng xuống dưới

    final double totalWidth = width + (shadowBlur * 2);
    final double totalHeight =
        height + tailHeight + (shadowBlur * 2) + shadowOffset;

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(
      recorder,
      Rect.fromPoints(Offset.zero, Offset(totalWidth, totalHeight)),
    );

    // Dịch bút vẽ vào trong để chừa lề cho bóng đổ không bị cắt
    canvas.translate(shadowBlur, shadowBlur);

    // 2. KHỞI TẠO BÚT VẼ (Paints)

    // Bút vẽ nền trắng
    final Paint mainPaint = Paint()..color = Colors.white;

    // Bút vẽ bóng đổ (Màu đen, độ mờ 40%, nhòe 8px)
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, shadowBlur);

    // 3. VẼ ĐƯỜNG BAO (PATH) - HÌNH CHỮ NHẬT BO GÓC CÓ ĐUÔI
    final Path path = Path();

    // Bắt đầu từ cạnh trên (bỏ qua góc bo trái-trên)
    path.moveTo(cornerRadius, 0);

    // Cạnh trên -> Góc phải-trên
    path.lineTo(width - cornerRadius, 0);
    path.arcToPoint(
      const Offset(width, cornerRadius),
      radius: const Radius.circular(cornerRadius),
    );

    // Cạnh phải -> Góc phải-dưới
    path.lineTo(width, height - cornerRadius);
    path.arcToPoint(
      const Offset(width - cornerRadius, height),
      radius: const Radius.circular(cornerRadius),
    );

    // Cạnh dưới (bên phải đuôi) -> Bắt đầu vẽ ĐUÔI
    path.lineTo(width / 2 + tailWidth / 2, height);

    // Vẽ mũi nhọn đuôi
    path.lineTo(width / 2, height + tailHeight);

    // Vẽ cạnh kia của đuôi
    path.lineTo(width / 2 - tailWidth / 2, height);

    // Cạnh dưới (bên trái đuôi) -> Góc trái-dưới
    path.lineTo(cornerRadius, height);
    path.arcToPoint(
      const Offset(0, height - cornerRadius),
      radius: const Radius.circular(cornerRadius),
    );

    // Cạnh trái -> Góc trái-trên
    path.lineTo(0, cornerRadius);
    path.arcToPoint(
      const Offset(cornerRadius, 0),
      radius: const Radius.circular(cornerRadius),
    );

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
    final ui.Image img = await picture.toImage(
      totalWidth.toInt(),
      totalHeight.toInt(),
    );
    final ByteData? byteData = await img.toByteData(
      format: ui.ImageByteFormat.png,
    );

    return byteData!.buffer.asUint8List();
  }

  static Future<Uint8List> createNoRatingIcon() async {
    // 1. Cấu hình kích thước bóng đổ
    const double shadowBlur = 8.0; // Độ nhòe bóng (Tăng lên 8 để bóng mềm hơn)
    const double shadowOffsetY = 5.0; // Độ dịch xuống (Để tạo độ nổi)

    // Kích thước bong bóng
    const double width = 60;
    const double height = 35;

    // Tính toán tổng kích thước ảnh cần xuất (bao gồm cả vùng bóng đổ bị lan ra ngoài)
    // Nếu không cộng thêm phần này, bóng sẽ bị cắt cụt ở các cạnh
    final double totalWidth = width + (shadowBlur * 2);
    final double totalHeight = height + (shadowBlur * 2) + shadowOffsetY;

    final recorder = ui.PictureRecorder();

    // Khởi tạo Canvas với vùng vẽ mở rộng
    final canvas = ui.Canvas(
      recorder,
      Rect.fromPoints(Offset.zero, Offset(totalWidth, totalHeight)),
    );

    // Dịch bút vẽ vào bên trong để chừa lề cho bóng đổ
    canvas.translate(shadowBlur, shadowBlur);

    // 2. Cấu hình bút vẽ
    final paint = Paint()..color = Colors.white;

    final shadowPaint = Paint()
      ..color = Colors.black
          .withValues(alpha: 0.4) // Tăng độ đậm lên 0.4 (cũ là 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, shadowBlur);

    // Tạo hình dáng viên thuốc (RRect)
    final rrect = RRect.fromLTRBR(
      0,
      0,
      width,
      height,
      const Radius.circular(30),
    );

    // 3. VẼ
    canvas.drawRRect(rrect.shift(const Offset(0, shadowOffsetY)), shadowPaint);

    canvas.drawRRect(rrect, paint);

    final picture = recorder.endRecording();

    // Xuất ảnh với kích thước tổng (đã bao gồm bóng)
    final img = await picture.toImage(totalWidth.toInt(), totalHeight.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  static void flyToMe(MapLibreMapController? mapController) async {
    Position? lastPosition = await Geolocator.getLastKnownPosition();
    if (lastPosition != null) {
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(lastPosition.latitude, lastPosition.longitude),
          11,
        ),
        duration: const Duration(milliseconds: 800),
      );
    }

    Position realPosition = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(realPosition.latitude, realPosition.longitude),
          zoom: 11,
        ),
      ),
    );
  }

  static void flyToPosition(
    MapLibreMapController? mapController,
    double latitude,
    double longitude,
    double zoom,
  ) async {
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), zoom),
      duration: const Duration(milliseconds: 800),
    );
  }

  // static Future<void> checkPermission() async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     Geolocator.openAppSettings();
  //     Geolocator.openLocationSettings();
  //   }

  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       Geolocator.openLocationSettings();
  //       throw Exception('Location permissions are denied.');
  //     }
  //   }
  // }

  static Future<void> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.status;

    if (status.isGranted) {
      print("Quyền vị trí đã được cấp.");
      return;
    }

    status = await Permission.location.request();

    if (status.isGranted) {
      print("Người dùng vừa đồng ý cấp quyền.");
    } else if (status.isPermanentlyDenied) {
      print("Quyền bị chặn mãi mãi. Mở Cài đặt hệ thống.");
      await openAppSettings();
    } else if (status.isDenied) {
      print("Người dùng từ chối quyền. Thoát ứng dụng.");

      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    }
  }
}

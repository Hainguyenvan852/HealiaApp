import 'dart:typed_data';

class LocationHelper {
  static Map<String, dynamic> parseSupabaseHexLocation(String hexString) {
    if (hexString.isEmpty || hexString.length < 50) {
      return {};
    }

    final bytes = Uint8List(hexString.length ~/ 2);
    for (int i = 0; i < hexString.length; i += 2) {
      bytes[i ~/ 2] = int.parse(hexString.substring(i, i + 2), radix: 16);
    }

    final byteData = ByteData.sublistView(bytes);

    final double lng = byteData.getFloat64(9, Endian.little);
    final double lat = byteData.getFloat64(17, Endian.little);

    return {'lng': lng, 'lat': lat};
  }
}
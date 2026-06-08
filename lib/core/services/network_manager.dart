import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkManager {
  // Tạo một instance duy nhất
  NetworkManager._();
  static final NetworkManager instance = NetworkManager._();

  // Luồng phát tín hiệu trạng thái mạng
  final _connectionController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _connectionController.stream;

  bool hasInternet = true;
  StreamSubscription? _connectivitySubscription;
  StreamSubscription? _internetSubscription;
  Timer? _debounceTimer;

  // Hàm khởi tạo
  void init() {
    // 1. Lắng nghe thay đổi phần cứng (Wifi, 4G bật/tắt)
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) {
      if (results.contains(ConnectivityResult.none)) {
        // Chắc chắn mất mạng
        _updateStatus(false);
      } else {
        // Có sóng, nhưng phải dò xem có Internet thực sự không
        _checkActualInternet();
      }
    });

    // 2. Lắng nghe kết nối thực tế từ internet_connection_checker_plus
    _internetSubscription = InternetConnection().onStatusChange.listen((
      status,
    ) {
      _updateStatus(status == InternetStatus.connected);
    });
  }

  Future<void> retryConnection() async {
    await _checkActualInternet();
  }

  // kiểm tra ping tới các máy chủ toàn cầu
  Future<void> _checkActualInternet() async {
    bool isConnected = await InternetConnection().hasInternetAccess;
    _updateStatus(isConnected);
  }

  // Cập nhật trạng thái và truyền cho toàn bộ ứng dụng nếu có thay đổi
  void _updateStatus(bool status) {
    if (hasInternet == status) return;

    if (status == true) {
      _debounceTimer?.cancel();
      hasInternet = true;
      _connectionController.add(true);
    } else {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 3000), () {
        hasInternet = false;
        _connectionController.add(false);
      });
    }
  }

  void dispose() {
    _debounceTimer?.cancel();
    _connectivitySubscription?.cancel();
    _internetSubscription?.cancel();
    _connectionController.close();
  }
}

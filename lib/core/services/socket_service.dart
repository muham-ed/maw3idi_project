import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';

class SocketService {
  late IO.Socket socket;

  Future<void> init() async {
    const String socketUrl = 'http://192.168.1.5:3000'; // ملاحظة: استخدم الـ IP الصحيح لجهازك
    
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    socket = IO.io(socketUrl,
      IO.OptionBuilder()
        .setTransports(['websocket', 'polling'])
        .setExtraHeaders({'Authorization': 'Bearer $token'}) // Pass token to socket
        .disableAutoConnect()
        .build()
    );
    socket.connect();
    
    socket.onConnect((_) => print('Connected to Socket.io Server'));
    socket.onConnectError((data) => print('Socket Connect Error: $data'));
    socket.onDisconnect((_) => print('Disconnected from Socket.io Server'));
  }

  void joinOrderRoom(String orderId) {
    socket.emit('join_order', orderId);
  }

  void updateLocation(String orderId, double lat, double lng) {
    socket.emit('update_location', {
      'orderId': orderId,
      'lat': lat,
      'lng': lng,
    });
  }

  void onLocationUpdate(Function(double lat, double lng) callback) {
    socket.on('location_updated', (data) {
      callback(
        (data['lat'] as num).toDouble(), 
        (data['lng'] as num).toDouble()
      );
    });
  }

  void onStatusChange(Function(String status) callback) {
    socket.on('status_changed', (data) {
      callback(data['status']);
    });
  }

  void dispose() {
    socket.dispose();
  }
}

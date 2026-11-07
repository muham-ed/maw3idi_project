import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';

class SocketService {
  late IO.Socket socket;
  bool isConnected = false;

  Future<void> init({String? customBaseUrl}) async {
    final String socketUrl = customBaseUrl ?? 'http://192.168.1.5:3000';
    
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    socket = IO.io(
      socketUrl,
      IO.OptionBuilder()
        .setTransports(['websocket', 'polling'])
        .setExtraHeaders({'Authorization': 'Bearer $token'})
        .enableAutoConnect()
        .enableReconnection()
        .setReconnectionAttempts(10)
        .setReconnectionDelay(2000)
        .build(),
    );

    socket.onConnect((_) {
      isConnected = true;
      debugPrint('Connected to Real-Time Socket Server ($socketUrl)');
    });

    socket.onConnectError((data) {
      isConnected = false;
      debugPrint('Socket Connection Error: $data');
    });

    socket.onDisconnect((_) {
      isConnected = false;
      debugPrint('Disconnected from Socket Server');
    });
  }

  void joinOrderRoom(String orderId) {
    socket.emit('join_order', orderId);
  }

  void joinDriverRoom(String driverId) {
    socket.emit('join_driver_room', driverId);
  }

  void setDriverOnlineStatus(bool isOnline, String driverId) {
    if (isOnline) {
      socket.emit('driver_online', {'driverId': driverId});
    } else {
      socket.emit('driver_offline', {'driverId': driverId});
    }
  }

  void updateLocation(String orderId, double lat, double lng, {double bearing = 0.0, String? driverId}) {
    socket.emit('update_location', {
      'orderId': orderId,
      'driverId': driverId,
      'lat': lat,
      'lng': lng,
      'bearing': bearing,
    });
  }

  void updateRideStatus(String orderId, String status) {
    socket.emit('ride_status_update', {
      'orderId': orderId,
      'status': status,
    });
  }

  void onLocationUpdate(Function(double lat, double lng, double bearing) callback) {
    socket.off('location_updated');
    socket.on('location_updated', (data) {
      if (data != null) {
        final double lat = (data['lat'] as num).toDouble();
        final double lng = (data['lng'] as num).toDouble();
        final double bearing = ((data['bearing'] ?? 0.0) as num).toDouble();
        callback(lat, lng, bearing);
      }
    });
  }

  void onStatusChange(Function(String status) callback) {
    socket.off('status_changed');
    socket.on('status_changed', (data) {
      if (data != null && data['status'] != null) {
        callback(data['status'].toString());
      }
    });
  }

  void onNewOrderAvailable(Function(Map<String, dynamic> orderData) callback) {
    socket.off('new_order_available');
    socket.on('new_order_available', (data) {
      if (data != null) {
        callback(Map<String, dynamic>.from(data));
      }
    });
  }

  void dispose() {
    socket.dispose();
  }
}

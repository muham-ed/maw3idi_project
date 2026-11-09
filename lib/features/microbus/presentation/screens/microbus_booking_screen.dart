import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/microbus_station_entity.dart';
import '../../../../injection_container.dart';
import '../../../../core/services/socket_service.dart';

class MicrobusBookingScreen extends StatefulWidget {
  const MicrobusBookingScreen({super.key});

  @override
  State<MicrobusBookingScreen> createState() => _MicrobusBookingScreenState();
}

class _MicrobusBookingScreenState extends State<MicrobusBookingScreen> {
  late MicrobusRouteEntity _alexRoute;
  String _selectedFromStationId = '1';
  String _selectedToStationId = '3';
  int _selectedSeatCount = 1;
  double _calculatedFare = 10.0;
  bool _isBookingConfirmed = false;

  @override
  void initState() {
    super.initState();
    _alexRoute = const MicrobusRouteEntity(
      id: 'ROUTE_ALEX_1',
      routeName: 'البيطاش ➔ الشاطبي ➔ مجمع الكليات بالجامعة',
      officialFarePerStation: 5.0,
      stations: [
        MicrobusStationEntity(id: '1', nameArabic: 'محطة البيطاش الرئيسية', nameEnglish: 'Bitash Terminal', location: LatLng(31.1350, 29.8050), baseFareFromStart: 0.0),
        MicrobusStationEntity(id: '2', nameArabic: 'موقف العجمي الدخيلة', nameEnglish: 'Dekheila Station', location: LatLng(31.1450, 29.8350), baseFareFromStart: 5.0),
        MicrobusStationEntity(id: '3', nameArabic: 'محطة الشاطبي (الجامعة)', nameEnglish: 'Shatby University', location: LatLng(31.2100, 29.9150), baseFareFromStart: 10.0),
        MicrobusStationEntity(id: '4', nameArabic: 'مجمع الكليات والمكتبة', nameEnglish: 'University Campus', location: LatLng(31.2180, 29.9250), baseFareFromStart: 15.0),
      ],
    );
    _recalculateFare();
  }

  void _recalculateFare() {
    setState(() {
      _calculatedFare = _alexRoute.calculateExactFare(_selectedFromStationId, _selectedToStationId) * _selectedSeatCount;
    });
  }

  void _confirmBooking() {
    setState(() {
      _isBookingConfirmed = true;
    });

    sl<SocketService>().emitRideEvent('book_microbus_seat', {
      'routeId': _alexRoute.id,
      'fromStation': _selectedFromStationId,
      'toStation': _selectedToStationId,
      'seats': _selectedSeatCount,
      'fare': _calculatedFare,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم حجز $_selectedSeatCount كرسي بسعر رسمي ($_calculatedFare ج.م) بدون أي زيادة!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حجز الميكروباص والخطوط الثابتة'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade700),
              ),
              child: Row(
                children: const [
                  Icon(Icons.shield_outlined, color: Colors.amber, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'ضمان التسعيرة الرسمية: حمايتك من استغلال السائقين وتغيير خط السير مع حظر أي سائق يطلب مبالغ إضافية!',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(_alexRoute.routeName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 16),
            const Text('اختر محطة الانطلاق (الركوب):', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedFromStationId,
              decoration: const InputDecoration(border: OutlineInputBorder(), prefixIcon: Icon(Icons.my_location, color: Colors.green)),
              items: _alexRoute.stations.map((station) {
                return DropdownMenuItem(value: station.id, child: Text(station.nameArabic));
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedFromStationId = val);
                  _recalculateFare();
                }
              },
            ),
            const SizedBox(height: 16),
            const Text('اختر محطة الوصول (النزول):', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedToStationId,
              decoration: const InputDecoration(border: OutlineInputBorder(), prefixIcon: Icon(Icons.location_on, color: Colors.red)),
              items: _alexRoute.stations.map((station) {
                return DropdownMenuItem(value: station.id, child: Text(station.nameArabic));
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedToStationId = val);
                  _recalculateFare();
                }
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('عدد الكراسي المطلوبة:', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                      onPressed: _selectedSeatCount > 1
                          ? () {
                              setState(() => _selectedSeatCount--);
                              _recalculateFare();
                            }
                          : null,
                    ),
                    Text('$_selectedSeatCount', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                      onPressed: _selectedSeatCount < 4
                          ? () {
                              setState(() => _selectedSeatCount++);
                              _recalculateFare();
                            }
                          : null,
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 32),
            Card(
              color: Colors.black87,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('الأجرة الرسمية المقررة:', style: TextStyle(color: Colors.white70, fontSize: 14)),
                        Text('$_calculatedFare ج.م', style: const TextStyle(color: Colors.greenAccent, fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('السعر مغلق رسمياً بالجغرافيا وغير قابل للزيادة أو الاستغلال', style: TextStyle(color: Colors.white54, fontSize: 11)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: _isBookingConfirmed ? Colors.grey : Colors.green),
                onPressed: _isBookingConfirmed ? null : _confirmBooking,
                child: Text(_isBookingConfirmed ? 'تم تأكيد الحجز وإخطار السائق' : 'تأكيد الحجز وحجز الكرسي', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

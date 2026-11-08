import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ReportViolationScreen extends StatefulWidget {
  final String orderId;
  const ReportViolationScreen({super.key, required this.orderId});

  @override
  State<ReportViolationScreen> createState() => _ReportViolationScreenState();
}

class _ReportViolationScreenState extends State<ReportViolationScreen> {
  String _selectedReason = 'demand_extra_money';
  final TextEditingController _notesController = TextEditingController();
  bool _isSubmitted = false;

  void _submitReport() {
    setState(() {
      _isSubmitted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إرسال البلاغ بنجاح! جاري مراجعة موقع الـ GPS واسترداد الفرق لمحفظتك.'),
        backgroundColor: Colors.red,
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إبلاغ عن استغلال / مخالفة سائق'),
        backgroundColor: Colors.red.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'اختر نوع المخالفة لخصم الغرامة فورياً وتعويضك:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 12),
            RadioListTile<String>(
              title: const Text('طلب السائق أجرة إضافية مخالِفة للتسعيرة الرسمية'),
              value: 'demand_extra_money',
              groupValue: _selectedReason,
              onChanged: (val) => setState(() => _selectedReason = val!),
            ),
            RadioListTile<String>(
              title: const Text('تغيير خط السير والرفض عن الإنزال في المحطة المحددة'),
              value: 'route_deviation',
              groupValue: _selectedReason,
              onChanged: (val) => setState(() => _selectedReason = val!),
            ),
            RadioListTile<String>(
              title: const Text('أسلوب غير لائق أو الامتناع عن تشغيل التكييف/السيارة'),
              value: 'inappropriate_behavior',
              groupValue: _selectedReason,
              onChanged: (val) => setState(() => _selectedReason = val!),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'تفاصيل إضافية (اختياري)',
                hintText: 'اكتب ما حدث بدقة لتوثيق البلاغ...',
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                onPressed: _isSubmitted ? null : _submitReport,
                child: Text(_isSubmitted ? 'جاري معالجة البلاغ...' : 'إرسال البلاغ وتطبيق الغرامة', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

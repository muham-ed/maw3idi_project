import 'package:dio/dio.dart';

mixin ErrorHandler {
  String handleError(dynamic e, String defaultMessage) {
    if (e is DioException) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return 'الخادم لا يستجيب (Timeout) - تأكد من الاتصال بالإنترنت';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        return 'استغرق الرد وقتاً طويلاً من الخادم';
      } else if (e.type == DioExceptionType.connectionError) {
        return 'فشل الاتصال بالخادم - تأكد من تشغيل الـ Backend ومن عنوان الـ IP: ${e.message}';
      }
      
      if (e.response != null) {
        final data = e.response?.data;
        if (data is Map && data.containsKey('message')) {
          return data['message'];
        }
        return 'خطأ من الخادم (${e.response?.statusCode}): ${e.response?.statusMessage}';
      }
      
      return 'خطأ في الشبكة (${e.type.name}): ${e.message}';
    }
    
    return 'خطأ غير متوقع: ${e.toString()}';
  }
}

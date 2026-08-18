class AppStrings {
  // Localization logic (Simple implementation)
  static bool isArabic = true;

  static String get appName => isArabic ? 'مواعيدي' : 'Maw3idi';
  static String get welcome => isArabic ? 'مرحباً بك في مواعيدي' : 'Welcome to Maw3idi';
  static String get login => isArabic ? 'تسجيل الدخول' : 'Login';
  static String get register => isArabic ? 'إنشاء حساب' : 'Register';
  static String get phoneNumber => isArabic ? 'رقم الهاتف' : 'Phone Number';
  static String get sendOTP => isArabic ? 'إرسال كود التحقق' : 'Send OTP';
  static String get verify => isArabic ? 'تحقق' : 'Verify';
  static String get next => isArabic ? 'التالي' : 'Next';
  static String get cancel => isArabic ? 'إلغاء' : 'Cancel';
  static String get loading => isArabic ? 'جاري التحميل...' : 'Loading...';
  static String get error => isArabic ? 'حدث خطأ ما' : 'Something went wrong';
  static String get success => isArabic ? 'تم بنجاح' : 'Success';
}

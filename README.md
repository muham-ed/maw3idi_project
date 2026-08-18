# maw3idi_project

مشروع تطبيق "مواعيدي" (Maw3idi) - نظام إدارة التوصيل والمواعيد.

## وصف المشروع
مشروع متكامل لتطبيق توصيل مبني باستخدام Flutter، يهدف إلى تسهيل عملية إدارة المواعيد والطلبات بين العملاء والسائقين.

## التقنيات المستخدمة
- **الإطار البرمجي:** Flutter (Dart)
- **إدارة الحالة:** BLoC / Cubit
- **قواعد البيانات والخدمات السحابية:** Firebase (Auth, Firestore, Messaging)
- **التواصل مع السيرفر:** Dio & Socket.io
- **الخرائط:** Google Maps Flutter & Geolocator
- **التوجيه:** Go Router
- **حقن التبعيات:** Get It

## هيكل ملفات المشروع
تم تقسيم المشروع باتباع بنية "Clean Architecture" لضمان سهولة الصيانة والتوسع:

```
C:\Android\maw3idi_project\maw3idi_project/
│
├── android/                         # ملفات Android الخاصة
├── ios/                             # ملفات iOS الخاصة
│
├── lib/                             # 🔥 قلب التطبيق (كل الكود هنا)
│   │
│   ├── main.dart                    # نقطة الدخول إلى التطبيق
│   │
│   ├── core/                        # 🔹 المكونات الأساسية (Core)
│   │   ├── constants/               # الثوابت (الألوان، الخطوط، النصوص)
│   │   ├── theme/                   # إعدادات الثيم (الوضع الفاتح/الداكن)
│   │   ├── utils/                   # دوال مساعدة عامة (Validators, Formatters)
│   │   └── widgets/                 # ويدجت عامة قابلة لإعادة الاستخدام
│   │
│   ├── features/                    # 🔹 ميزات التطبيق (Features)
│   │   ├── auth/                    # ميزة المصادقة (تسجيل الدخول، التسجيل)
│   │   │   ├── data/                # طبقة البيانات (Models, Data Sources, Repositories Impl)
│   │   │   ├── domain/              # طبقة الأعمال (Entities, Repositories Interface, Usecases)
│   │   │   └── presentation/        # طبقة العرض (UI, Cubits, Screens, Widgets)
│   │   │
│   │   ├── home/                    # ميزة الصفحة الرئيسية
│   │   └── profile/                 # ميزة الملف الشخصي وإدارة الحساب
│   │
│   ├── injection_container.dart    # حقن التبعيات (Dependency Injection)
│   └── routes.dart                 # إدارة المسارات (Navigation)
│
├── assets/                          # 🔹 الملفات الثابتة
│   ├── images/                      # الصور والأيقونات
│   ├── fonts/                       # الخطوط المخصصة (مثل Cairo)
│   └── translations/                # ملفات الترجمة (Localization)
│
├── test/                            # اختبارات الوحدات (Unit & Widget Tests)
│
├── pubspec.yaml                     # ملف الحزم والإعدادات
└── analysis_options.yaml            # قواعد تحليل الكود
```

## كيفية البدء
1. تأكد من تثبيت Flutter SDK.
2. قم بتشغيل الأمر `flutter pub get` لتحميل الحزم.
3. قم بتشغيل المشروع باستخدام `flutter run`.

## المساهمة
إذا كنت ترغب في المساهمة في تطوير المشروع، يرجى اتباع بنية المجلدات المذكورة أعلاه والحفاظ على نظافة الكود.

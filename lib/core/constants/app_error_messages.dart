class AppErrorMessages {
  AppErrorMessages._(); // لمنع أخذ نسخة من الكلاس
  static const String generalError = 'حدث خطأ ما، يرجى المحاولة لاحقاً.';
  // 🎯 أخطاء جلب البيانات والتقسيم
  static const String initialFetchError = 'حدث خطأ أثناء جلب البيانات، يرجى المحاولة لاحقاً.';
  static const String paginationError = 'تعذر تحميل الصفحة التالية، يرجى التحقق من الاتصال.';

  // 🎯 أخطاء العمليات (إضافة، تعديل، حذف)
  static const String createError = 'لم نتمكن من إضافة المستخدم، حاول مجدداً.';
  static const String updateError = 'حدث خطأ أثناء حفظ التعديلات.';
  static const String toggleBlockError = 'تعذر تغيير حالة حساب المستخدم.';

  // 🎯 أخطاء عامة
  static const String networkError = 'تأكد من اتصالك بالإنترنت.';
  static const String unknownError = 'حدث خطأ غير متوقع.';
}
// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get platformTitle => 'منصة غِراس السحابية';

  @override
  String get platformSubtitle => 'لوحة التحكم الإدارية المركزية للنظام';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get loginInstruction => 'أدخل بيانات حساب المسؤول للوصول للوحة التحكم';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get loginButton => 'دخول للوحة التحكم';

  @override
  String get emailRequired => 'الرجاء إدخال البريد الإلكتروني';

  @override
  String get passwordRequired => 'الرجاء إدخال كلمة المرور';

  @override
  String get homeMenu => 'الرئيسية';

  @override
  String get plantsMenu => 'المنتجات';

  @override
  String get usersMenu => 'المستخدمين';

  @override
  String get ordersMenu => 'الطلبات';

  @override
  String get reportsMenu => 'التقارير الماليّة';

  @override
  String get settingsMenu => 'الإعدادات';

  @override
  String get logoutButton => 'تسجيل الخروج';

  @override
  String get welcomeMessage => 'مرحباً بكِ مجدداً، هبة أحمد 👋';

  @override
  String get overviewTitle => 'نظرة عامة على النظام';

  @override
  String get totalSeeds => 'إجمالي البذور';

  @override
  String get activeOrders => 'الطلبات النشطة';

  @override
  String get registeredFarmers => 'المزارعين المسجلين';

  @override
  String get monthlyEarnings => 'أرباح هذا الشهر';

  @override
  String get chartsPlaceholder =>
      'مساحة المخططات البيانية وقائمة آخر العمليات المضافة (قيد التطوير) 📊';

  @override
  String get usersManagementTitle => 'إدارة المستخدمين والصلاحيات';

  @override
  String get usersManagementSubtitle =>
      'التحكم الكامل بحسابات النظام والموظفين والمزارعين';

  @override
  String get addNewEmployee => 'إضافة موظف جديد';

  @override
  String get searchUsersHint => 'البحث باسم المستخدم، البريد، أو الهاتف...';

  @override
  String get allRoles => 'جميع الصلاحيات';

  @override
  String get adminRole => 'مدير النظام (Admin)';

  @override
  String get dataEntryRole => 'مدخل بيانات وبذور';

  @override
  String get farmerRole => 'مزارع محترف';

  @override
  String get hobbyistRole => 'هاوي / مستخدم عادي';

  @override
  String get allStatuses => 'جميع الحالات';

  @override
  String get activeOnly => 'نشط فقط';

  @override
  String get blockedOnly => 'محظور فقط';

  @override
  String get noMatchingUsers =>
      'لا يوجد مستخدمون مطابقون لمعايير البحث والفلترة.';

  @override
  String get userColumn => 'المستخدم';

  @override
  String get phoneColumn => 'رقم الهاتف';

  @override
  String get cityColumn => 'المدينة';

  @override
  String get roleColumn => 'الصلاحية';

  @override
  String get statusColumn => 'الحالة';

  @override
  String get actionsColumn => 'العمليات';

  @override
  String get activeStatus => 'نشط';

  @override
  String get blockedStatus => 'محظور';

  @override
  String get backToUsersList => 'العودة لقائمة المستخدمين';

  @override
  String get createAccountCloud => 'إنشاء حساب موظف / مستخدم جديد سحابياً';

  @override
  String get fullNameLabel => 'الاسم بالكامل *';

  @override
  String get fullNameValidator => 'الرجاء إدخال الاسم بالكامل';

  @override
  String get emailLabel => 'البريد الإلكتروني *';

  @override
  String get emailEmptyValidator => 'الرجاء إدخال البريد الإلكتروني';

  @override
  String get emailInvalidValidator => 'الرجاء إدخال بريد إلكتروني صالح';

  @override
  String get phoneLabel => 'رقم الهاتف *';

  @override
  String get phoneValidator => 'الرجاء إدخال رقم الهاتف';

  @override
  String get cityLabel => 'المدينة *';

  @override
  String get roleLabel => 'تحديد مستوى الصلاحية (Account Type) *';

  @override
  String get cancel => 'إلغاء الأمر';

  @override
  String get saveAccountCloud => 'حفظ';

  @override
  String get productsManagementSubtitle =>
      'إدارة معروضات المنصة من نباتات، بذور، ومعدات حية';

  @override
  String get addNewProduct => 'إضافة منتج جديد';

  @override
  String get searchProductsHint => 'البحث باسم المنتج الحركي أو العلمي...';

  @override
  String get allCategories => 'كل التصنيفات';

  @override
  String get productImageColumn => 'الصورة';

  @override
  String get productNameArColumn => 'الاسم';

  @override
  String get productNameEnColumn => 'الاسم (إنجليزي)';

  @override
  String get productPriceColumn => 'السعر';

  @override
  String get productStockColumn => 'المخزون';

  @override
  String get noMatchingProducts => 'لا توجد منتجات مطابقة للتصفية حالياً 📦';

  @override
  String get backToProductsList => 'العودة لقائمة المنتجات';

  @override
  String get addProductToPlatform => 'إضافة منتج جديد للمنصة';

  @override
  String get productTitleLabel => 'اسم المنتج أو الصنف *';

  @override
  String get productTitleValidator => 'الرجاء إدخال اسم المنتج';

  @override
  String get productDescriptionLabel => 'وصف المنتج التفصيلي *';

  @override
  String get productDescriptionValidator => 'الرجاء كتابة وصف للمنتج';

  @override
  String get productPriceLabel => 'السعر (د.ل) *';

  @override
  String get productPriceValidator => 'أدخل سعر صحيح';

  @override
  String get productStockLabel => 'الكمية المتوفرة *';

  @override
  String get productStockValidator => 'أدخل كمية صحيحة';

  @override
  String get mainCategoryLabel => 'التصنيف الرئيسي *';

  @override
  String get categoryRequiredValidator => 'الرجاء اختيار تصنيف للمنتج';

  @override
  String get suitableSeasonLabel => 'الموسم الزراعي المناسب *';

  @override
  String get germinationRateLabel => 'نسبة الإنبات إن وجدت (مثال: 90%)';

  @override
  String get saveProductCloud => 'حفظ المنتج بالمنصة';

  @override
  String get ordersManagementTitle => 'إدارة الطلبيات';

  @override
  String get ordersManagementSubtitle =>
      'مراقبة ومعالجة طلبات المزارعين الواردة (آخر 30 طلبية مضافة)';

  @override
  String get addNewCancelReason => 'إضافة سبب إلغاء جديد';

  @override
  String get noOrdersRegistered => 'لا توجد أي طلبيات مسجلة في النظام حالياً.';

  @override
  String showingOrders(String start, String end, String total) {
    return 'عرض $start إلى $end من إجمالي $total طلبيات';
  }

  @override
  String pageOf(String current, String total) {
    return 'صفحة $current من $total';
  }

  @override
  String ordersError(String error) {
    return 'حدث خطأ أثناء جلب الطلبيات: $error';
  }

  @override
  String get orderNumberColumn => 'رقم الطلب';

  @override
  String get farmerAndContactColumn => 'المزارع والاتصال';

  @override
  String get orderDateTimeColumn => 'تاريخ ووقت الطلب';

  @override
  String get orderValueColumn => 'قيمة الطلب';

  @override
  String get orderStatusColumn => 'حالة الطلب';

  @override
  String get detailsColumn => 'التفاصيل';

  @override
  String get pendingApproval => 'بانتظار الموافقة';

  @override
  String get currency => 'د.ل';

  @override
  String orderDetailsTitle(String id) {
    return 'تفاصيل الطلبية #$id';
  }

  @override
  String get clientData => 'بيانات العميل';

  @override
  String clientNameLabel(String name) {
    return 'الاسم: $name';
  }

  @override
  String clientPhoneLabel(String phone) {
    return 'الهاتف: $phone';
  }

  @override
  String clientUserIdLabel(String id) {
    return 'معرف المستخدم: $id';
  }

  @override
  String get deliveryAndTimeData => 'بيانات التوصيل والوقت';

  @override
  String deliveryAddressLabel(String address) {
    return 'العنوان: $address';
  }

  @override
  String deliveryFeeLabel(String fee) {
    return 'سعر التوصيل: $fee د.ل';
  }

  @override
  String orderTimeLabel(String time) {
    return 'وقت الطلب: $time';
  }

  @override
  String get requestedProducts => 'المنتجات المطلوبة:';

  @override
  String get productTableColumn => 'المنتج';

  @override
  String get unitPriceTableColumn => 'سعر الوحدة';

  @override
  String get quantityTableColumn => 'الكمية';

  @override
  String get subtotalTableColumn => 'الإجمالي الفرعي';

  @override
  String get totalProductsLabel => 'إجمالي المنتجات:';

  @override
  String get deliveryCostLabel => 'تكلفة التوصيل:';

  @override
  String get grandTotalLabel => 'المجموع الكلي:';

  @override
  String get cancellationInfoTitle => 'معلومات إلغاء الطلبية:';

  @override
  String cancelReasonLabel(String reason) {
    return 'سبب الإلغاء: $reason';
  }

  @override
  String get noReasonSpecified => 'لم يتم تحديد سبب';

  @override
  String adminNotesLabel(String notes) {
    return 'ملاحظات الإدارة: $notes';
  }

  @override
  String orderNotesLabel(String notes) {
    return 'ملاحظات على الطلب: $notes';
  }

  @override
  String get updateOrderStatusTitle => 'تعديل حالة الطلبية:';

  @override
  String orderStatusUpdatedSuccess(String status) {
    return 'تم تحديث حالة الطلبية إلى ($status) بنجاح';
  }

  @override
  String get cancelOrderAndReturnProducts => 'إلغاء الطلبية وإرجاع المنتجات';

  @override
  String cancelOrderConfirmation(String id) {
    return 'أنت بصدد إلغاء الطلبية #$id. يرجى تحديد السبب وحفظ التفاصيل:';
  }

  @override
  String get actualCancelReason => 'سبب الإلغاء الحقيقي';

  @override
  String get selectCancelReasonValidator => 'يرجى اختيار سبب الإلغاء أولاً';

  @override
  String get additionalAdminNotes => 'ملاحظات الإدارة الإضافية (اختياري)';

  @override
  String get goBack => 'تراجع';

  @override
  String get confirmFinalCancellation => 'تأكيد الإلغاء النهائي';

  @override
  String get customerChangedMind => 'تراجع العميل عن الطلب';

  @override
  String get orderCancelledSuccess => 'تم إلغاء الطلبية وتثبيت البيانات بنجاح';

  @override
  String get addNewCancelReasonSystem => 'إضافة سبب إلغاء جديد في النظام';

  @override
  String get newReasonDisclaimer =>
      'السبب الجديد سيظهر فوراً كخيار في قائمة الإلغاء لدى مراجعي النظام.';

  @override
  String get cancelReasonArLabel => 'سبب الإلغاء';

  @override
  String get requiredField => 'مطلوب';

  @override
  String get cancelReasonEnLabel => 'سبب الإلغاء';

  @override
  String get saveAndRegister => 'حفظ';

  @override
  String get newCancelReasonRegisteredSuccess =>
      'تم تسجيل سبب الإلغاء الجديد بنجاح';

  @override
  String get citiesManagementTitle => 'إدارة المدن ';

  @override
  String get searchCityHint => 'بحث باسم المدينة...';

  @override
  String get noRegisteredCities => 'لم يتم العثور على أي مدن مسجلة حالياً';

  @override
  String get noMatchingCities => 'لا توجد مدن تطابق البحث الحالي.';

  @override
  String get serialNumberColumn => '#';

  @override
  String get cityNameColumn => 'اسم المدينة';

  @override
  String get activityStatusColumn => 'حالة النشاط';

  @override
  String get inactiveStatus => 'غير نشط';

  @override
  String statusUpdateFailed(String error) {
    return 'فشل في تعديل الحالة: $error';
  }

  @override
  String errorLoadingCities(String error) {
    return 'حدث خطأ أثناء تحميل المدن: $error';
  }

  @override
  String get addNewCity => 'إضافة مدينة';

  @override
  String get regionsManagementTitle => 'إدارة المناطق وتكلفة التوصيل';

  @override
  String get searchRegionHint => 'بحث باسم المنطقة...';

  @override
  String get noRegisteredRegions => 'لا توجد مناطق مسجلة حالياً';

  @override
  String get noMatchingRegions => 'لا توجد نتائج تطابق البحث الحالي.';

  @override
  String get regionColumn => 'المنطقة';

  @override
  String get deliveryFeeColumn => 'سعر التوصيل';

  @override
  String get deliveryTimeColumn => 'مدة التوصيل';

  @override
  String get deliveryStatusColumn => 'حالة التوصيل';

  @override
  String get addNewRegion => 'إضافة منطقة';

  @override
  String errorLoadingRegions(String error) {
    return 'حدث خطأ أثناء تحميل المناطق: $error';
  }

  @override
  String get addNewDeliveryRegionTitle => 'إضافة منطقة توصيل جديدة';

  @override
  String get parentCityLabel => 'المدينة التابعة لها *';

  @override
  String get selectCityHint => 'اختر المدينة';

  @override
  String get selectParentCityValidator => 'الرجاء اختيار المدينة التابعة';

  @override
  String get errorFetchingCities => 'حدث خطأ في جلب المدن';

  @override
  String get regionNameLabel => 'اسم المنطقة *';

  @override
  String get requiredFieldValidator => 'هذا الحقل مطلوب';

  @override
  String get deliveryFeeInputLabel => 'سعر التوصيل (د.ل) *';

  @override
  String get invalidValueValidator => 'قيمة غير صالحة';

  @override
  String get deliveryDurationLabel => 'مدة التوصيل (مثال: يوم - يومين) *';

  @override
  String get savingProgress => 'جاري الحفظ...';

  @override
  String get add => 'إضافة';

  @override
  String get addNewCityTitle => 'إضافة مدينة جديدة للخدمة';

  @override
  String get addCityInstruction =>
      'يرجى إدخال اسم المدينة التي تريد تفعيلها واستقبال الطلبات منها:';

  @override
  String get cityNameInputLabel => 'اسم المدينة (مثال: طبرق)';

  @override
  String get cityNameValidator => 'يرجى إدخال اسم المدينة';

  @override
  String get addAndActivate => 'إضافة وتفعيل';

  @override
  String cityAddedSuccess(String city) {
    return 'تمت إضافة مدينة $city بنجاح!';
  }

  @override
  String addFailedError(String error) {
    return 'فشل الإضافة: $error';
  }

  @override
  String get editRegionTitle => 'تعديل بيانات المنطقة';

  @override
  String get regionNameArLabel => 'اسم المنطقة (بالعربية) *';

  @override
  String get editDetails => 'تعديل التفاصيل';

  @override
  String get editProgress => 'جاري التعديل...';

  @override
  String get editCityTitle => 'تعديل بيانات المدينة';

  @override
  String get cityUpdatedSuccess => 'تم تعديل المدينة بنجاح!';

  @override
  String updateFailedError(String error) {
    return 'فشل التعديل: $error';
  }

  @override
  String get manageCancelReasonsTitle => 'إدارة أسباب إلغاء الطلبات';

  @override
  String get manageCancelReasonsSubtitle =>
      'تصفح وأضف أسباب إلغاء الطلبيات، مع إمكانية إيقاف تفعيل الأسباب القديمة لسلامة سجلات النظام التاريخية.';

  @override
  String errorLoadingReasons(String error) {
    return 'حدث خطأ أثناء تحميل الأسباب: $error';
  }

  @override
  String get noRegisteredReasons => 'لا توجد أسباب إلغاء مسجلة حالياً';

  @override
  String get addFirstReasonInstruction =>
      'قم بإضافة السبب الأول لكي يظهر للمشرفين في نافذة إلغاء الطلبات.';

  @override
  String get addNow => 'أضف الآن';

  @override
  String get reasonColumn => 'السبب';

  @override
  String get disabledStatus => 'معطل';

  @override
  String get reasonReactivatedSuccess => 'تم إعادة تنشيط سبب الإلغاء بنجاح!';

  @override
  String get reasonDeactivatedSuccess => 'تم إيقاف تفعيل سبب الإلغاء.';

  @override
  String operationFailed(String error) {
    return 'فشلت العملية: $error';
  }

  @override
  String get unexpectedError => 'حدث خطأ غير متوقع';

  @override
  String get manageOrderStatusesTitle => 'إدارة حالات الطلبيات';

  @override
  String get manageOrderStatusesSubtitle =>
      'تصفح وأضف وحرر حالات الطلبيات وألوانها المخصصة، مع إمكانية التفعيل والإيقاف الفوري.';

  @override
  String get addNewStatus => 'إضافة حالة جديدة';

  @override
  String errorLoadingStatuses(String error) {
    return 'حدث خطأ أثناء تحميل حالات الطلبيات: $error';
  }

  @override
  String get noRegisteredStatuses => 'لا توجد حالات طلبات مسجلة حالياً';

  @override
  String get addFirstStatusInstruction =>
      'قم بإضافة الحالة الأولى للنظام لكي تظهر في متابعة الطلبات.';

  @override
  String get addStatusNow => 'أضف حالة الآن';

  @override
  String get statusNameColumn => 'اسم الحالة';

  @override
  String get statusIdColumn => 'المعرف (ID)';

  @override
  String get statusDescriptionColumn => 'الوصف';

  @override
  String get statusColorColumn => 'اللون';

  @override
  String statusActivatedSuccess(String name) {
    return 'تم تنشيط حالة الطلب ($name) بنجاح!';
  }

  @override
  String statusDeactivatedSuccess(String name) {
    return 'تم إيقاف تفعيل حالة الطلب ($name).';
  }

  @override
  String get editOrderStatusTitle => 'تعديل حالة الطلب';

  @override
  String get addOrderStatusTitle => 'إضافة حالة جديدة';

  @override
  String get orderStatusFormSubtitle =>
      'قم بإدخال تفاصيل حالة الطلب التي تظهر للمستخدمين والمشرفين في اللوحة.';

  @override
  String get statusIdLabel => 'المعرف الفريد (statusId)';

  @override
  String get statusIdHint => 'مثال: processing, delivered, cancelled';

  @override
  String get statusIdRequiredError => 'يرجى إدخال المعرف الفريد للحالة';

  @override
  String get statusIdInvalidError =>
      'المعرف يجب أن يحتوي على أحرف إنجليزية وأرقام فقط بدون مساحات';

  @override
  String get statusNameLabel => 'اسم الحالة';

  @override
  String get statusNameHint => 'مثال: جاري التجهيز';

  @override
  String get statusDescriptionLabel => 'الوصف التفصيلي للحالة';

  @override
  String get statusDescriptionHint =>
      'مثال: يقوم فريقنا الآن بتغليف وتجهيز المنتجات للشحن';

  @override
  String get colorHexLabel => 'كود اللون (Hex)';

  @override
  String get colorHexHint => '#2196F3';

  @override
  String get colorHexRequiredError => 'يرجى إدخال كود اللون';

  @override
  String get colorHexInvalidError => 'صيغة غير صحيحة (مثال: #2196F3)';

  @override
  String get previewLabel => 'المعاينة';

  @override
  String get suggestedColorsLabel => 'ألوان مقترحة للسماح باختيار سريع:';

  @override
  String get systemActivationStatusLabel => 'حالة تفعيل النظام (نشط):';

  @override
  String get saveChanges => 'حفظ التعديلات';

  @override
  String get addStatus => 'إضافة الحالة';

  @override
  String get statusUpdatedSuccess => 'تم تحديث الحالة بنجاح!';

  @override
  String get statusAddedSuccess => 'تم إضافة حالة الطلب الجديدة بنجاح!';

  @override
  String get errorLoadingSettings =>
      'تعذر تحميل الإعدادات العامة. يرجى المحاولة مرة أخرى.';

  @override
  String get generalAppSettingsTitle => 'الإعدادات العامة للتطبيق';

  @override
  String get generalAppSettingsSubtitle =>
      'إدارة بيانات التطبيق الأساسية وروابط التواصل والصفحات القانونية.';

  @override
  String get generalAndOperationSettings => 'الإعدادات العامة والتشغيل';

  @override
  String get appNameLabel => 'اسم التطبيق';

  @override
  String get appNameHint => 'مثال: غِراس';

  @override
  String get appVersionLabel => 'إصدار التطبيق';

  @override
  String get appVersionHint => 'مثال: 1.0.0';

  @override
  String get storeSupportPhoneLabel => 'رقم دعم المتجر';

  @override
  String get storeSupportPhoneHint => 'مثال: 0912345678';

  @override
  String get minOrderValueLabel => 'الحد الأدنى للطلب';

  @override
  String get minOrderValueHint => 'مثال: 50';

  @override
  String get currencyCodeLabel => 'رمز العملة';

  @override
  String get currencyCodeHint => 'مثال: LYD';

  @override
  String get socialMediaLinksTitle => 'روابط التواصل الاجتماعي';

  @override
  String get facebookUrlLabel => 'رابط فيسبوك';

  @override
  String get facebookUrlHint => 'https://facebook.com/...';

  @override
  String get instagramUrlLabel => 'رابط إنستغرام';

  @override
  String get instagramUrlHint => 'https://instagram.com/...';

  @override
  String get whatsappNumberLabel => 'رقم واتساب';

  @override
  String get whatsappNumberHint => 'مثال: 218912345678+';

  @override
  String get legalAndIntroPagesTitle => 'الصفحات التعريفية والقانونية';

  @override
  String get aboutUsLabel => 'من نحن';

  @override
  String get aboutUsHint => 'اكتب وصفاً واضحاً ومختصراً عن المتجر.';

  @override
  String get privacyPolicyUrlLabel => 'رابط سياسة الخصوصية';

  @override
  String get privacyPolicyUrlHint => 'https://example.com/privacy';

  @override
  String get termsUrlLabel => 'رابط الشروط والأحكام';

  @override
  String get termsUrlHint => 'https://example.com/terms';

  @override
  String get maintenanceModeActive => 'وضع الصيانة مفعل حالياً';

  @override
  String get changesApplyAfterSave =>
      'سيتم تطبيق التغييرات على التطبيق بعد الحفظ';

  @override
  String get saveSettingsButton => 'حفظ الإعدادات';

  @override
  String get settingsSavedSuccess => 'تم حفظ الإعدادات العامة بنجاح';

  @override
  String get settingsSaveError => 'تعذر حفظ الإعدادات. يرجى المحاولة مرة أخرى.';

  @override
  String get maintenanceModeActiveStatus => 'التطبيق تحت الصيانة';

  @override
  String get appWorkingNormally => 'التطبيق يعمل بشكل طبيعي';

  @override
  String get unblockUserTooltip => 'إلغاء الحظر';

  @override
  String get blockUserTooltip => 'حظر الحساب';

  @override
  String get editUserDetailsTitle => 'تعديل بيانات المستخدم';

  @override
  String get userUpdatedSuccess => 'تم التحديث بنجاح';

  @override
  String get areYouSurePrompt => 'هل أنت متأكد من هذا الإجراء؟';

  @override
  String get accountStatusUpdatedSuccess => 'تم تغيير حالة الحساب بنجاح';

  @override
  String get confirmButton => 'تأكيد';

  @override
  String get manageAdminsTitle => 'إدارة المشرفين والصلاحيات';

  @override
  String get manageAdminsSubtitle =>
      'إدارة حسابات المشرفين، تحديد أدوارهم، والتحكم بصلاحيات الوصول للوحة التحكم.';

  @override
  String get addNewAdmin => 'إضافة مشرف جديد';

  @override
  String get nameColumn => 'الاسم';

  @override
  String get emailColumn => 'البريد الإلكتروني';

  @override
  String get noRegisteredAdmins => 'لا يوجد مشرفين مسجلين حالياً.';

  @override
  String get editAdminRole => 'تعديل صلاحيات المشرف';

  @override
  String get adminUpdatedSuccess => 'تم تحديث بيانات وصلاحيات المشرف بنجاح!';

  @override
  String get adminAddedSuccess => 'تم إضافة المشرف الجديد بنجاح!';

  @override
  String get save => 'حفظ';
}

# لوحة تحكم غِراس السحابية (SeedBank Dashboard)

لوحة تحكم مركزية سحابية مبنية باستخدام **Flutter Web** لإدارة المتاجر الإلكترونية، مصممة في الأصل لمتجر المستلزمات الزراعية (شتلات، معدات، أسمدة) مع مرونة معمارية تتيح إعادة تخصيصها لأي نشاط تجاري آخر.

---

## 📑 جدول المحتويات
1. [نظرة عامة على المشروع](#-نظرة-عامة-على-المشروع)
2. [المعمارية وهيكلية المجلدات](#-المعمارية-وهيكلية-المجلدات)
3. [بنية ومخطط قاعدة البيانات (Cloud Firestore)](#-بنية-ومخطط-قاعدة-البيانات-cloud-firestore)
4. [نماذج من الكود المصدري](#-نماذج-من-الكود-المصدري)

---

## 🌟 نظرة عامة على المشروع

* **المنصة والنوع:** Flutter Web - لوحة تحكم مركزية (SaaS Dashboard).
* **طبيعة النشاط الحالية:** متجر مستلزمات زراعية (شتلات، معدات، أسمدة).
* **المرونة:** النظام مصمم معمارياً ليكون مرناً وقابلاً لإعادة التخصيص لخدمة أي متجر إلكتروني آخر.
* **إدارة الحالة (State Management):** تعتمد بالكامل على **Riverpod** مع `StateNotifier` و `StreamProvider`.
* **الخدمات السحابية والتخزين:** 
  * قاعدة بيانات **Cloud Firestore** الفورية.
  * **SharedPreferences** للتخزين المحلي للتفضيلات (اللغة، الثيم، الألوان).

---

## 🏗️ المعمارية وهيكلية المجلدات

يعتمد المشروع على هندسة **Clean Architecture** المدمجة مع تقسيم **Feature-by-Feature** لضمان قابلية التوسع والصيانة:

```text
lib/
├── app/          # الإعدادات التشغيلية المركزية للتطبيق (app_initializer, app_routes, main_navigation, seed_bank_dashboard_app)
├── core/         # النواة المشتركة القابلة لإعادة الاستخدام (enums, localization, storage, theme, widgets)
└── features/     # أقسام وميزات النظام (auth, dashboard, locations, categories...)
    └── categories/
        ├── data/          # (datasources, models, repositories)
        ├── domain/        # (repositories, usecases - مثل Add, Update, Delete)
        └── presentation/  # (pages, providers)
```

---

## 🗄️ بنية ومخطط قاعدة البيانات (Cloud Firestore)

تم تنظيم قاعدة البيانات في Cloud Firestore إلى مجموعات جذرية مهيأة للربط والعمليات المتقدمة:

### 1. مجموعة التصنيفات (`categories`)
تحتوي على تصنيفات المتجر وترتبط منطقياً بالمنتجات عن طريق عداد داخلي حركي لحماية البيانات من الحذف العشوائي.

* **الحقول (Fields):**
  * `id`: معرف المستند الفريد.
  * `level`: المستوى الهرمي للتصنيف (الافتراضي: 1).
  * `nameAr`: اسم التصنيف باللغة العربية.
  * `nameEn`: اسم التصنيف باللغة الإنجليزية.
  * `parentId`: معرف التصنيف الأب (في حال وجود تصنيفات فرعية).
  * `sortOrder`: ترتيب العرض في الواجهات.
  * `product_count`: عداد المنتجات التابعة لهذا التصنيف (تستخدم لشرط حظر حذف التصنيف النشط).

### 2. مجموعة المستخدمين (`users`)
تخزن بيانات الحسابات المختلفة للزبائن والمزارعين عبر لوحة التحكم.

* **الحقول (Fields):**
  * `accountTypeId`: نوع الحساب (مثال: `farmer`, `customer`).
  * `cityId`: معرف المدينة المربوط بمجموعة المدن (مثال: `tripoli`).
  * `createdAt`: تاريخ ووقت إنشاء الحساب.
  * `email`: البريد الإلكتروني للمستخدم.
  * `isBlocked`: حالة حظر الحساب من اللوحة.
  * `name`: الاسم الكامل للمستخدم.
  * `phone`: رقم الهاتف.

### 3. مجموعة أسباب الإلغاء (`cancelReasons`)
تخزن الأسباب الثابتة والمخصصة التي تظهر عند إلغاء الطلبات لتسهيل الإحصاء.

* **الحقول (Fields):**
  * `reasonId`: المعرف الفريد للسبب (مثال: `changed_mind`).
  * `reasonAr`: نص السبب باللغة العربية.
  * `isActive`: حالة تفعيل السبب في النظام.

---

## 💻 نماذج من الكود المصدري

### ثوابت الإعدادات (`app_configs.dart`)
```dart
class AppConfigs {
  static const String firebaseApiKey = "AIzaSyA7-52fnh9592961fLrox9KlDxV0KmZ2Cg";
  static const String firebaseAuthDomain = "seed-bank-ly.firebaseapp.com";
  static const String firebaseProjectId = "seed-bank-ly";
  static const String firebaseStorageBucket = "seed-bank-ly.firebasestorage.app";
  static const String firebaseMessagingSenderId = "898791648221";
  static const String firebaseAppId = "1:898791648221:web:d393db2cec859d22e92434";

  static const String keyLanguage = 'selected_language';
  static const String keyThemeMode = 'selected_theme_mode';
  static const String keyPrimaryColor = 'selected_primary_color';

  static const String defaultLanguage = 'ar';
  static const String defaultThemeMode = 'light';
  static const Color defaultPrimaryColor = Color(0xFF1E5631);
}
```

### نموذج البيانات (`category_model.dart`)
```dart
class CategoryModel {
  final String id;
  final int level;
  final String nameAr;
  final String nameEn;
  final String? parentId;
  final int sortOrder;
  final int productCount;

  const CategoryModel({
    required this.id,
    required this.level,
    required this.nameAr,
    required this.nameEn,
    this.parentId,
    required this.sortOrder,
    required this.productCount,
  });

  factory CategoryModel.fromFirestore(Map<String, dynamic> json, String documentId) {
    return CategoryModel(
      id: documentId,
      level: json['level'] as int? ?? 1,
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      parentId: json['parentId'] as String?,
      sortOrder: json['sortOrder'] as int? ?? 0,
      productCount: json['product_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'level': level,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'parentId': parentId,
      'sortOrder': sortOrder,
      'product_count': productCount,
    };
  }
}
```

### مصدر البيانات وجلبها (`categories_remote_data_source.dart`)
```dart
abstract class CategoriesRemoteDataSource {
  Stream<List<CategoryModel>> getCategoriesStream();
  Future<void> addCategory(CategoryModel category);
  Future<void> updateCategory(CategoryModel category);
  Future<void> deleteCategory(CategoryModel category);
}

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  final FirebaseFirestore _firestore;
  CategoriesRemoteDataSourceImpl(this._firestore);

  @override
  Stream<List<CategoryModel>> getCategoriesStream() {
    return _firestore
        .collection('categories')
        .orderBy('sortOrder')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CategoryModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  @override
  Future<void> addCategory(CategoryModel category) async {
    final docRef = _firestore.collection('categories').doc();
    await docRef.set(category.toFirestore());
  }

  @override
  Future<void> deleteCategory(CategoryModel category) async {
    await _firestore.collection('categories').doc(category.id).delete();
  }
}
```

### الـ Providers وإدارة الحالة (`categories_provider.dart`)
```dart
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final categoriesRemoteDataSourceProvider = Provider((ref) {
  return CategoriesRemoteDataSourceImpl(ref.watch(firestoreProvider));
});

final categoriesRepositoryProvider = Provider((ref) {
  return CategoriesRepositoryImpl(ref.watch(categoriesRemoteDataSourceProvider));
});

final categoriesStreamProvider = StreamProvider<List<CategoryModel>>((ref) {
  return ref.watch(getCategoriesUseCaseProvider).call();
});

class CategoriesNotifier extends StateNotifier<CategoriesState> {
  final AddCategoryUseCase _addCategoryUseCase;
  final UpdateCategoryUseCase _updateCategoryUseCase;
  final DeleteCategoryUseCase _deleteCategoryUseCase;

  CategoriesNotifier(
    this._addCategoryUseCase,
    this._updateCategoryUseCase,
    this._deleteCategoryUseCase,
  ) : super(CategoriesState());

  Future<bool> deleteCategory(CategoryModel category) async {
    state = state.copyWith(deleteCategoryStatus: RequestStatus.loading);
    try {
      await _deleteCategoryUseCase.call(category);
      state = state.copyWith(deleteCategoryStatus: RequestStatus.success);
      return true;
    } catch (e) {
      state = state.copyWith(
        deleteCategoryStatus: RequestStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}
```

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/home_section_model.dart';

// ==========================================
// Abstract Contract
// ==========================================
abstract class HomeSectionsRemoteDataSource {
  Future<List<HomeSectionModel>> getSections();

  Future<void> addSection(HomeSectionModel section);

  Future<void> updateSection(HomeSectionModel section);

  Future<void> deleteSection(String sectionId);
}

// ==========================================
// Implementation — throws on failure (caught by Repository)
// ==========================================
class HomeSectionsRemoteDataSourceImpl implements HomeSectionsRemoteDataSource {
  final FirebaseFirestore _firestore;

  HomeSectionsRemoteDataSourceImpl(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('home_sections');

  @override
  Future<List<HomeSectionModel>> getSections() async {
    // 🎯 جلب جميع الأقسام مرتبة تصاعدياً حسب حقل order
    final snapshot = await _collection.orderBy('order').get();

    return snapshot.docs
        .map((doc) => HomeSectionModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> addSection(HomeSectionModel section) async {
    final docRef = _collection.doc();
    await docRef.set(section.toFirestore());
  }

  @override
  Future<void> updateSection(HomeSectionModel section) async {
    await _collection.doc(section.id).update(section.toFirestore());
  }

  @override
  Future<void> deleteSection(String sectionId) async {
    await _collection.doc(sectionId).delete();
  }
}
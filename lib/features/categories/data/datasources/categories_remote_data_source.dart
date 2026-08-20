import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';

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
  Future<void> updateCategory(CategoryModel category) async {
    await _firestore.collection('categories').doc(category.id).update(category.toFirestore());
  }

  @override
  Future<void> deleteCategory(CategoryModel category) async {
    // نقوم بالحذف المباشر هنا بناءً على الـ ID
    await _firestore.collection('categories').doc(category.id).delete();
  }
}
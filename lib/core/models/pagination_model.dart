import 'package:cloud_firestore/cloud_firestore.dart';
import '../enums/pagination_action.dart'; // 🎯 استدعاء الـ Enum

class PaginationModel<T> {
  final List<T> items;
  final DocumentSnapshot? firstDoc;
  final DocumentSnapshot? lastDoc;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final int currentPage;

  const PaginationModel({
    this.items = const [],
    this.firstDoc,
    this.lastDoc,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
    this.currentPage = 1,
  });

  // ==========================================
  // 🎯 الدالة الجديدة لحساب رقم الصفحة بذكاء
  // ==========================================
  int calculateNewPage(PaginationAction action) {
    if (action == PaginationAction.refresh) return 1;
    if (action == PaginationAction.next) return currentPage + 1;
    if (action == PaginationAction.previous && currentPage > 1) return currentPage - 1;

    return currentPage;
  }

  PaginationModel<T> copyWith({
    List<T>? items,
    DocumentSnapshot? firstDoc,
    DocumentSnapshot? lastDoc,
    bool? hasNextPage,
    bool? hasPreviousPage,
    int? currentPage,
  }) {
    return PaginationModel<T>(
      items: items ?? this.items,
      firstDoc: firstDoc ?? this.firstDoc,
      lastDoc: lastDoc ?? this.lastDoc,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
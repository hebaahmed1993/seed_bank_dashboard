import 'package:cloud_firestore/cloud_firestore.dart';
import '../enums/pagination_action.dart';

class PaginationParams {
  final int limit;
  final PaginationAction action;
  final DocumentSnapshot? firstDoc;
  final DocumentSnapshot? lastDoc;

  const PaginationParams({
    this.limit = 15,
    this.action = PaginationAction.refresh,
    this.firstDoc,
    this.lastDoc,
  });
}
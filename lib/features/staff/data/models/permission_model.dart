class PermissionModel {
  final String id; // يمثل Document ID مثل "products" أو "orders"
  final String name;
  final String description;

  PermissionModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory PermissionModel.fromFirestore(Map<String, dynamic> data, String id) {
    return PermissionModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
    };
  }

  PermissionModel copyWith({
    String? id,
    String? name,
    String? description,
  }) {
    return PermissionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
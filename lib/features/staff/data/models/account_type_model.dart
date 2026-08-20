class AccountTypeModel {
  final String id; // يمثل Document ID مثل "admin" أو "Data_Entry"
  final String name;
  final String description;
  final String typeName;
  final List<String> permissions; // مصفوفة الـ Semantic IDs

  AccountTypeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.typeName,
    required this.permissions,
  });

  factory AccountTypeModel.fromFirestore(Map<String, dynamic> data, String id) {
    return AccountTypeModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      typeName: data['typeName'] ?? '',
      permissions: List<String>.from(data['permissions'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'typeName': typeName,
      'permissions': permissions,
    };
  }

  AccountTypeModel copyWith({
    String? id,
    String? name,
    String? description,
    String? typeName,
    List<String>? permissions,
  }) {
    return AccountTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      typeName: typeName ?? this.typeName,
      permissions: permissions ?? this.permissions,
    );
  }
}
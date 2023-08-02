class AttachmentModel {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;
  final String file;
  final int size;
  final String mimetype;

  AttachmentModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.file,
    required this.size,
    required this.mimetype,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: DateTime.parse(json['deleted_at'] as String),
      file: json['file'] as String,
      size: json['size'] as int,
      mimetype: json['mimetype'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['created_at'] = createdAt.toIso8601String();
    data['updated_at'] = updatedAt.toIso8601String();
    data['deleted_at'] = deletedAt.toIso8601String();
    data['file'] = file;
    data['size'] = size;
    data['mimetype'] = mimetype;
    return data;
  }
}

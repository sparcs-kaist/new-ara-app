class AttachmentModel {
  int id;
  String created_at;
  String updated_at;
  String deleted_at;
  String file;
  int? size;
  String? mimetype;

  AttachmentModel({
    required this.id,
    required this.created_at,
    required this.updated_at,
    required this.deleted_at,
    required this.file,
    this.size,
    this.mimetype,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      id: json['id'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      deleted_at: json['deleted_at'],
      file: json['file'],
      size: json['size'],
      mimetype: json['mimetype'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'created_at': created_at,
    'updated_at': updated_at,
    'deleted_at': deleted_at,
    'file': file,
    'size': size,
    'mimetype': mimetype,
  };
}
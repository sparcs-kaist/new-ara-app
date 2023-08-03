class AttachmentModel {
  final int id;
  final String file;
  final int size;
  final String mimetype;

  AttachmentModel({
    required this.id,
    required this.file,
    required this.size,
    required this.mimetype,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      id: json['id'] as int,
      file: json['file'] as String,
      size: json['size'] as int,
      mimetype: json['mimetype'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['file'] = file;
    data['size'] = size;
    data['mimetype'] = mimetype;
    return data;
  }
}

class Part {
  Part({this.id, required this.name, this.description, this.note});

  int? id;
  String name;
  String? description;
  String? note;

  factory Part.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'name': String name,
        'description': String? description,
        'note': String? note
      } =>
        Part(id: id, name: name, description: description, note: note),
      _ => throw const FormatException('Failed to load Part from json')
    };
  }

  factory Part.fromJsonList(Map<String, dynamic> json) {
    return switch (json) {
      {'id': int id, 'name': String name} => Part(id: id, name: name),
      _ => throw const FormatException('Failed to load Part from json list')
    };
  }
}

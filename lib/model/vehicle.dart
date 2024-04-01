class Vehicle {
  Vehicle({this.id, required this.name, this.description, this.note});

  int? id;
  final String name;
  String? description;
  String? note;

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'name': String name,
        'description': String? description,
        'note': String? note
      } =>
        Vehicle(id: id, name: name, description: description, note: note),
      _ => throw const FormatException('Failed to load vehicle from json')
    };
  }

  factory Vehicle.fromJsonList(Map<String, dynamic> json) {
    return switch (json) {
      {'id': int id, 'name': String name} => Vehicle(id: id, name: name),
      _ => throw const FormatException('Failed to load vehicle from json')
    };
  }
}

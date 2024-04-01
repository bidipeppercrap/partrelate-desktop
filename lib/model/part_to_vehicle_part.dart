import 'package:partrelate_desktop/model/part.dart';

class PTVP {
  PTVP(
      {this.id,
      this.description,
      this.quantity,
      required this.vehiclePartId,
      required this.partId,
      required this.part});

  int? id;
  String? description;
  String? quantity;
  int vehiclePartId;
  int partId;
  Part part;

  factory PTVP.fromJson(Map<String, dynamic> json) {
    Part part = Part.fromJson(json['parts']);

    return switch (json) {
      {
        'id': int id,
        'description': String? description,
        'quantity': String? quantity,
        'vehiclePartId': int vehiclePartId,
        'partId': int partId,
      } =>
        PTVP(
            id: id,
            description: description,
            quantity: quantity,
            vehiclePartId: vehiclePartId,
            partId: partId,
            part: part),
      _ => throw const FormatException(
          'Failed to load Part to Vehicle Part from json')
    };
  }
}

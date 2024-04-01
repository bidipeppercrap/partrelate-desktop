import 'package:partrelate_desktop/model/vehicle.dart';
import 'package:partrelate_desktop/model/vehicle_part_detail.dart';

class VehicleDetail extends Vehicle {
  VehicleDetail(
      {super.id,
      required super.name,
      super.description,
      super.note,
      this.vehicleParts = const []})
      : super();

  List<VehiclePartDetail> vehicleParts;

  factory VehicleDetail.fromJson(Map<String, dynamic> json) {
    List<VehiclePartDetail> vehicleParts = [];

    for (var vp in json['vehicleParts']) {
      vehicleParts.add(VehiclePartDetail.fromJson(vp));
    }

    return switch (json) {
      {
        'id': int id,
        'name': String name,
        'description': String? description,
        'note': String? note,
      } =>
        VehicleDetail(
            id: id,
            name: name,
            description: description,
            note: note,
            vehicleParts: vehicleParts),
      _ => throw const FormatException('Failed to load Vehicle Detail')
    };
  }
}

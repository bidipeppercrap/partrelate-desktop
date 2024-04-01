import 'package:partrelate_desktop/model/part_to_vehicle_part.dart';
import 'package:partrelate_desktop/model/vehicle_part.dart';

class VehiclePartDetail extends VehiclePart {
  VehiclePartDetail(
      {super.id,
      required super.name,
      super.description,
      super.note,
      required super.vehicleId,
      this.partsToVehicleParts = const []})
      : super();

  List<PTVP> partsToVehicleParts;

  factory VehiclePartDetail.fromJson(Map<String, dynamic> json) {
    List<PTVP> ptvp = [];

    for (var part in json['partsToVehicleParts']) {
      ptvp.add(PTVP.fromJson(part));
    }

    return switch (json) {
      {
        'id': int id,
        'name': String name,
        'description': String? description,
        'note': String? note,
        'vehicleId': int vehicleId
      } =>
        VehiclePartDetail(
            id: id,
            name: name,
            description: description,
            note: note,
            vehicleId: vehicleId,
            partsToVehicleParts: ptvp),
      _ => throw const FormatException('Failed to load Vehicle Part Detail')
    };
  }
}

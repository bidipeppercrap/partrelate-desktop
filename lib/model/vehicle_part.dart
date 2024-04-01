class VehiclePart {
  VehiclePart(
      {this.id,
      required this.name,
      this.description,
      this.note,
      required this.vehicleId});

  int? id;
  String name;
  String? description;
  String? note;
  int vehicleId;
}

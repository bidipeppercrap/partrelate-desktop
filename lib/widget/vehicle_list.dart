import 'package:flutter/material.dart';
import 'package:partrelate_desktop/model/vehicle.dart';
import 'package:partrelate_desktop/page/vehicle_detail.dart';

class VehicleList extends StatelessWidget {
  const VehicleList({super.key, required this.vehicles});

  final List<Vehicle> vehicles;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: vehicles.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    VehicleDetailPage(vehicleId: vehicles[index].id!)));
          },
          title: Text(vehicles[index].name),
        );
      },
    );
  }
}

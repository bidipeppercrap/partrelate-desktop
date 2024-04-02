import 'package:flutter/material.dart';
import 'package:partrelate_desktop/model/vehicle.dart';
import 'package:partrelate_desktop/page/vehicle_detail.dart';

class VehicleList extends StatelessWidget {
  const VehicleList(
      {super.key, required this.vehicles, this.onRefresh, this.freeze = false});

  final List<Vehicle> vehicles;
  final Function? onRefresh;
  final bool freeze;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: vehicles.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: freeze
              ? null
              : () async {
                  final bool needRefresh = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => VehicleDetailPage(
                              vehicleId: vehicles[index].id!)));

                  if (needRefresh && onRefresh != null) onRefresh!();
                },
          title: Text(vehicles[index].name),
        );
      },
    );
  }
}

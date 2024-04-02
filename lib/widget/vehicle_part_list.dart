import 'package:flutter/material.dart';
import 'package:partrelate_desktop/http/client.dart';
import 'package:partrelate_desktop/model/vehicle_part_detail.dart';
import 'package:partrelate_desktop/page/vehicle_part_update.dart';
import 'package:partrelate_desktop/widget/ptvp_detail.dart';
import 'package:partrelate_desktop/widget/ptvp_form.dart';
import 'package:partrelate_desktop/widget/rounded_container.dart';

class VehiclePartList extends StatelessWidget {
  const VehiclePartList(
      {super.key, this.vehicleParts = const [], this.onRefresh});

  final List<VehiclePartDetail> vehicleParts;
  final Function? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: vehicleParts.length,
            itemBuilder: (context, index) {
              var vehiclePart = vehicleParts[index];

              return ExpansionTile(
                backgroundColor: Colors.white,
                title: Text(vehiclePart.name),
                children: <Widget>[
                  if (vehiclePart.description != null &&
                      vehiclePart.description!.isNotEmpty)
                    ListTile(
                      title: RoundedContainer(
                        backgroundColor: Colors.black26,
                        borderColor: Colors.black54,
                        padding: 6,
                        child: Text(
                          vehiclePart.description ?? '',
                          style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  if (vehiclePart.note != null && vehiclePart.note!.isNotEmpty)
                    ListTile(
                      title: RoundedContainer(
                          backgroundColor: Colors.yellow.shade200,
                          borderColor: Colors.black54,
                          padding: 6,
                          child: Text(
                            vehiclePart.note ?? '',
                            style: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          )),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              final success = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VehiclePartUpdatePage(
                                            vehicleId: vehiclePart.vehicleId,
                                            id: vehiclePart.id!,
                                            name: vehiclePart.name,
                                            description:
                                                vehiclePart.description ?? '',
                                            note: vehiclePart.note ?? '',
                                          )));
                              if (success && onRefresh != null) onRefresh!();
                            },
                            child: const Icon(Icons.edit)),
                        const SizedBox(
                          width: 15,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              try {
                                await dio
                                    .delete('/vehicle_parts/${vehiclePart.id}');

                                if (onRefresh != null) onRefresh!();
                              } catch (e) {
                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())));
                              }
                            },
                            child: const Icon(Icons.delete))
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(15),
                      child: PTVPForm(
                        vehiclePartId: vehiclePart.id!,
                        onRefresh: onRefresh,
                      )),
                  const Divider(),
                  ListView.separated(
                      shrinkWrap: true,
                      itemCount: vehiclePart.partsToVehicleParts.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        var ptvp = vehiclePart.partsToVehicleParts[index];
                        var part = ptvp.part;

                        return PTVPDetail(
                          name: part.name,
                          description: ptvp.description,
                          quantity: ptvp.quantity,
                        );
                      }),
                  if (vehiclePart.partsToVehicleParts.isNotEmpty)
                    const Divider()
                ],
              );
            }));
  }
}

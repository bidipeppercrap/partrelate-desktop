import 'package:flutter/material.dart';
import 'package:partrelate_desktop/http/client.dart';
import 'package:partrelate_desktop/model/vehicle_part_detail.dart';
import 'package:partrelate_desktop/utils/words_query.dart';
import 'package:partrelate_desktop/widget/vehicle_part_form.dart';
import 'package:partrelate_desktop/widget/vehicle_part_list.dart';

class VehiclePartCreatePage extends StatefulWidget {
  const VehiclePartCreatePage(
      {super.key, required this.vehicleId, required this.vehicleParts});

  final int vehicleId;
  final List<VehiclePartDetail> vehicleParts;

  @override
  State<VehiclePartCreatePage> createState() => _VehiclePartCreateState();
}

class _VehiclePartCreateState extends State<VehiclePartCreatePage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final noteController = TextEditingController();
  List<VehiclePartDetail> filteredVehicleParts = [];

  @override
  void initState() {
    filteredVehicleParts = widget.vehicleParts;
    nameController.addListener(() {
      setState(() {
        filteredVehicleParts = widget.vehicleParts
            .where((vp) => wordsQuery(nameController.text, vp.name))
            .toList();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> createVehiclePart() async {
      try {
        await dio.post('/vehicle_parts', data: {
          'name': nameController.text,
          'description': descriptionController.text,
          'note': noteController.text,
          'vehicleId': widget.vehicleId
        });

        if (!mounted) return;

        Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    return Center(
      child: Padding(
          padding:
              const EdgeInsets.only(top: 150, left: 27, right: 27, bottom: 150),
          child: SizedBox(
            width: 800,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Icon(Icons.arrow_back)),
                const SizedBox(
                  height: 15,
                ),
                const Text('Create Vehicle Part'),
                const SizedBox(
                  height: 15,
                ),
                Card(
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: VehiclePartForm(
                              nameController: nameController,
                              descriptionController: descriptionController,
                              noteController: noteController,
                            )),
                      ),
                      ElevatedButton(
                          onPressed: createVehiclePart,
                          child: const Icon(Icons.add))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text('Possible duplicates'),
                const SizedBox(
                  height: 15,
                ),
                VehiclePartList(
                  vehicleParts: filteredVehicleParts,
                )
              ],
            ),
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:partrelate_desktop/http/client.dart';
import 'package:partrelate_desktop/widget/vehicle_form.dart';

class VehiclePartUpdatePage extends StatefulWidget {
  const VehiclePartUpdatePage(
      {super.key,
      required this.id,
      required this.name,
      required this.description,
      required this.note,
      required this.vehicleId});

  final int id;
  final String name;
  final String description;
  final String note;
  final int vehicleId;

  @override
  State<VehiclePartUpdatePage> createState() => _VehiclePartUpdatePageState();
}

class _VehiclePartUpdatePageState extends State<VehiclePartUpdatePage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void initState() {
    super.initState();

    nameController.text = widget.name;
    descriptionController.text = widget.description;
    noteController.text = widget.note;
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
    Future<void> updateVehicleOrFailed() async {
      try {
        await dio.put('/vehicle_parts/${widget.id}', data: {
          'name': nameController.text,
          'description': descriptionController.text,
          'note': noteController.text,
          'vehicleId': widget.vehicleId
        });

        if (!mounted) return;

        return Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    return Padding(
      padding: const EdgeInsets.all(150),
      child: Card(
        child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                Text('Updating Vehicle Part: ${widget.name}'),
                const SizedBox(
                  height: 15,
                ),
                VehicleForm(
                  nameController: nameController,
                  descriptionController: descriptionController,
                  noteController: noteController,
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    onPressed: updateVehicleOrFailed,
                    child: const Text('Submit')),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    onPressed: () {
                      return Navigator.pop(context, false);
                    },
                    child: const Text('Cancel'))
              ],
            )),
      ),
    );
  }
}

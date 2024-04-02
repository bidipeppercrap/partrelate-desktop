import 'package:flutter/material.dart';
import 'package:partrelate_desktop/http/client.dart';
import 'package:partrelate_desktop/widget/vehicle_form.dart';

class VehicleUpdatePage extends StatefulWidget {
  const VehicleUpdatePage(
      {super.key,
      required this.id,
      required this.name,
      required this.description,
      required this.note});

  final int id;
  final String name;
  final String description;
  final String note;

  @override
  State<VehicleUpdatePage> createState() => _VehicleUpdatePageState();
}

class _VehicleUpdatePageState extends State<VehicleUpdatePage> {
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
        await dio.put('/vehicles/${widget.id}', data: {
          'name': nameController.text,
          'description': descriptionController.text,
          'note': noteController.text
        });

        if (!mounted) return;

        return Navigator.pop(context, false);
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
                    child: const Text('Submit'))
              ],
            )),
      ),
    );
  }
}

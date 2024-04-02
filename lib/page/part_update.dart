import 'package:flutter/material.dart';
import 'package:partrelate_desktop/http/client.dart';
import 'package:partrelate_desktop/widget/vehicle_form.dart';

class PartUpdatePage extends StatefulWidget {
  const PartUpdatePage(
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
  State<PartUpdatePage> createState() => _PartUpdatePageState();
}

class _PartUpdatePageState extends State<PartUpdatePage> {
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
    Future<void> updatePartOrFailed() async {
      try {
        await dio.put('/parts/${widget.id}', data: {
          'name': nameController.text,
          'description': descriptionController.text,
          'note': noteController.text
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
                Text('Updating Part: ${widget.name}'),
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
                    onPressed: updatePartOrFailed, child: const Text('Submit')),
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

import 'package:flutter/material.dart';
import 'package:partrelate_desktop/http/client.dart';
import 'package:partrelate_desktop/widget/vehicle_form.dart';

class PartCreatePage extends StatefulWidget {
  const PartCreatePage({super.key});

  @override
  State<PartCreatePage> createState() => _PartCreatePageState();
}

class _PartCreatePageState extends State<PartCreatePage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    noteController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> createPartOrFailed() async {
      try {
        await dio.post('/parts', data: {
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
                const Text('Create Part'),
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
                    onPressed: createPartOrFailed, child: const Text('Submit')),
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

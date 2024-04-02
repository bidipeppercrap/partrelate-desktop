import 'package:flutter/material.dart';
import 'package:partrelate_desktop/http/client.dart';
import 'package:partrelate_desktop/model/part.dart';
import 'package:partrelate_desktop/widget/ptvp_form.dart';

class PTVPUpdatePage extends StatelessWidget {
  const PTVPUpdatePage(
      {super.key,
      required this.id,
      required this.part,
      required this.description,
      required this.quantity,
      required this.vehiclePartId});

  final int id;
  final Part part;
  final String description;
  final String quantity;
  final int vehiclePartId;

  @override
  Widget build(BuildContext context) {
    Future<void> updateOrFailed(
        int partId, String description, String quantity) async {
      try {
        await dio.put('/parts_to_vehicle_parts/$id', data: {
          'description': description,
          'quantity': quantity,
          'vehiclePartId': vehiclePartId,
          'partId': partId
        });

        if (!context.mounted) return;

        return Navigator.pop(context, true);
      } catch (e) {
        if (!context.mounted) return;

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
                Text('Updating PTVP: ${part.name}'),
                const SizedBox(
                  height: 15,
                ),
                PTVPForm(
                  initPart: part,
                  initDescription: description,
                  initQuantity: quantity,
                  handleSubmit: (part, description, quantity) =>
                      updateOrFailed(part.id!, description, quantity),
                ),
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

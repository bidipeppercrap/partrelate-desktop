import 'package:flutter/material.dart';
import 'package:partrelate_desktop/widget/rounded_container.dart';

class VehicleDetailCard extends StatelessWidget {
  const VehicleDetailCard(
      {super.key, required this.name, this.description, this.note});

  final String name;
  final String? description;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text(name),
            if (description != null && description!.isNotEmpty) ...[
              const SizedBox(
                height: 15,
              ),
              RoundedContainer(
                child: Text(
                  description ?? '',
                  style: const TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold),
                ),
              )
            ],
            if (note != null && note!.isNotEmpty) ...[
              const SizedBox(
                height: 15,
              ),
              RoundedContainer(
                backgroundColor: Colors.yellow,
                borderColor: Colors.deepOrange,
                child: Text(
                  note ?? '',
                ),
              )
            ],
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: () {}, child: const Icon(Icons.edit)),
                const SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: const ButtonStyle(),
                  child: const Icon(Icons.delete),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

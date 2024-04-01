import 'package:flutter/material.dart';

class VehiclePartForm extends StatelessWidget {
  const VehiclePartForm(
      {super.key,
      this.nameController,
      this.descriptionController,
      this.noteController});

  final TextEditingController? nameController;
  final TextEditingController? descriptionController;
  final TextEditingController? noteController;

  @override
  Widget build(BuildContext context) {
    InputDecoration decorationBuilder([String label = '']) {
      return InputDecoration(
          label: Text(label),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ));
    }

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            decoration: decorationBuilder('Name'),
            controller: nameController,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          flex: 2,
          child: TextField(
            decoration: decorationBuilder('Description'),
            controller: descriptionController,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          flex: 1,
          child: TextField(
            decoration: decorationBuilder('Note'),
            controller: noteController,
          ),
        ),
      ],
    );
  }
}

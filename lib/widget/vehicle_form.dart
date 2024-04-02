import 'package:flutter/material.dart';

InputDecoration decorationBuilder([String label = '']) {
  return InputDecoration(
      label: Text(label),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ));
}

class VehicleForm extends StatelessWidget {
  const VehicleForm(
      {super.key,
      this.nameController,
      this.descriptionController,
      this.noteController});

  final TextEditingController? nameController;
  final TextEditingController? descriptionController;
  final TextEditingController? noteController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: decorationBuilder('Name'),
          controller: nameController,
        ),
        const SizedBox(
          height: 15,
        ),
        TextField(
          decoration: decorationBuilder('Description'),
          controller: descriptionController,
        ),
        const SizedBox(
          height: 15,
        ),
        TextField(
          decoration: decorationBuilder('Note'),
          controller: noteController,
        )
      ],
    );
  }
}

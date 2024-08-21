import 'package:flutter/material.dart';

class EqDateField extends StatelessWidget {
  final TextEditingController dateController;
  final Function(DateTime) onDateSelected;

  EqDateField({required this.dateController, required this.onDateSelected});

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: dateController,
        decoration: const InputDecoration(
            icon: const Icon(Icons.calendar_today),
            hintText: 'Date',
            labelText: 'Date'),
        onTap: () {
          _selectDate(context);
        },
        validator: (value) {
          return null;
        });
  }
}

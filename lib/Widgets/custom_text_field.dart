import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  final String label;
  final bool  obscureText;
  final void Function(String?)? onSaved;

  const CustomTextField({
    super.key,
    required  this.label,
    this.obscureText = false,
    this.onSaved
    });

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: 250,
      child: TextFormField(
        validator: (value){
          if (value == null || value.isEmpty){
            return  'Este campo no puede ir vacio';
          }
          return null;
        },
        onSaved:  onSaved,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
}
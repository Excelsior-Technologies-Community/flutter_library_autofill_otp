import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class Autofillotp extends StatelessWidget {
  final TextEditingController txtCtrl;
  const Autofillotp({super.key,required this.txtCtrl});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: txtCtrl,
      maxLength: 1,
      decoration: InputDecoration(
        border: OutlineInputBorder(

        )
      ),
    );
  }
}

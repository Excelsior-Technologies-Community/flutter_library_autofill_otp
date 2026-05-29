import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Autofillotp extends StatefulWidget {
  final int numberOfTxtFeilds;
  final Color? borderColor;

  const Autofillotp({super.key, required this.numberOfTxtFeilds,this.borderColor});

  @override
  State<Autofillotp> createState() => _AutofillotpState();
}

class _AutofillotpState extends State<Autofillotp> {
  late List<TextEditingController> controllers;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.numberOfTxtFeilds, (index) {
        return SizedBox(
          width: 50,
          child: TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ],
            onTap: () {
            // prevent skipping empty fields
            for (int i = 0; i < index; i++) {
          if (controllers[i].text.isEmpty) {
            FocusScope.of(context).requestFocus(focusNodes[i]);
            return;
          }
        }
      },
            decoration: InputDecoration(
              counterText: "",
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.borderColor ?? Colors.grey
                )
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < widget.numberOfTxtFeilds) {
                FocusScope.of(context).nextFocus();
              }
            },
          ),
        );
      }),
    );
  }
}
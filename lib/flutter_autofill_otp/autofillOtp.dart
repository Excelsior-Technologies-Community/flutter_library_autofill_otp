import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Autofillotp extends StatelessWidget {
  final int numberOfTxtFeilds;
  final Color? borderColor;

  const Autofillotp({super.key, required this.numberOfTxtFeilds,this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(numberOfTxtFeilds, (index) {
        return SizedBox(
          width: 50,
          child: TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: "",
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: borderColor ?? Colors.grey
                )
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < numberOfTxtFeilds) {
                FocusScope.of(context).nextFocus();
              }
            },
          ),
        );
      }),
    );
  }
}
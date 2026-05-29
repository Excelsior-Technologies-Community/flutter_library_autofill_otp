import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Autofillotp extends StatefulWidget {
  final int numberOfTxtFeilds;

  const Autofillotp({super.key, required this.numberOfTxtFeilds});

  @override
  State<Autofillotp> createState() => _AutofillotpState();
}

class _AutofillotpState extends State<Autofillotp> {
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
            decoration: const InputDecoration(counterText: ""),
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

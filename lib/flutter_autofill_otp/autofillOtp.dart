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
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();

    controllers = List.generate(
      widget.numberOfTxtFeilds,
          (_) => TextEditingController(),
    );

    focusNodes = List.generate(
      widget.numberOfTxtFeilds,
          (_) => FocusNode(),
    );
  }
  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.numberOfTxtFeilds, (index) {
        return SizedBox(
          width: 50,
          child: TextField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ],
            onTap: () {
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
                  color: widget.borderColor ?? Colors.grey,
                ),
              ),
            ),

            onChanged: (value) {
              // move back
              if (value.isEmpty && index > 0) {
                FocusScope.of(context).requestFocus(focusNodes[index - 1]);
              }

              // move forward
              else if (value.isNotEmpty) {
                if (index < widget.numberOfTxtFeilds - 1) {
                  FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                } else {
                  FocusScope.of(context).unfocus();
                }
              }
            },
          ),
        );
      }),
    );
  }
}
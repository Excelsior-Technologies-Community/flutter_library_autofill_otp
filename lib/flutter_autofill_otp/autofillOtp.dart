import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AutofillOtp extends StatefulWidget {
  final int numberOfTxtFeilds;
  final Color? borderColor;
  final Function(String otp)? onCompleted;
  final Function(String otp)? onChanged;
  final bool autoFocus;

  const AutofillOtp({
    super.key,
    required this.numberOfTxtFeilds,
    this.borderColor,
    this.onChanged,
    this.onCompleted,
    this.autoFocus = true,
  });

  @override
  State<AutofillOtp> createState() => _AutofillOtpState();
}

class _AutofillOtpState extends State<AutofillOtp> {
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

    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (focusNodes.isNotEmpty) {
          FocusScope.of(context).requestFocus(focusNodes[0]);
        }
      });
    }
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

  String getOtp() {
    return controllers.map((e) => e.text).join();
  }

  void _notify() {
    final otp = getOtp();
    widget.onChanged?.call(otp);

    if (!otp.contains("") && otp.length == widget.numberOfTxtFeilds) {
      widget.onCompleted?.call(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.numberOfTxtFeilds, (index) {
        return SizedBox(
          width: 50,
          child: Focus(
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.backspace) {
                if (controllers[index].text.isEmpty && index > 0) {
                  FocusScope.of(context)
                      .requestFocus(focusNodes[index - 1]);
                }
              }
              return KeyEventResult.ignored;
            },
            child: TextField(
              controller: controllers[index],
              focusNode: focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(1),
              ],

              decoration: InputDecoration(
                counterText: "",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.borderColor ?? Colors.grey,
                  ),
                ),
              ),

              onChanged: (value) {
                // forward move
                if (value.isNotEmpty) {
                  if (index < widget.numberOfTxtFeilds - 1) {
                    FocusScope.of(context)
                        .requestFocus(focusNodes[index + 1]);
                  } else {
                    FocusScope.of(context).unfocus();
                  }
                }

                // backward move (only focus)
                else {
                  if (index > 0) {
                    FocusScope.of(context)
                        .requestFocus(focusNodes[index - 1]);
                  }
                }

                _notify();
              },
            ),
          ),
        );
      }),
    );
  }
}
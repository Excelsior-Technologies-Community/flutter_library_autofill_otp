import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AutofillOtp extends StatefulWidget {
  final int numberOfTextFeilds;
  final Color? enabledBorderColor;
  final Function(String otp)? onCompleted;
  final Function(String otp)? onChanged;
  final bool autoFocus;
  final Color? focusBorderColor;
  final double? focusBorderwidth;

  const AutofillOtp({
    super.key,
    required this.numberOfTextFeilds,
    this.enabledBorderColor,
    this.onChanged,
    this.onCompleted,
    this.autoFocus = true,
    this.focusBorderColor,
    this.focusBorderwidth,
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
      widget.numberOfTextFeilds,
      (_) => TextEditingController(),
    );

    focusNodes = List.generate(widget.numberOfTextFeilds, (_) => FocusNode());

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

    if (!otp.contains("") && otp.length == widget.numberOfTextFeilds) {
      widget.onCompleted?.call(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.numberOfTextFeilds, (index) {
        return SizedBox(
          width: 50,
          child: Focus(
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.backspace) {
                if (controllers[index].text.isEmpty && index > 0) {
                  FocusScope.of(context).requestFocus(focusNodes[index - 1]);
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
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],

              decoration: InputDecoration(
                counterText: "",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.focusBorderColor ?? Colors.grey,
                    width: widget.focusBorderwidth ?? 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.enabledBorderColor ?? Colors.grey,
                  ),
                ),
              ),

              onChanged: (value) {
                //auto fill values
                if (value.length > 1) {
                  for (var controller in controllers) {
                    controller.clear();
                  }

                  for (int i = 0; i < value.length && i < widget.numberOfTextFeilds; i++) {
                    controllers[i].text = value[i];
                  }
                  if (value.length >= widget.numberOfTextFeilds) {
                    FocusScope.of(context).unfocus();
                  } else {
                    FocusScope.of(
                      context,
                    ).requestFocus(focusNodes[value.length]);
                  }

                  _notify();
                  return;
                }

                // forward move
                if (value.isNotEmpty) {
                  if (index < widget.numberOfTextFeilds - 1) {
                    FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                  } else {
                    FocusScope.of(context).unfocus();
                  }
                }
                // backward move (only focus)
                else {
                  if (index > 0) {
                    FocusScope.of(context).requestFocus(focusNodes[index - 1]);
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

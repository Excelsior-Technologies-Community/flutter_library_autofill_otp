import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AutofillOtp extends StatefulWidget {
  final int numberOfTextFields;
  final Color? enabledBorderColor;
  final Function(String otp)? onCompleted;
  final Function(String otp)? onChanged;
  final bool autoFocus;
  final Color? focusBorderColor;
  final double? focusBorderwidth;
  final bool obscureText;
  final bool showCursor;

  const AutofillOtp({
    super.key,
    required this.numberOfTextFields,
    this.enabledBorderColor,
    this.onChanged,
    this.onCompleted,
    this.autoFocus = true,
    this.focusBorderColor,
    this.focusBorderwidth,
    this.obscureText = false,
    this.showCursor = true,
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
      widget.numberOfTextFields,
      (_) => TextEditingController(),
    );

    focusNodes = List.generate(widget.numberOfTextFields, (_) => FocusNode());

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
    if (controllers.every((c) => c.text.isNotEmpty)) {
      widget.onCompleted?.call(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(widget.numberOfTextFields, (index) {
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
                showCursor: widget.showCursor,
                obscureText: widget.obscureText,
                controller: controllers[index],
                focusNode: focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                autofillHints: const [AutofillHints.oneTimeCode],
                // maxLength: 1,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
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
                  if (value.length > 1) {
                    final pastedOtp = value.replaceAll(RegExp(r'[^0-9]'), '');

                    for (int i = 0; i < widget.numberOfTextFields; i++) {
                      if (i < pastedOtp.length) {
                        controllers[i].text = pastedOtp[i];
                      } else {
                        controllers[i].clear();
                      }
                    }

                    // move focus
                    if (pastedOtp.length >= widget.numberOfTextFields) {
                      FocusScope.of(context).unfocus();
                    } else {
                      FocusScope.of(
                        context,
                      ).requestFocus(focusNodes[pastedOtp.length]);
                    }
                    _notify();
                    return;
                  }
                  if (value.isNotEmpty) {
                    if (index < widget.numberOfTextFields - 1) {
                      FocusScope.of(
                        context,
                      ).requestFocus(focusNodes[index + 1]);
                    } else {
                      FocusScope.of(context).unfocus();
                    }
                  } else {
                    if (index > 0) {
                      FocusScope.of(
                        context,
                      ).requestFocus(focusNodes[index - 1]);
                    }
                  }
                  _notify();
                },
                onTap: () {
                  for (int i = 0; i < index; i++) {
                    if (controllers[i].text.isEmpty) {
                      FocusScope.of(context).requestFocus(focusNodes[i]);
                      return;
                    }
                  }
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}

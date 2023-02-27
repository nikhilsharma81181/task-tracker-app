import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String headerText;
  final bool hidden;
  const AuthTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.headerText,
      required this.hidden});

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool isObscure = true;

  void toggleObscure() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            widget.headerText,
            style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 14.5, height: 0.8),
          ),
        ),
        Expanded(
          flex: 9,
          child: SizedBox(
            child: TextFormField(
              controller: widget.controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return widget.hintText;
                }
                return null;
              },
              obscureText: widget.hidden ? isObscure : false,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                suffixIcon: widget.hidden
                    ? IconButton(
                        icon: Icon(
                          isObscure ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey.shade600,
                        ),
                        onPressed: toggleObscure,
                      )
                    : null,
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Colors.grey.shade600),
                focusedBorder:
                    const UnderlineInputBorder(borderSide: BorderSide.none),
                enabledBorder:
                    const UnderlineInputBorder(borderSide: BorderSide.none),
                errorBorder:
                    const UnderlineInputBorder(borderSide: BorderSide.none),
                border: const UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              cursorColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

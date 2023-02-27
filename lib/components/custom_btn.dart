import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBtn extends StatefulWidget {
  final double? height;
  final double? width;
  final Color? btnColor;
  final double? borderRadius;
  final VoidCallback fn;
  final String text;
  bool loading;
  CustomBtn(
      {super.key,
      this.height,
      this.width,
      this.borderRadius,
      required this.fn,
      this.btnColor,
      this.loading = false,
      required this.text});

  @override
  State<CustomBtn> createState() => _CustomBtnState();
}

class _CustomBtnState extends State<CustomBtn> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    isLoading = widget.loading;
    return GestureDetector(
      child: RawMaterialButton(
        fillColor: widget.btnColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 5)),
        constraints: BoxConstraints(
            minWidth: widget.width ?? 100, minHeight: widget.height ?? 40),
        onPressed: () => widget.fn(),
        child: isLoading
            ? const CupertinoActivityIndicator(color: Colors.white)
            : Text(
                widget.text,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontSize: 16),
              ),
      ),
    );
  }
}

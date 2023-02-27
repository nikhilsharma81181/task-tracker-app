import 'package:flutter/material.dart';

customDialog(BuildContext context, int seconds) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            alignment: Alignment.center,
            child: const Text("Doc is saved to Downloads folder"),
          ),
        ],
      ),
    ),
  );
  Future.delayed(Duration(seconds: seconds), () {
    Navigator.of(context).pop();
  });
}

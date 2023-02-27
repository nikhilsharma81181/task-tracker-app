import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/config/colors.dart';
import 'package:task_tracker/provider/project_prov.dart';

class ColorOptionPicker extends StatefulWidget {
  const ColorOptionPicker({super.key});

  @override
  State<ColorOptionPicker> createState() => _ColorOptionPickerState();
}

class _ColorOptionPickerState extends State<ColorOptionPicker> {
  List<Map> colors = projectColors;

  @override
  Widget build(BuildContext context) {
    int selectedColorIndex =
        context.watch<ProjectProvider>().selectedColorIndex;
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        itemBuilder: (context, index) {
          Color itemColor = covertColor(colors[index]['color']);
          return GestureDetector(
            onTap: () {
              context.read<ProjectProvider>().selectColor(index);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: itemColor,
                border: selectedColorIndex == index
                    ? Border.all(color: Colors.white, width: 2.5)
                    : null,
              ),
              height: 30,
              width: 30,
            ),
          );
        },
      ),
    );
  }
}

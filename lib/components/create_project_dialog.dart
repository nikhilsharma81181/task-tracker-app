import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/components/custom_textfield_style.dart';
import 'package:task_tracker/config/colors.dart';
import 'package:task_tracker/provider/login_prov.dart';

import '../provider/project_prov.dart';
import '../view/project/project_details.dart';
import 'color_picker.dart';
import 'custom_btn.dart';

class CreateProjectDialog extends StatefulWidget {
  final String? projectId;
  final bool isCreate;
  final String? text;
  final String? colorCode;
  const CreateProjectDialog(
      {super.key,
      required this.isCreate,
      this.text = "",
      this.colorCode = "",
      this.projectId = ""});

  @override
  State<CreateProjectDialog> createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends State<CreateProjectDialog> {
  TextEditingController textCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Map> colors = projectColors;

  @override
  void initState() {
    for (int i = 0; i < projectColors.length; i++) {
      if (projectColors[i]['color'] == widget.colorCode) {
        context.read<ProjectProvider>().selectColor(i);
      }
    }
    setState(() {
      textCtrl.text = widget.text ?? '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double width = MediaQuery.of(context).size.width;
    final userProv = context.watch<UserProvider>();
    return Consumer<ProjectProvider>(builder: (context, prov, child) {
      String projectColor = projectColors[prov.selectedColorIndex]['color'];
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isCreate ? 'Create Project' : 'Update Project',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontSize: 25),
                ),
                const SizedBox(height: 25),
                Text(
                  'Name*',
                  style: textTheme.bodyText2?.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: textCtrl,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Project name is required";
                    }
                    return null;
                  },
                  decoration: customTextFieldStyle("Enter a project name"),
                ),
                const SizedBox(height: 15),
                const ColorOptionPicker(),
                const SizedBox(height: 15),
                CustomBtn(
                  width: width,
                  height: 45,
                  text: widget.isCreate ? 'Create' : 'Update',
                  borderRadius: 8,
                  btnColor: kscaffoldColor,
                  fn: () async {
                    final nav = Navigator.of(context);
                    if (_formKey.currentState!.validate()) {
                      if (widget.isCreate) {
                        String projectId = await prov.createProject(
                          userProv.userId,
                          userProv.userToken,
                          textCtrl.text,
                          projectColor,
                        );
                        log("step1");
                        if (projectId != "") {
                          prov.resetColor();
                          nav.pop();
                          nav.push(
                            MaterialPageRoute(
                              builder: (context) => ProjectDetails(
                                projectId: projectId,
                                projectIndex: 0,
                                projectData: null,
                                name: textCtrl.text,
                              ),
                            ),
                          );
                        }
                      } else {
                        bool success = await prov.updateProject(
                          widget.projectId ?? "",
                          userProv.userToken,
                          userProv.userId,
                          textCtrl.text,
                          projectColor,
                        );
                        if (success) {
                          nav.pop();
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

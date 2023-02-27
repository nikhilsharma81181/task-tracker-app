import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/config/colors.dart';
import 'package:task_tracker/provider/login_prov.dart';

import '../Services/task_service.dart';
import '../provider/project_prov.dart';
import '../provider/task_prov.dart';
import 'custom_btn.dart';
import 'custom_textfield_style.dart';

class CreateTaskDialog extends StatefulWidget {
  final String projectId;
  final Status status;
  const CreateTaskDialog(
      {super.key, required this.projectId, required this.status});

  @override
  State<CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  TextEditingController textCtrl = TextEditingController();
  TextEditingController desCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double width = MediaQuery.of(context).size.width;
    final userProv = context.watch<UserProvider>();
    return Consumer<ProjectProvider>(builder: (context, prov, child) {
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
                  'Add Task',
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
                    return null;
                  },
                  decoration: customTextFieldStyle("Enter a task name"),
                ),
                const SizedBox(height: 15),
                Text(
                  'Description',
                  style: textTheme.bodyText2?.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: desCtrl,
                  decoration: customTextFieldStyle("Enter task description"),
                ),
                const SizedBox(height: 15),
                CustomBtn(
                  width: width,
                  height: 45,
                  text: 'Create',
                  borderRadius: 8,
                  btnColor: Theme.of(context).primaryColor,
                  fn: () async {
                    final nav = Navigator.of(context);
                    if (_formKey.currentState!.validate()) {
                      if (!isLoading) {
                        isLoading = true;
                        bool success =
                            await context.read<TaskProvider>().addTask(
                                  widget.projectId,
                                  userProv.userId,
                                  userProv.userToken,
                                  textCtrl.text,
                                  desCtrl.text,
                                  widget.status,
                                );
                        isLoading = false;
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

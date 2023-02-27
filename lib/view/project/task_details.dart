import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/model/comment_model.dart';
import 'package:task_tracker/model/task_model.dart';
import 'package:task_tracker/provider/comment_prov.dart';
import 'package:task_tracker/provider/login_prov.dart';
import 'package:task_tracker/provider/task_prov.dart';
import 'package:task_tracker/utils/date_time_converter.dart';

import '../../Services/task_service.dart';
import '../../components/custom_btn.dart';

class TasksDetails extends StatefulWidget {
  final List<TaskModel> allTasks;
  final int index;
  final Status status;
  const TasksDetails(
      {super.key,
      required this.allTasks,
      required this.index,
      required this.status});

  @override
  State<TasksDetails> createState() => _TasksDetailsState();
}

class _TasksDetailsState extends State<TasksDetails> {
  TextEditingController commentCtrl = TextEditingController();
  DateTimeConverter dateTimeConverter = DateTimeConverter();
  bool _isEditingTitle = false;
  bool _isEditingDescription = false;
  String _title = 'Title';
  String _description = 'Description';

  bool isFetching = true;

  @override
  void initState() {
    setState(() {
      TaskModel task = widget.allTasks[widget.index];
      _title = task.name;
      _description = task.desc;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final userProv = context.watch<UserProvider>();
    if (widget.allTasks.isNotEmpty) {
      TaskModel task = widget.allTasks[widget.index];
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          setState(() {
            _isEditingTitle = false;
            _isEditingDescription = false;
          });
        },
        child: Container(
          color: Colors.white.withOpacity(0.001),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Theme.of(context).dividerColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() => _isEditingTitle = true);
                      },
                      child: Container(
                        height: 62,
                        alignment: Alignment.centerLeft,
                        child: _isEditingTitle
                            ? TextFormField(
                                initialValue: _title,
                                decoration: InputDecoration(
                                  hintText: 'Title',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onFieldSubmitted: (value) {
                                  setState(() {
                                    _title = value;
                                    _isEditingTitle = false;
                                    task.name = _title;
                                  });
                                  context.read<TaskProvider>().updateTask(
                                        task.id,
                                        userProv.userToken,
                                        widget.status,
                                        false,
                                        _title,
                                        _description,
                                        task.duration,
                                      );
                                },
                              )
                            : Text(
                                _title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(fontSize: 20),
                              ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isEditingDescription = true;
                        });
                      },
                      child: SizedBox(
                        height: 62,
                        child: _isEditingDescription
                            ? TextFormField(
                                initialValue: _description,
                                decoration: InputDecoration(
                                  hintText: 'Description',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onFieldSubmitted: (value) {
                                  setState(() {
                                    _description = value;
                                    _isEditingDescription = false;
                                    task.desc = _description;
                                  });
                                  context.read<TaskProvider>().updateTask(
                                        task.id,
                                        userProv.userToken,
                                        widget.status,
                                        false,
                                        _title,
                                        _description,
                                        task.duration,
                                      );
                                },
                              )
                            : Text(
                                _description,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(fontSize: 16),
                              ),
                      ),
                    ),
                    commentSection(task.id),
                    CustomBtn(
                      fn: () async {
                        final nav = Navigator.of(context);
                        bool success =
                            await context.read<TaskProvider>().deleteTask(
                                  task.id,
                                  userProv.userToken,
                                );
                        if (success) {
                          widget.allTasks.removeAt(widget.index);
                          nav.pop();
                        }
                      },
                      text: 'Delete',
                      width: width,
                      height: 50,
                      btnColor: Colors.red.shade400,
                      borderRadius: 8,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return const Center(
        child: SizedBox(),
      );
    }
  }

  Widget commentSection(taskId) {
    final userProv = context.watch<UserProvider>();
    double width = MediaQuery.of(context).size.width;
    return Consumer<CommentProvider>(
      builder: (context, prov, child) {
        if (isFetching) {
          prov.getComments(
            taskId,
            userProv.userToken,
          );
          isFetching = false;
        }
        if (prov.comments == null || prov.comments!.isNotEmpty) {
          List<CommentModel> comments = prov.comments ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Comments',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 60,
                child: TextFormField(
                  controller: commentCtrl,
                  decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.white),
                      )),
                  cursorColor: Colors.white,
                  onFieldSubmitted: (value) {
                    prov.addComments(value, taskId,
                        DateTime.now().toIso8601String(), userProv.userToken);
                    commentCtrl.clear();
                  },
                ),
              ),
              Container(
                height: 400,
                padding: const EdgeInsets.only(top: 25, bottom: 50),
                child: ListView(
                  children: [
                    for (var i = 0; i < comments.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: width * 0.73,
                                  child: Text(
                                    comments[i].text,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        ?.copyWith(fontSize: 16, height: 1.5),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      await prov.deleteComments(
                                          userProv.userId,
                                          comments[i].id,
                                          userProv.userToken,
                                          i);
                                      // if (success) {
                                      //   prov.comments!.removeAt(i);
                                      // }
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                            Text(
                              "${dateTimeConverter.getDateName(comments[i].time)} ${dateTimeConverter.getTime(comments[i].time)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(
                                    fontSize: 14,
                                    height: 2,
                                    color: Colors.grey.shade500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const Center(
              child: CupertinoActivityIndicator(color: Colors.white));
        }
      },
    );
  }
}

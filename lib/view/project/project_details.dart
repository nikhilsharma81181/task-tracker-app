import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/components/create_task_dialog.dart';
import 'package:task_tracker/components/custom_dialog.dart';
import 'package:task_tracker/config/colors.dart';
import 'package:task_tracker/model/project_model.dart';
import 'package:task_tracker/utils/date_time_converter.dart';
import 'package:task_tracker/view/project/statistics.dart';
import 'package:task_tracker/view/project/task_details.dart';

import '../../Services/task_service.dart';
import '../../model/task_model.dart';
import '../../provider/login_prov.dart';
import '../../provider/task_prov.dart';

class ProjectDetails extends StatefulWidget {
  final String projectId;
  final ProjectModel? projectData;
  final String name;

  const ProjectDetails(
      {super.key,
      required this.projectData,
      required int projectIndex,
      required this.name,
      required this.projectId});

  @override
  State<ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  DateTimeConverter dateTimeConverter = DateTimeConverter();
  TaskService taskService = TaskService();
  bool isFetching = true;

  @override
  Widget build(BuildContext context) {
    final userProv = context.watch<UserProvider>();
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kscaffoldColor,
      appBar: appBar(),
      body: Consumer<TaskProvider>(
        builder: (context, prov, child) {
          if (isFetching) {
            prov.getProject(
              widget.projectId,
              userProv.userToken,
            );
            isFetching = false;
          }
          if (prov.tasks == null || prov.tasks!.isNotEmpty) {
            return CarouselSlider(
              items: [
                _buildColumn('To Do', prov.toDoTasks ?? [], Status.TODO),
                _buildColumn('In Progress', prov.inProgressTasks ?? [],
                    Status.INPROGRESS),
                _buildColumn('Done', prov.doneTasks ?? [], Status.DONE),
              ],
              options: CarouselOptions(
                height: height,
                enableInfiniteScroll: false,
                viewportFraction: 0.9,
                onPageChanged: (index, reason) {},
              ),
            );
          } else {
            return const Center(
                child: CupertinoActivityIndicator(color: Colors.white));
          }
        },
      ),
    );
  }

  Widget _buildColumn(String title, List<TaskModel> tasks, Status status) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final userProv = context.watch<UserProvider>();
    final taskProv = context.watch<TaskProvider>();
    return SizedBox(
      width: width * 0.9,
      height: height,
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "$title (${tasks.length})",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          for (var i = 0; i < tasks.length; i++)
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  builder: (context) => TasksDetails(
                    allTasks: tasks,
                    index: i,
                    status: status,
                  ),
                );
              },
              child: Draggable<TaskModel>(
                data: tasks[i],
                onDragCompleted: () {
                  setState(() {
                    tasks.removeAt(i);
                  });
                },
                feedback: Material(
                  color: kCardColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17)),
                  elevation: 4,
                  child: buildCard(tasks, tasks[i], width, i),
                ),
                childWhenDragging: const SizedBox.shrink(),
                child: buildCard(tasks, tasks[i], width, i),
              ),
            ),
          addTask(width, status),
          SizedBox(
            height: height * 0.7,
            child: DragTarget<TaskModel>(
              onWillAccept: (data) => true,
              onAccept: (data) {
                final taskProv = context.read<TaskProvider>();
                setState(() {
                  String statusString = status.toString().split('.').last;
                  String formattedString = statusString[0].toUpperCase() +
                      statusString.substring(1).toUpperCase();
                  log("Status log: ${data.status}");
                  data.status = formattedString;
                  log("Status log: ${data.status}");
                  tasks.add(data);
                });
                taskProv.updateTask(data.id, userProv.userToken, status, true,
                    "", "", data.duration);
                if (data.isActive) {
                  Future.delayed(const Duration(seconds: 1), () {
                    taskProv.stopTimer(data);
                  });
                }
              },
              builder: (context, candidateData, rejectedData) {
                return SizedBox(
                  height: double.infinity,
                  width: width * 0.9,
                );
              },
            ),
          ),
          // const SizedBox(height: 8),
          // _buildDropTarget(title, tasks),
        ],
      ),
    );
  }

  Widget addTask(double width, Status status) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) =>
                CreateTaskDialog(projectId: widget.projectId, status: status));
      },
      child: Container(
        height: 55,
        margin: const EdgeInsets.all(8),
        width: width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          color: kCardColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.add,
              color: Colors.white,
              size: 25,
            ),
            Text(
              ' Add Task',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(List<TaskModel> tasks, TaskModel task, width, int index) {
    String time = dateTimeConverter.formatSeconds(task.duration);
    final userProv = context.watch<UserProvider>();
    return Container(
      height: 74,
      width: width * 0.9,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        color: kCardColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  title: Text(
                    task.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(task.desc),
                ),
              ],
            ),
          ),
          if (task.status == "INPROGRESS")
            GestureDetector(
              onTap: () {
                final taskProv = context.read<TaskProvider>();
                if (task.isActive) {
                  taskProv.stopTimer(task);
                } else {
                  taskProv.startTimer(tasks, task, task.id, userProv.userToken);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  decoration: BoxDecoration(
                      color: task.isActive
                          ? Colors.green.shade900.withOpacity(0.6)
                          : Colors.red.shade900.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Icon(task.isActive ? Icons.pause : Icons.play_arrow,
                          color: task.isActive
                              ? Colors.green.shade100
                              : Colors.red.shade100),
                      Text(
                        " $time  ",
                        style: TextStyle(
                            fontSize: 17,
                            color: task.isActive
                                ? Colors.green.shade100
                                : Colors.red.shade100),
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  AppBar appBar() {
    final taskProv = context.watch<TaskProvider>();
    final userProv = context.watch<UserProvider>();
    return AppBar(
      backgroundColor: kscaffoldColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      title: Text(
        widget.name,
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Statistics(tasks: taskProv.tasks)));
          },
          icon: const Icon(
            Icons.pie_chart_rounded,
            size: 28,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            onPressed: () async {
              bool success = await taskService.getCSV(
                userProv.userId,
                widget.projectId,
                userProv.userToken,
              );
              if (success) {
                // ignore: use_build_context_synchronously
                customDialog(context, 2);
              }
            },
            icon: const Icon(
              Icons.cloud_download,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }
}

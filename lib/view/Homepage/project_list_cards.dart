import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/model/project_model.dart';
import 'package:task_tracker/provider/login_prov.dart';
import 'package:task_tracker/provider/project_prov.dart';

import '../../components/create_project_dialog.dart';
import '../../config/colors.dart';
import '../project/project_details.dart';

class ProjectListCards extends StatefulWidget {
  final List<ProjectModel> projects;
  final int index;

  const ProjectListCards(
      {super.key, required this.projects, required this.index});

  @override
  State<ProjectListCards> createState() => _ProjectListCardsState();
}

class _ProjectListCardsState extends State<ProjectListCards> {
  late Color color;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    TextTheme textTheme = Theme.of(context).textTheme;
    ProjectModel projectDetails = widget.projects[widget.index];
    Color color = covertColor(projectDetails.color);
    final userProv = context.watch<UserProvider>();
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProjectDetails(
                  projectData: widget.projects[widget.index],
                  projectIndex: widget.index,
                  name: widget.projects[widget.index].name,
                  projectId: widget.projects[widget.index].id,
                )));
      },
      onLongPress: () {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
              title: const Text('Choose Option'),
              actions: [
                buildOptions("Update", () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) => CreateProjectDialog(
                      isCreate: false,
                      colorCode: projectDetails.color,
                      text: projectDetails.name,
                      projectId: projectDetails.id,
                    ),
                  );
                }),
                buildOptions("Deleted", () async {
                  final nav = Navigator.of(context);
                  bool success =
                      await context.read<ProjectProvider>().deleteProject(
                            projectDetails.id,
                            userProv.userToken,
                            userProv.userId,
                          );
                  if (success) {
                    nav.pop();
                  }
                }),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        );
      },
      child: Container(
        height: 52,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: deviceWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: kCardColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                  height: 15,
                  width: 15,
                ),
                const SizedBox(width: 10),
                Text(
                  projectDetails.name,
                  style: textTheme.bodyText2?.copyWith(fontSize: 16),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
            )
          ],
        ),
      ),
    );
  }

  Widget buildOptions(String title, VoidCallback fn) {
    return CupertinoActionSheetAction(
      onPressed: () async {
        fn();
      },
      child: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/model/project_model.dart';
import 'package:task_tracker/provider/project_prov.dart';

import '../../components/create_project_dialog.dart';
import '../Homepage/project_list_cards.dart';

class ProjectListView extends StatelessWidget {
  const ProjectListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectProvider>(
      builder: (_, prov, __) {
        TextTheme textTheme = Theme.of(context).textTheme;
        List<ProjectModel> projects = prov.projects ?? [];
        return GestureDetector(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Projects',
                    style: textTheme.bodyText1?.copyWith(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<ProjectProvider>().resetColor();
                      showDialog(
                        context: context,
                        builder: (context) => const CreateProjectDialog(
                          isCreate: true,
                          colorCode: '',
                          text: '',
                        ),
                      );
                    },
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              for (var i = 0; i < projects.length; i++)
                ProjectListCards(
                  index: i,
                  projects: projects,
                ),
            ],
          ),
        );
      },
    );
  }
}

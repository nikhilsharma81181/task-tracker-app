import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/config/colors.dart';
import 'package:task_tracker/provider/login_prov.dart';

import 'package:task_tracker/provider/theme_prov.dart';
import 'package:task_tracker/view/auth/signin.dart';

import '../../components/create_project_dialog.dart';
import '../../components/custom_btn.dart';
import '../../provider/project_prov.dart';
import '../project/project_listview.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isFetching = true;
  @override
  Widget build(BuildContext context) {
    final toggleTheme = context.read<ThemeProvider>();
    final userProv = context.watch<UserProvider>();
    bool isDark = context.watch<ThemeProvider>().isDark();
    return Scaffold(
      backgroundColor: kscaffoldColor,
      appBar: _appBar(isDark, toggleTheme),
      body: Consumer<ProjectProvider>(
        builder: (context, prov, child) {
          if (isFetching) {
            prov.getProject(userProv.userId, userProv.userToken);
            isFetching = false;
          }
          if (prov.projects == null || prov.projects!.isNotEmpty) {
            List projects = prov.projects ?? [];
            return Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child:
                  projects.isEmpty ? isProjectEmpty() : const ProjectListView(),
            );
          } else {
            return const Center(
                child: CupertinoActivityIndicator(color: Colors.white));
          }
        },
      ),
    );
  }

  Widget isProjectEmpty() {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'You don\'t have any project right now, Let\'s create a new project',
          style: textTheme.bodyText2?.copyWith(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        CustomBtn(
          width: 140,
          height: 37,
          text: 'Create project',
          borderRadius: 8,
          btnColor: kCardColor,
          fn: () {
            context.read<ProjectProvider>().resetColor();
            showDialog(
              context: context,
              builder: (context) => const CreateProjectDialog(),
            );
          },
        ),
      ],
    );
  }

  AppBar _appBar(isDark, toggleTheme) => AppBar(
        backgroundColor: kscaffoldColor,
        elevation: 0,
        // leading: IconButton(
        //   icon: Icon(
        //     isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
        //   ),
        //   onPressed: () {
        //     toggleTheme.toggleTheme();
        //   },
        // ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const SignIn()));
              context.read<UserProvider>().logOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      );
}

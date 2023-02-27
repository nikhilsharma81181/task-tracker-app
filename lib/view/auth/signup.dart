import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/config/colors.dart';
import 'package:task_tracker/provider/login_prov.dart';
import 'package:task_tracker/view/Homepage/homepage.dart';
import 'package:task_tracker/view/auth/signin.dart';

import '../../components/custom_btn.dart';
import 'components/textfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _rePasswordCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool invalidCredential = false;
  String invalidText = "Invalid Credential";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kscaffoldColor,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              width: width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: kBackgroundColor,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AuthTextField(
                      controller: _nameCtrl,
                      hintText: 'Enter your name',
                      headerText: 'Name',
                      hidden: false,
                    ),
                    const Divider(
                      thickness: 1,
                      height: 10,
                      color: Colors.grey,
                    ),
                    AuthTextField(
                      controller: _emailCtrl,
                      hintText: 'Enter your email',
                      headerText: 'Email',
                      hidden: false,
                    ),
                    const Divider(
                      thickness: 1,
                      height: 10,
                      color: Colors.grey,
                    ),
                    AuthTextField(
                      controller: _passwordCtrl,
                      hintText: 'Enter your password',
                      headerText: 'Password',
                      hidden: true,
                    ),
                    const Divider(
                      thickness: 1,
                      height: 10,
                      color: Colors.grey,
                    ),
                    AuthTextField(
                      controller: _rePasswordCtrl,
                      hintText: 'Confirm your password',
                      headerText: 'Confirm Password',
                      hidden: true,
                    ),
                  ],
                ),
              ),
            ),
            if (invalidCredential)
              Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    invalidText,
                    style: TextStyle(fontSize: 15, color: Colors.red.shade400),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            CustomBtn(
              width: width * 0.9,
              height: 50,
              text: 'Create Account',
              borderRadius: 8,
              btnColor: const Color(0xFF292929),
              loading: isLoading,
              fn: () async {
                if (_formKey.currentState!.validate()) {
                  if (_passwordCtrl.text == _rePasswordCtrl.text) {
                    if (!isLoading) {
                      // setState(() => isLoading = true);
                      final userProv = context.read<UserProvider>();
                      final nav = Navigator.of(context);
                      String res = await userProv.signUp(
                          _nameCtrl.text, _emailCtrl.text, _passwordCtrl.text);
                      if (res != 'Invalid' &&
                          res != "" &&
                          res != "User Exists") {
                        nav.pushReplacement(MaterialPageRoute(
                            builder: (context) => const Homepage()));
                      }
                      if (res == "User Exists") {
                        setState(() {
                          invalidCredential = true;
                          invalidText = "User Already Exists";
                        });
                      } else {
                        setState(() {
                          invalidCredential = true;
                          invalidText = "Invalid Credential";
                        });
                      }
                      setState(() => isLoading = false);
                    }
                  } else {
                    setState(() {
                      invalidCredential = true;
                      invalidText = "Password not matching";
                    });
                  }
                }
              },
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account? ',
                  style: TextStyle(fontSize: 15),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignIn()));
                  },
                  child: const Text(
                    'Sign In ',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

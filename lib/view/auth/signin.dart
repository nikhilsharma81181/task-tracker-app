import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/config/colors.dart';
import 'package:task_tracker/view/auth/components/textfield.dart';
import 'package:task_tracker/view/auth/signup.dart';

import '../../components/custom_btn.dart';
import '../../provider/login_prov.dart';
import '../Homepage/homepage.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool invalidCredential = false;

  Future<void> loginFn() async {
    if (_formKey.currentState!.validate()) {
      if (!isLoading) {
        setState(() => isLoading = true);
        final userProv = context.read<UserProvider>();
        final nav = Navigator.of(context);
        String res = await userProv.logIn(_emailCtrl.text, _passwordCtrl.text);
        if (res != 'Invalid' && res != "") {
          nav.pushReplacement(
              MaterialPageRoute(builder: (context) => const Homepage()));
        } else {
          setState(() => invalidCredential = true);
        }
        setState(() => isLoading = false);
      }
    }
  }

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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
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
                  ],
                ),
              ),
            ),
            if (invalidCredential)
              Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Invalid Credential',
                    style: TextStyle(fontSize: 15, color: Colors.red.shade400),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            CustomBtn(
              width: width * 0.9,
              height: 50,
              text: 'Sign In',
              borderRadius: 8,
              loading: isLoading,
              btnColor: const Color(0xFF292929),
              fn: () async {
                await loginFn();
              },
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t have an account? ',
                  style: TextStyle(fontSize: 15),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUp()));
                  },
                  child: const Text(
                    'Sign Up ',
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

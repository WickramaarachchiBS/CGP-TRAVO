import 'package:flutter/material.dart';
import 'package:newone/constants.dart';
import 'package:newone/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = 'Please fill in all fields';
        isLoading = false;
      });
      return;
    }

    try {
      await authService.value.signIn(
        email: email,
        password: password,
      );
      print('Login successful');
      Navigator.pushNamed(context, '/auth');
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found with this email.';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is badly formatted.';
            break;
          default:
            errorMessage = e.message ?? 'An error occurred during sign-in.';
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'An unexpected error occurred: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 80.0, horizontal: 30.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //logo and title--------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'logo',
                      child: Container(
                        child: Image.asset(
                          'assets/7720738.png',
                          height: 150,
                          width: 150,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                //input boxes------------------------------------
                Text(
                  'Email:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                TextField(
                  controller: emailController,
                  onChanged: (value) {
                    //Do something with the user input.
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email',
                      suffixIcon: Icon(
                        Icons.person,
                        color: Colors.blueAccent.shade100,
                      )),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Password:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  onChanged: (value) {
                    //Do something with the user input.
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Password',
                      suffixIcon: Icon(
                        Icons.lock_rounded,
                        color: Colors.blueAccent.shade100,
                      )),
                ),
                //forgot password--------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/ForgotPW');
                        //Implement forgot password functionality.
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent.shade100,
                        ),
                      ),
                    ),
                  ],
                ),
                //error message---------------------------------
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
                //divider----------------------------------------
                SizedBox(
                  height: 70,
                  width: 0,
                  child: Divider(
                    height: 0,
                    thickness: 2,
                    color: Colors.lightBlueAccent.shade100,
                  ),
                ),
                //social media buttons----------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 45.0,
                          height: 45.0,
                          decoration: BoxDecoration(
                            color: Colors.lightBlue.shade100,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.lightBlue.shade700,
                              width: 2.5,
                            ),
                          ),
                          child: Image.asset('assets/icon-google.png', height: 50, width: 50),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Container(
                          width: 45.0,
                          height: 45.0,
                          decoration: BoxDecoration(
                            color: Colors.lightBlue.shade100,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.lightBlue.shade700,
                              width: 2.5,
                            ),
                          ),
                          child: Image.asset('assets/icons8-facebook-24.png', height: 50, width: 50),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Container(
                          width: 45.0,
                          height: 45.0,
                          decoration: BoxDecoration(
                            color: Colors.lightBlue.shade100,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.lightBlue.shade700,
                              width: 2.5,
                            ),
                          ),
                          child: Image.asset('assets/insta.png', height: 50, width: 50),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                //login button---------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Material(
                        // color: Colors.cyan.shade600,
                        borderRadius: BorderRadius.circular(30),
                        child: ElevatedButton(
                          onPressed: isLoading ? null : signIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan.shade600,
                            elevation: 5,
                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text('Register'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

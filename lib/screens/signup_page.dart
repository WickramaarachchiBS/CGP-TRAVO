import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newone/constants.dart';
import 'package:newone/services/auth_services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = 'Please fill in all fields';
        isLoading = false;
      });
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() {
        errorMessage = 'Please enter a valid email address';
        isLoading = false;
      });
      return;
    }

    try {
      await authService.value.signUp(
        name: name,
        email: email,
        password: password,
      );
      // Navigate to login page or home page after successful signup
      Navigator.pushReplacementNamed(context, '/login'); // Adjust route as needed
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'The email address is badly formatted.';
            break;
          case 'email-already-in-use':
            errorMessage = 'The email address is already in use.';
            break;
          case 'weak-password':
            errorMessage = 'The password is too weak.';
            break;
          default:
            errorMessage = e.message ?? 'An error occurred during signup.';
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
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 60.0),
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
                    child: Image.asset(
                      'assets/logo.png',
                      height: 150,
                      width: 150,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Join with Travo!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              //input boxes------------------------------------
              Text(
                'Name:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
              TextField(
                controller: nameController,
                onChanged: (value) {
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your full name',
                    suffixIcon: Icon(
                      Icons.person,
                      color: Colors.blueAccent.shade100,
                    )),
              ),
              SizedBox(height: 20.0),
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
                    hintText: 'hello@gmail.com',
                    suffixIcon: Icon(
                      Icons.email,
                      color: Colors.blueAccent.shade100,
                    )),
              ),
              SizedBox(height: 20.0),
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
              SizedBox(
                height: 10.0,
              ),
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
                        child: Image.asset(
                          'assets/icon-google.png',
                          height: 50,
                          width: 50,
                        ),
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
                        child: Image.asset(
                          'assets/icons8-facebook-24.png',
                          height: 50,
                          width: 50,
                        ),
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
                        child: Image.asset(
                          'assets/insta.png',
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              //register button---------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Material(
                      // color: Colors.cyan.shade600,
                      borderRadius: BorderRadius.circular(30),
                      child: ElevatedButton(
                        onPressed: isLoading ? null : signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan.shade600,
                          elevation: 5,
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Create an account',
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
              //already have an account-------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                      //Go to login screen.
                    },
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent.shade100,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

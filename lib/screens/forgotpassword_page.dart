import 'package:flutter/material.dart';
import 'package:newone/constants.dart';

class ForgotPWPage extends StatefulWidget {
  const ForgotPWPage({super.key});

  @override
  State<ForgotPWPage> createState() => _ForgotPWPageState();
}

class _ForgotPWPageState extends State<ForgotPWPage> {
  final TextEditingController _emailController = TextEditingController();

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
                          'assets/logo.png',
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
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0),
                  child: Text(
                    'Don\'t worry! It occurs. Please enter the email address linked with your account.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
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
                  controller: _emailController,
                  onChanged: (value) {
                    //Do something with the user input.
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'example@gmail.com',
                      suffixIcon: Icon(
                        Icons.person,
                        color: Colors.blueAccent.shade100,
                      )),
                ),
                SizedBox(
                  height: 70.0,
                ),
                //register button---------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Material(
                        borderRadius: BorderRadius.circular(30),
                        child: ElevatedButton(
                          onPressed: () {
                            bool isValidEmail = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(_emailController.text);
                            if (isValidEmail) {
                              Navigator.pushNamed(context, '/verify');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please enter a valid email address.'),
                                  backgroundColor: Colors.redAccent,
                                  duration: Duration(seconds: 2),
                                  shape: RoundedRectangleBorder(
                                      // borderRadius: BorderRadius.,
                                      ),
                                ),
                              );
                            }
                            //Implement registration functionality.
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan.shade600,
                            elevation: 5,
                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Send Code',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

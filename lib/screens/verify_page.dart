import 'package:flutter/material.dart';
import 'package:newone/components/verify_inputbox.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final List<TextEditingController> controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  void VerifyCode() {
    String otp = controllers.map((controller) => controller.text).join();
    print('Entered OTP:  $otp'); //verification functions
  }

  void resendCode() {
    print("Resending OTP..."); //resend code functions
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
                      'Verify',
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
                  'Enter code here:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return OtpBox(
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      index: index,
                      totalBoxes: 6,
                    );
                  }),
                ),
                SizedBox(
                  height: 20.0,
                ),
                //buttons----------------------------------------
                SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  onPressed: VerifyCode,
                  child: Text('Verify'),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextButton(
                  onPressed: resendCode,
                  child: Text('Resend Code'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

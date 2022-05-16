import 'package:flutter/material.dart';
import 'package:my_test_app/screen/auth/otp.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class PhoneSignInPage extends StatefulWidget {
  const PhoneSignInPage({Key? key}) : super(key: key);

  @override
  State<PhoneSignInPage> createState() => _PhoneSignInPageState();
}

class _PhoneSignInPageState extends State<PhoneSignInPage> {
  final _formKey = GlobalKey<FormState>();
  var buttonStatus = ButtonState.idle;
  var phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login With Phone Number'),
        ),
        body: Container(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter Mobile Number',
                  ),
                  controller: phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter phone number";
                    } else if (value.length != 10) {
                      return "The phone number should be 10 digits";
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    ProgressButton.icon(
                        iconedButtons: {
                          ButtonState.idle: IconedButton(
                              text: "Send Code",
                              icon: const Icon(Icons.send, color: Colors.white),
                              color: Colors.deepPurple.shade500),
                          ButtonState.loading: IconedButton(
                              text: "Loading",
                              color: Colors.deepPurple.shade700),
                          ButtonState.fail: IconedButton(
                              text: "Failed",
                              icon:
                                  const Icon(Icons.cancel, color: Colors.white),
                              color: Colors.red.shade300),
                          ButtonState.success: IconedButton(
                              text: "Success",
                              icon: const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                              color: Colors.green.shade400)
                        },
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OtpVerificationPage(
                                        phoneNumber: phone.text)));
                          } else {
                            setState(() {
                              buttonStatus = ButtonState.idle;
                            });
                          }
                        },
                        state: buttonStatus),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:my_test_app/screen/homepage.dart';
import 'package:my_test_app/screen/profile/profile.dart';
import 'package:my_test_app/service/firebaseservice.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:my_test_app/screen/auth/loginpage.dart';
import 'package:email_validator/email_validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  var email = TextEditingController();
  var name = TextEditingController();
  var password = TextEditingController();
  var phone = TextEditingController();
  var buttonState = ButtonState.idle;

  bool showLoading = false;
  bool hideText = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: const Text(
                            'Register',
                            textScaleFactor: 1.5,
                            style: TextStyle(
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 250,
                        child: TextFormField(
                          controller: email,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              hintText: 'Enter Your Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            } else if (!EmailValidator.validate(value)) {
                              return "Please enter a valid email";
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 250,
                        child: TextFormField(
                          controller: password,
                          obscureText: hideText,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.password),
                            hintText: 'Enter Your Password',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  hideText == false
                                      ? hideText = true
                                      : hideText = false;
                                });
                              },
                              child: hideText == true
                                  ? const Icon(Icons.lock)
                                  : const Icon(Icons.lock_open),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "The field is required";
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ProgressButton.icon(
                              iconedButtons: {
                                ButtonState.idle: IconedButton(
                                    text: "Submit",
                                    icon: const Icon(Icons.save,
                                        color: Colors.white),
                                    color: Colors.deepPurple.shade500),
                                ButtonState.loading: IconedButton(
                                    text: "Loading",
                                    color: Colors.deepPurple.shade700),
                                ButtonState.fail: IconedButton(
                                    text: "Failed",
                                    icon: const Icon(Icons.cancel,
                                        color: Colors.white),
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
                                  setState(() {
                                    buttonState = ButtonState.loading;
                                  });
                                  FirebaseServices()
                                      .signUp(
                                          email.text, password.text, phone.text)
                                      .then((value) {
                                    if (value == true) {
                                      FirebaseServices()
                                          .login(
                                        email.text,
                                        password.text,
                                      )
                                          .then((value) {
                                        if (value == true) {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ProfilePage()),
                                              (route) => false);
                                        } else {
                                          final snackBar = SnackBar(
                                            duration:
                                                const Duration(seconds: 2),
                                            content: const Text(
                                                'Something Went Wrong!'),
                                            action: SnackBarAction(
                                              label: 'Close',
                                              onPressed: () {
                                                ScaffoldMessenger.of(context)
                                                    .hideCurrentSnackBar();
                                              },
                                            ),
                                          );

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      });
                                    } else {
                                      setState(() {
                                        buttonState = ButtonState.idle;
                                      });
                                      final snackBar = SnackBar(
                                        duration: const Duration(seconds: 2),
                                        content:
                                            const Text('Something Went Wrong!'),
                                        action: SnackBarAction(
                                          label: 'Close',
                                          onPressed: () {
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                          },
                                        ),
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  });
                                } else {
                                  buttonState = ButtonState.idle;
                                }
                              },
                              state: buttonState),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Already have an account? '),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                );
                              });
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

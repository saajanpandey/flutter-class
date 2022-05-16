import 'package:flutter/material.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
import 'package:my_test_app/screen/auth/phone.dart';
import 'package:my_test_app/screen/homepage.dart';
import 'package:my_test_app/service/firebaseservice.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:my_test_app/screen/auth/registerpage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  var email = TextEditingController();
  var password = TextEditingController();
  var buttonState = ButtonState.idle;
  bool hideText = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 30),
              color: Colors.transparent,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller: email,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.mail),
                          border: OutlineInputBorder(),
                          hintText: 'Email Address',
                        ),
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
                      height: 10,
                    ),
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        obscureText: hideText,
                        controller: password,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.password),
                          border: const OutlineInputBorder(),
                          hintText: 'Password',
                          suffixIcon: GestureDetector(
                            onTap: (() {
                              setState(() {
                                hideText == true
                                    ? hideText = false
                                    : hideText = true;
                              });
                            }),
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
                      height: 10,
                    ),
                    SizedBox(
                      width: 100,
                      child: ProgressButton.icon(
                          iconedButtons: {
                            ButtonState.idle: const IconedButton(
                              text: "Login",
                              icon: Icon(Icons.login, color: Colors.white),
                              color: Colors.blue,
                            ),
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
                                  .login(email.text, password.text)
                                  .then((value) {
                                if (value == true) {
                                  setState(() {
                                    buttonState = ButtonState.loading;
                                    setLoginStatus();
                                  });

                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()),
                                      (route) => false);
                                } else {
                                  setState(() {
                                    buttonState = ButtonState.idle;
                                  });
                                  final snackBar = SnackBar(
                                    duration: const Duration(seconds: 4),
                                    content: const Text(
                                        'Please provide correct information !'),
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
                            }
                          },
                          state: buttonState),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Need an Account? '),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RegisterPage()),
                              );
                            });
                          },
                          child: const Text(
                            'SignUp',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhoneSignInPage(),
                            ),
                            (route) => false);
                      },
                      child: const Text('Login With Phone Number.'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100),
                      child: SignInWithGoogle(
                        onPressed: () async {
                          await FirebaseServices()
                              .signInwithGoogle()
                              .then((value) => {
                                    if (value == true)
                                      {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage()),
                                            (route) => false),
                                      }
                                  });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  setLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loginStatus', true);
  }
}

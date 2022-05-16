import 'package:flutter/material.dart';
import 'package:my_test_app/screen/homepage.dart';
import 'package:my_test_app/service/firebaseservice.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  var name = TextEditingController();
  var phone = TextEditingController();
  var dateofbirth = TextEditingController();
  var buttonState = ButtonState.idle;

  final ImagePicker _picker = ImagePicker();
  File? image;

  bool showLoading = false;
  bool hideText = true;
  @override
  void initState() {
    dateofbirth.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Complete Your Profile')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller: name,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: 'Enter Your Full Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "The field is required.";
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
                        keyboardType: TextInputType.number,
                        controller: phone,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            hintText: 'Enter Phone Number'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "The field is required.";
                          } else if (!(value.length == 10)) {
                            return "The phone number should be of 10 digits.";
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
                        readOnly: true,
                        controller: dateofbirth,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.date_range),
                          hintText: 'Enter Date of Birth (A.D)',
                        ),
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100, 12, 31),
                            helpText: 'Select a date',
                          );

                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            setState(() {
                              dateofbirth.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "The field is required.";
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const SizedBox(
                      height: 15,
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
                                  FirebaseServices()
                                      .profile(name.text, phone.text,
                                          dateofbirth.text)
                                      .then((value) {
                                    if (value == true) {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomePage()),
                                          (route) => false);
                                    } else {}
                                  });
                                });
                              } else {
                                setState(() {
                                  buttonState = ButtonState.idle;
                                });
                              }
                            },
                            state: buttonState),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

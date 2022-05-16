import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_test_app/screen/homepage.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  const OtpVerificationPage({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  String verificationCode = '';
  var code = TextEditingController();
  var buttonStatus = ButtonState.idle;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    verifyPhone();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('OTP Verification'),
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
                  controller: code,
                  decoration: const InputDecoration(
                    hintText: 'Enter OTP code',
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    ProgressButton.icon(
                        iconedButtons: {
                          ButtonState.idle: IconedButton(
                              text: "Send",
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
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance
                                .signInWithCredential(
                                    PhoneAuthProvider.credential(
                                        verificationId: verificationCode,
                                        smsCode: code.text))
                                .then((value) async {
                              if (value.user != null) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                    (route) => false);
                              }
                            });
                          } catch (e) {
                            final snackBar = SnackBar(
                              content: const Text('Invalid OTP'),
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
                        },
                        state: buttonStatus),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  verifyPhone() async {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+977${widget.phoneNumber}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          if (value.user != null) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false);
          }
        });
      },
      //     (PhoneAuthCredential authCredential) async {
      //   print("verification completed ${authCredential.smsCode}");
      //   User? user = FirebaseAuth.instance.currentUser;
      //   setState(() {
      //     code.text = authCredential.smsCode!;
      //   });
      //   print(authCredential);
      //   if (authCredential.smsCode != null) {
      //     print(authCredential.smsCode);
      //     try {
      //       UserCredential credential =
      //           await user!.linkWithCredential(authCredential);
      //     } on FirebaseAuthException catch (e) {
      //       if (e.code == 'provider-already-linked') {
      //         await FirebaseAuth.instance.signInWithCredential(authCredential);
      //       }
      //     }
      //     Navigator.pushAndRemoveUntil(
      //         context,
      //         MaterialPageRoute(builder: (context) => HomePage()),
      //         (route) => false);
      //   }
      // },
      verificationFailed: (FirebaseAuthException e) {
        final snackBar = SnackBar(
          content: Text('${e}'),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      codeSent: (String verificationID, int? resendToken) {
        setState(() {
          verificationCode = verificationID;
        });
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        setState(() {
          verificationCode = verificationID;
        });
      },
      timeout: const Duration(seconds: 120),
    );
  }
}

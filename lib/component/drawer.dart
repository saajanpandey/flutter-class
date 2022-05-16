import 'package:flutter/material.dart';
import 'package:my_test_app/screen/auth/loginpage.dart';
import 'package:my_test_app/service/firebaseservice.dart';

class DrawerWidget extends StatefulWidget {
  final String? name;
  const DrawerWidget({Key? key, required this.name}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                color: Colors.blue,
                child: Center(child: Text("Welcome")),
              ),
            ),
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              FirebaseServices().logout().then((value) => {
                    if (value == true)
                      {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                            (route) => false),
                      }
                  });
            },
          )
        ],
      ),
    );
  }
}

// ignore_for_file: avoid_print

import 'package:database_sqflite/helper/data_helper.dart';
import 'package:database_sqflite/home_page.dart';
import 'package:flutter/material.dart';

class MyTextFeild extends StatefulWidget {
  const MyTextFeild({super.key, this.userData});

  final Map<String, Object?>? userData;
  @override
  State<MyTextFeild> createState() => _MyTextFeildState();
}

class _MyTextFeildState extends State<MyTextFeild> {
  late DatabaseHelper db;

  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController emailID = TextEditingController();

  @override
  void initState() {
    db = DatabaseHelper.instance;
    editData();
    super.initState();
  }

  void getDatabase() async {
    await db.database;
  }

  void editData() async {
    if (widget.userData != null) {
      fName.text = widget.userData?['firstName'].toString() ?? '';
      lName.text = widget.userData?['lastName'].toString() ?? '';
      emailID.text = widget.userData?['email'].toString() ?? '';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: fName,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                label: const Text("First Name"),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: lName,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                label: const Text("Last Name"),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailID,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                label: const Text("Email"),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                widget.userData == null
                    ? await db.insertdata(fName.text, lName.text, emailID.text)
                    : await db.updateRecord(
                        fName.text, lName.text, emailID.text,
                        id: "${widget.userData?['id']}");
                // widget.userData = await db.getData();
                // print(value);
                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HomePage(),
                    ),
                    (route) => false);
              },
              child: Text(widget.userData == null ? "Submit" : "Update"),
            ),
          ],
        ),
      ),
    );
  }
}

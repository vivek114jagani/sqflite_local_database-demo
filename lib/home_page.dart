// ignore_for_file: avoid_print

import 'package:database_sqflite/form.dart';
import 'package:database_sqflite/helper/data_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper db = DatabaseHelper.instance;

  List<Map<String, Object?>>? userData = [];

  Future<List<Map<String, Object?>>?> getData() async {
    // await db.deleteTable();
    await db.database;
    userData = await db.getData();
    setState(() {});
    print(userData);
    return null;
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("database in flutter"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyTextFeild(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () async {
              await db.deleteTable();
              await getData();
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: userData == null || userData?.isEmpty == true
          ? const Center(
              child: Text("No Data Found"),
            )
          : ListView.builder(
              itemCount: userData?.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                print("=== ${userData?.length}");
                return ListTile(
                  title: Text(
                      "${userData?[index]["firstName"]} ${userData?[index]["lastName"]}"),
                  subtitle: Text("${userData?[index]["email"]}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MyTextFeild(userData: userData?[index]),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () async {
                          db.deleteRecord("${userData?[index]["id"]}");
                          userData = await db.getData();
                          setState(() {});
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

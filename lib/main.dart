import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lab_firebas/edit_item_screen.dart';

import 'package:flutter_lab_firebas/item_service.dart';
import 'package:flutter_lab_firebas/new_item_screen.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(title: 'Flutter Kritameth'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("items").snapshots(),
        builder: ((context, snapshot) {
          final dataDocuments = snapshot.data?.docs;
          if (dataDocuments == null) return const Text("No data");
          return ListView.builder(
            itemCount: dataDocuments.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(dataDocuments[index]["name"].toString()),
                subtitle: Text(dataDocuments[index]["desc"].toString()),
                onTap: () => _editItemScreen(dataDocuments[index].id,
                    dataDocuments[index]["name"], dataDocuments[index]["desc"]),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewItem,
        tooltip: 'Create New Item',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _createNewItem() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NewItemScreen()));
  }

  _editItemScreen(String documentid, String itemName, String itemDesc) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EditItemScreen(documentid, itemName, itemDesc)));
  }
}

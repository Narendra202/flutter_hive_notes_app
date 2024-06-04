import 'dart:js_interop';
import 'dart:math';
import 'package:crud_app_using_hivedb/boxes/boxes.dart';
import 'package:crud_app_using_hivedb/models/notes_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'boxes/boxes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final  titleController = TextEditingController();
  final  descriptionController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CRUD APP',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),backgroundColor: Colors.blue,centerTitle: true,),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _){
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
              itemCount: box.length,
              itemBuilder:(context, index){
              return Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(data[index].title.toString()),
                      // Text(data[index].description.toString())
                    ],
                  ),
                ),
              );
              }
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showMyDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showMyDialog() async{
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Add Notes'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Enter Title',
                      border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 20,),

                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Enter Description',
                      border: OutlineInputBorder()
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              },
                  child: Text('Cancel')
              ),
              TextButton(onPressed: (){
                final data = NotesModel(title: titleController.text, description: descriptionController.text);
                final box = Boxes.getData();
                // final box = Hive.box<NotesModel>('notes');
                box.add(data);
                data.save();
                titleController.clear();
                descriptionController.clear();
                Navigator.pop(context);
              }, child: Text('Add'))
            ],
          );
        }
    );
  }
}

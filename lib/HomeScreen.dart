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
  late final Box box;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    box = Hive.box<NotesModel>('notes');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CRUD APP',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),backgroundColor: Colors.blue,centerTitle: true,),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, box, _){
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
              // reverse: true,
              // shrinkWrap: true,
              itemCount: box.length,
              itemBuilder:(context, index){
              return Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(data[index].title.toString()),
                          Spacer(),
                          InkWell(
                              onTap: (){
                                delete(data[index]);
                              },
                              child: Icon(Icons.delete,color: Colors.red,)),
                          SizedBox(width: 15,),
                          InkWell(
                              onTap: (){
                                _editDialog(data[index],data[index].title.toString(),data[index].description.toString());
                              },
                              child: Icon(Icons.edit))

                        ],
                      ),
                      Text(data[index].description.toString())
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

  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }

  Future<void> _editDialog(NotesModel notesModel, String title, String description) async{

    titleController.text = title;
    descriptionController.text = description;
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Edit Notes'),
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
              TextButton(onPressed: () async{

                notesModel.title = titleController.text.toString();
                notesModel.description = descriptionController.text.toString();

                notesModel.save();
                titleController.clear();
                descriptionController.clear();
                Navigator.pop(context);
              }, child: Text('Edit'))
            ],
          );
        }
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
                // final box = Boxes.getData();
                // final box = Hive.box<NotesModel>('notes');
                box.add(data);
                // data.save();
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


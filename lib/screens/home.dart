import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_flutter/main.dart';
import 'package:google_sign_in_flutter/models/negara.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../item.dart';
import '../models/todo.dart';
import 'package:http/http.dart' as http;

List<String> listbutton = <String>['Select'];

class Home extends StatefulWidget {

  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class _HomeState extends State<Home> {
  GoogleSignInAccount? _currentUser;
  //final _myBox = Hive.box('mybox');
  final list = ToDo.todoList();
  final _todoController = TextEditingController();
  List<ToDo> _foundToDo = [];
  final map = Map<String, dynamic>();
  final Box box = Hive.box('mybox');
  String namaEmail = "";
  String nama = "";
  var _valProvince;
  
  List _dataProvince = [];
  @override
  void initState() {
    // TODO: implement initState
    _foundToDo = list;
    namaEmail = box.get('email');
    nama = box.get("nama");
    // if (_myBox.get("TODOLIST") == null) {
    //   list.createInitialData();
    // } else {
    //   // there already exists data
    //   list.loadData();
    // }
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
    super.initState();
    getNegaraData();
  }
  Future getNegaraData() async{
    var response = await http.get(Uri.http('jsonplaceholder.typicode.com', 'users'));
    var jsonData = jsonDecode(response.body);
    List<Negara> negaras = [];
    //_dataProvince = jsonData;
    for(var i in jsonData){
      Negara negara = Negara(name: i['name']);
      _dataProvince.add(negara);
      //print(_dataProvince[i].name.toString());
      //listbutton.add(_dataProvince[i].name.toString());
      
    }
    for(var i = 0; i < _dataProvince.length; i++){
      listbutton.add(_dataProvince[i].name);
    }
    //_dataProvince = jsonData;
    //print(jsonData);
    // print(map);
    //print(listbutton.toString());
    
    print(listbutton.toString());
    print(_dataProvince.runtimeType);
    
    return _dataProvince;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      //appBar: _buildApp(),
      body: Stack(
        //mainAxisAlignment: MainAxisAlignment.end,
        alignment: Alignment.topRight,
        children: [
          Container(
            margin: const EdgeInsets.only(
                    top: 24, right: 130),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              // ignore: prefer_interpolation_to_compose_strings
              child: Text('Welcome, $nama - $namaEmail', style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                          ),
                      ),
                      
                        
            ),
            
          IconButton(
            padding: const EdgeInsets.only(
                    top: 40, right: 40),
            onPressed: () async{
              //_googleSignIn.signOut();
              if(box.get('login') == 'email'){
                print('email');
              } else if(box.get('login') == 'google'){
                print('google');
                _googleSignIn.signOut();
              } else {
                print('facebook');
                await FacebookAuth.instance.logOut();
              }
              box.clear();
              Navigator.pop(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
            }, 
            icon: Icon(Icons.logout),
            alignment: Alignment.bottomRight,
          ),
          SizedBox(height: 10,),
          // Container(
          //    margin: const EdgeInsets.only(
          //           top: 80, right: 200),
          //   // ignore: prefer_const_literals_to_create_immutables
          //     // child: DropdownButton(
          //     //   //hint: const Text("Select Province"),
          //     //   value: _valProvince,
          //     //   items: _dataProvince.map((item) {
          //     //     return DropdownMenuItem(
          //     //       child: Text(item['name'].toString()),
          //     //       value: item['name'].toString(),
          //     //   );
          //     //   }).toList(),
          //     //   onChanged: (item) {
          //     //     setState(() {
          //     //       _valProvince = item;
          //     //     });
          //     //   },
          //     // ),
          //   child: DropdownButtonExample(),
            
          // ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 150),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 15),
                        child: const Text(
                          'To Do List',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      for (ToDo todoo in _foundToDo)
                        itemDart(todo: todoo,
                        onToDoChanged: _handleToDoChange,
                        onDeletedItem: _deleteToDoItem,
                        updateToDo: _updateTodo)
                    ],
                  )
                )
              ],
            )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 20, right: 20, left: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        offset: const Offset(
                          5.0,
                          5.0,
                        ),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ), //BoxShadow
                    ],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
                      hintText: 'Add New ToDo',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey)
                    ),
                  ),
                )
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20, right: 10),
                child: ElevatedButton(
                  onPressed: () {
                    _addItem(_todoController.text);
                    //await _googleSignIn.disconnect();
                    //Navigator.pop(context);
                  },
                  child: const Text('+', style: TextStyle(fontSize: 18),),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red.shade400, elevation: 20, minimumSize: Size(50, 50)
                  ),
                ),
              )
            ],),
          )
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo toDo){
    setState(() {
      //list.isDone = !list.isDone;
      toDo.isDone = !toDo.isDone;
    });
    //list.updateDataBase();
  }

  void _deleteToDoItem(String id) {
    setState(() {
      list.removeWhere((item) => item.id == id);
    });
    //list.updateDataBase();
  }

  void _addItem(String toDo){
    setState(() {
      list.add(ToDo(id: DateTime.now().millisecondsSinceEpoch.toString(), nameTodo: toDo));
      //print(list.toDoList);
    });
    _todoController.clear();
  }

  void search(String search){
    List<ToDo> results = [];
    if (search.isEmpty) {
      results = list;
    } else {
      results = list
          .where((item) => item.nameTodo!
          .toLowerCase()
          .contains(search.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  void _updateTodo(ToDo toDo, String name){
    setState(() {
      //list.nameTodo = name;
      toDo.nameTodo = name;
    });
  }

  Container searchBox() {
    return Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)
            ),
            child: TextField(
              onChanged: (value) => search(value),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
                prefixIcon: Icon(Icons.search, color: Colors.grey, size: 25, ),
                prefixIconConstraints: BoxConstraints(maxHeight: 25, minWidth: 25),
                hintText: 'Search',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey)
              ),
            ),
          );
  }

  AppBar _buildApp() {
    return AppBar(
      elevation: 0,
      title: Container(
        child: Text('To Do List App'),
      ),
    );
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = listbutton.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      iconEnabledColor: Colors.white, //Icon color
      style: TextStyle(  //te
         color: Colors.white, //Font color
         fontSize: 20 //font size on dropdown button
      ),
      dropdownColor: Colors.redAccent,
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: listbutton.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
import 'package:hive_flutter/hive_flutter.dart';
//part 'todo_model.g.dart';


class ToDo{
  String? id;
  String? nameTodo;
  late bool isDone;

  
  //final _myBox = Hive.box('mybox');
  
  ToDo({
    required this.id,
    required this.nameTodo,
    this.isDone = false,
  });

  List toDoList = [];

  // run this method if this is the 1st time ever opening this app
  // void createInitialData() {
  //   toDoList = [
  //     //ToDo(id: 'id', nameTodo: 'name')
  //     ["Make Tutorial", zfalse],
  //     ["Do Exercise", false],
  //   ];
  // }

  // load the data from database
  // void loadData() {
  //   toDoList = _myBox.get("TODOLIST");
  // }

  // // update the database
  // void updateDataBase() {
  //   _myBox.put("TODOLIST", toDoList);
  // }

  // void searchToDo(String search){
  //   toDoList = _myBox.get("TODOLIST").where((item) => item.nameTodo!
  //         .toLowerCase()
  //         .contains(search.toLowerCase()))
  //         .toList();
  // }

  static List<ToDo> todoList(){
    return[
      ToDo(id: '1', nameTodo: 'Todo 1'),
      ToDo(id: '2', nameTodo: 'Todo 2', isDone: true),
      ToDo(id: '3', nameTodo: 'Todo 3')
    ];
  }
}
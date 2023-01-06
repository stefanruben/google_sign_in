import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel extends HiveObject{
 @HiveField(0)
  String? id;
  @HiveField(1)
  String? nameTodo;
  @HiveField(2)
  bool isDone;

  
  final _myBox = Hive.box('mybox');
  
  TodoModel({
    required this.id,
    required this.nameTodo,
    this.isDone = false,
  });

  List<TodoModel> toDoList = [];

  // run this method if this is the 1st time ever opening this app
  void createInitialData() {
    toDoList = [
      TodoModel(id: 'id', nameTodo: 'name')
      // ["Make Tutorial", false],
      // ["Do Exercise", false],
    ];
  }

  // load the data from database
  void loadData() {
    toDoList = _myBox.get("TODOLIST");
  }

  // update the database
  void updateDataBase() {
    _myBox.put("TODOLIST", toDoList);
  }

  void searchToDo(String search){
    toDoList = _myBox.get("TODOLIST").where((item) => item.nameTodo!
          .toLowerCase()
          .contains(search.toLowerCase()))
          .toList();
  }

  // static List<ToDo> toDoList(){
  //   return[
  //     ToDo(id: '1', nameTodo: 'Todo 1'),
  //     ToDo(id: '2', nameTodo: 'Todo 2', isDone: true),
  //     ToDo(id: '3', nameTodo: 'Todo 3')
  //   ];
  // }
}
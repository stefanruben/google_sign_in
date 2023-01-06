import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/todo.dart';

class itemDart extends StatelessWidget {
  final ToDo todo;
  final onToDoChanged;
  final onDeletedItem;
  final updateToDo;
  final _todoController = TextEditingController();
  itemDart({super.key, required this.todo, required this.onToDoChanged, required this.onDeletedItem, required this.updateToDo});


  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: StretchMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.green,
            icon: Icons.edit,
            label: "Update",
            //onPressed: (context) => updateToDo(todo)
            onPressed: ((context) {
              var controller;
              showDialog(
                context: context, 
                builder: (context) => AlertDialog(
                  title: Text('Update'),
                  content: TextField(
                    decoration: InputDecoration(hintText: 'Enter ToDo'),
                    controller: _todoController,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(updateToDo(todo, _todoController.text));
                      },
                      child: Text('Submit')
                      )
                  ],
                )
              );
            }),
          ),
          SlidableAction(
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: "Delete",
            onPressed: (context) => onDeletedItem(todo.id)
          )
        ],
      ),
      child: 
      ListTile(
        onTap: () {
          print("click");
          onToDoChanged(todo);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        tileColor: Colors.white,
        leading: Icon(todo.isDone? Icons.check_box: Icons.check_box_outline_blank, color: Colors.blue.shade700),
        title: Text(
          todo.nameTodo!,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        // trailing: IconButton(
        //   onPressed: (() {
        //     print("delete");
        //     onDeletedItem(todo.id);
        //   }),
        //   icon: const Icon(Icons.delete),
        // ),
    ));
  }
}
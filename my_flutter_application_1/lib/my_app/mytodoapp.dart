import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_flutter_application_1/my_app/add_task_screen.dart';
import 'package:my_flutter_application_1/my_app/models/task.dart';
import 'package:my_flutter_application_1/my_app/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});
  
  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  TextEditingController searchController = TextEditingController();
  List<Task> tasks = [];
  List<Task> filteredTasks = [];
  late SharedPref sharedPref;

  @override
  void initState() {
    super.initState();
    filteredTasks = tasks;
    sharedPref = SharedPref();
    saveArray();
    loadArray();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: onAddButtonTap,
        child: const Icon(Icons.add), // Plus sign
         
      ),
      
      body: Column(
        children: [
          
          Container(
            
            height: 50,
            
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                hintText: 'Search',
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: _searchTask,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                var task = filteredTasks[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: task.isDue ? Colors.red : Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.task,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Due: ${task.dueDate.year}-${task.dueDate.month}-${task.dueDate.day}",
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.white,),
                        onPressed: () async{
                          // List<Task> task= await storeTasks();
                          var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskScreen(message: "", task: task,)));
                          if(result!=null){
                            setState(() {
                              tasks[index]=result;
                               filteredTasks = tasks;
                            });
                          saveArray();
                            //  print(storeTasks());
                          }

                        },)
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _searchTask(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredTasks = tasks;
      } else {
        filteredTasks = tasks
            .where((task) => task.task.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void onAddButtonTap() async{
    Task? result = await Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddTaskScreen(message: "", task: null))); 
    if (result != null) {


      Map newTaskJson = result.toJson();

      String encodedTask = jsonEncode(newTaskJson);
  
    Map<String , dynamic>  newDecodedTask = jsonDecode(encodedTask);
      Task newTask = Task.fromJson(newDecodedTask);

      setState(() {
        tasks.add(newTask); 
        filteredTasks = tasks; 
        saveArray();
        ///call a function to store in shared pref
      });
      //  storeTasks();
  }
}
//////////////////////////////////

Future<void> saveArray() async {
  List<String> a = [];
  for (Task y in tasks) {

    Map taskMap = y.toJson();
    String encodedTask = jsonEncode(taskMap);

    a.add(encodedTask);
  }
  await sharedPref.saveTasks('tasks', a);
}


Future<void> loadArray() async {
  List<String>? b = await sharedPref.getTasks('tasks');
  if (b != null) {
    List<Task> loadedTasks = [];
    for (String z in b) {
      Map<String, dynamic> decodedTask = jsonDecode(z);
      Task task = Task.fromJson(decodedTask);
      loadedTasks.add(task);
      setState(() {
      tasks = loadedTasks;
      filteredTasks = loadedTasks;
    });
    }
    
  }
}

// Future<List<Task>> storeTasks() async{
// List<Task> taskStrings = tasks.map((task) {
//     return task;
// }).toList();
// return taskStrings;


// }


///create a function that will store to shared pref
///transform the tasks list to list of strings by using .map
///call SharePref.saveTask ..... 
///
///
///in initstate , get the list from shared pref, 
///transform the list to list of Task using .map 

}








// // border: OutlineInputBorder(),
//                           // ),
//                           // onTap: () async {
//                           //   await _selectDate();
//                           // },

//   void _searchTask(String query) {
//     setState(() {
//       if (query.isEmpty) {
//   filteredTasks = tasks; 
//     } else {
//        filteredTasks = tasks.where((task)=> task.task.toLowerCase().contains(query.toLowerCase())
//        ).toList();
//     }
//     });
//   }
// }
  // void onAddButtonTap() async{
  //   var result = await Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddTaskScreen(message: ""))); // second screen and wait
  //   if (result != null) {
  //     setState(() {
  //       tasks.add(result); 
  //       filteredTasks = tasks; 
  //     });
import 'package:flutter/material.dart';
import 'package:my_flutter_application_1/my_app/models/task.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key, required this.message, required this.task});
  final String message;
  final Task? task;

  // check check check
  // check check check
  // check check check

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController taskController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

@override
  void initState() {
  if(widget.task != null) {
    
      taskController.text = widget.task!.task;
      selectedDate = widget.task!.dueDate;
      dateController.text = "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
    
    // print(widget.task!.toJson().toString());
    }
        super.initState();

        // fillData(); 
 
  }
    // fillData()  {
    // if (widget.message == "" && widget.task != null) {
    //   taskController.text = widget.task!.task;
    //   selectedDate = widget.task!.dueDate;
    //   dateController.text = "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
    // } 
    //   }
      



  @override
  Widget build(BuildContext context) {
    double sh = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              color: Colors.black,
              height: sh * 0.08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                SizedBox(width: 8),
                Text('New Task',
                    style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    color: Colors.white),
                  ),],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(

                    controller: taskController,

                    decoration: const InputDecoration(
                      labelText: 'Task Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
         
         const SizedBox(height: 16),
                  TextField(

                    controller: dateController,

                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Due Date',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    onTap: _selectDate,
                  ),
                  
                ],
              ),
            ),
            Center(
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Close"),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _saveTask,
                    // String = taskController, dateController,
                    child: const Text("Save"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  void _saveTask() {
    if (taskController.text.isNotEmpty) {

      Task newTask = Task.fromJson({
                  'task': taskController.text,
                  'dueDate': selectedDate.millisecondsSinceEpoch,
                  'isDue': selectedDate.isBefore(DateTime.now()),
                });

      Navigator.pop(context, newTask);
    }
  }
}

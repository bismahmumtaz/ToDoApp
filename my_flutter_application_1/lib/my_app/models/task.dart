class Task {
    Task({
        required this.task,
        required this.dueDate,
        required this.isDue,
    });

    final String task;
    final DateTime dueDate;
    final bool isDue;

    factory Task.fromJson(Map<String, dynamic> json){ 
        return Task(
            task: json["task"] ?? "",
            dueDate: DateTime.fromMillisecondsSinceEpoch(json["dueDate"]) ?? DateTime.now(),
            isDue: json["isDue"] ?? false,
        );
    }

    Map<String, dynamic> toJson() => {
        "task": task,
        "dueDate": dueDate.millisecondsSinceEpoch,
        "isDue": isDue,
    };
    

}

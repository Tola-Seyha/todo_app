class Todo {
  final int? id;
  final String description;
  final int status;

  Todo({this.id, required this.description, this.status = 0});

  Map<String, dynamic> toMap() {
    return {'id': id, 'description': description, 'status': status};
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      description: map['description'],
      status: map['status'],
    );
  }
}

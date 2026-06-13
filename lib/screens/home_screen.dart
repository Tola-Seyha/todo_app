import 'package:flutter/material.dart';

import 'package:todo_app/constants/color_constant.dart';
import 'package:todo_app/db/database_helper.dart';
import 'package:todo_app/model/toto_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
  
 class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _todoCtrl;
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _todoCtrl = TextEditingController();
    _refreshTodos();
  }

  @override
  void dispose() {
    _todoCtrl.dispose();
    super.dispose();
  }

  Future<void> _refreshTodos() async {
    final todos = await DatabaseHelper.instance.getAllTodo();
    setState(() {
      _todos = todos;
    });
  }

  Future<void> _addTodo() async {
    final text = _todoCtrl.text.trim();
    if (text.isEmpty) return;

    await DatabaseHelper.instance.insertData(
      Todo(description: text),
    );

    _todoCtrl.clear();
    await _refreshTodos();
  }

  Future<void> _toggleTodoStatus(Todo todo, bool isDone) async {
    final updatedTodo = Todo(
      id: todo.id,
      description: todo.description,
      status: isDone ? 1 : 0,
    );
    await DatabaseHelper.instance.updateTodo(updatedTodo);
    await _refreshTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "To-do",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: kPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: TextField(
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 14, color: kWhite),
              cursorColor: kPrimary,
              cursorHeight: 20,

              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              decoration: InputDecoration(
                enabled: false,
                filled: true,
                hintStyle: TextStyle(fontSize: 14, color: kOnSecondary),
                hintText: "Search",
                prefixIcon: Icon(Icons.search, size: 26, color: kOnSecondary),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 40,
                  minHeight: 0,
                ),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                fillColor: kSecondary,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final t = _todos[index];
                return ListTile(
                  leading: Checkbox(
                    value: t.status == 1,
                    onChanged: (value) {
                      if (value == null) return;
                      _toggleTodoStatus(t, value);
                    },
                  ),
                  title: Text(
                    t.description,  
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: kWhite),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              backgroundColor: kSecondary,

              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      insetPadding: EdgeInsets.zero,
                      backgroundColor: kNeutral,
                      alignment: Alignment.bottomCenter,
                      iconColor: kWhite,
                      titlePadding: const EdgeInsets.only(
                        left: 6,
                        top: 10,
                        bottom: 0,
                      ),
                      contentPadding: const EdgeInsets.only(
                        top: 5,
                        left: 15,
                        right: 15,
                        bottom: 10,
                      ),
                      title: Row(
                        children: [
                          IconButton(
                            onPressed: (){
                               Navigator.of(context).pop();
                               setState(() {
                                 _todoCtrl.clear();
                               });
                            },
                            icon: Icon(Icons.close, size: 25, color: kWhite),
                          ),
                          Text(
                            "New To-do",
                            style: TextStyle(fontSize: 20, color: kWhite),
                          ),
                        ],
                      ),

                      content: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _todoCtrl,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              maxLines: 5,
                              minLines: 1,
                              cursorColor: kPrimary,
                              style: TextStyle(fontSize: 14, color: kWhite),
                              autofocus: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: kOnNeutral,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [ 
                        SizedBox(
                          width: 100,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: kOnNeutral,
                            ),
                            onPressed: ()   {
                                _addTodo();
                              Navigator.of(context).pop(); 
                            },
                            child: Text(
                              "Save",
                              style: _todoCtrl.text.trim().isNotEmpty ? TextStyle(fontSize: 16, color: kPrimary) : TextStyle(fontSize: 16, color: Color.fromARGB(255, 243, 210, 49)),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ); 
              },
              child: Icon(Icons.add, size: 24, color: kPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

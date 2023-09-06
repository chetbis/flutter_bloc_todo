import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_todo/components/text_field.dart';
import 'package:flutter_bloc_todo/model/todo.dart';
import 'package:flutter_bloc_todo/todo_bloc/todo_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void addTodo(Todo todo) {
    context.read<TodoBloc>().add(AddTodo(todo));
  }

  void removeTodo(Todo todo) {
    context.read<TodoBloc>().add(RemoveTodo(todo));
  }

  void alterTodo(int index) {
    context.read<TodoBloc>().add(AlterTodo(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        title: Text(
          'My Todo App',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              TextEditingController controller_1 = TextEditingController();
              TextEditingController controller_2 = TextEditingController();

              return AlertDialog(
                title: const Text('Add a task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TodoTextField(
                      controller: controller_1,
                      placeHolder: 'Task Title...',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TodoTextField(
                      controller: controller_2,
                      placeHolder: 'Task Description...',
                    )
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 15,
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        foregroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: () {
                        addTodo(
                          Todo(
                            subTitle: controller_2.text,
                            title: controller_1.text,
                          ),
                        );

                        controller_2.text = '';
                        controller_1.text = '';

                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        height: 35,
                        width: MediaQuery.of(context).size.width,
                        child: const Icon(
                          CupertinoIcons.check_mark,
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          CupertinoIcons.add,
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state.status == TodoStatus.success) {
              return ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Theme.of(context).colorScheme.primary,
                    elevation: 0,
                    child: Slidable(
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) {
                              removeTodo(state.todos[index]);
                            },
                            label: 'Delete',
                            icon: Icons.delete,
                            backgroundColor: const Color(0xFFFE4A49),
                          )
                        ],
                      ),
                      key: const ValueKey(0),
                      child: ListTile(
                        title: Text(
                          state.todos[index].title,
                        ),
                        subtitle: Text(
                          state.todos[index].subTitle,
                        ),
                        trailing: Checkbox(
                          value: state.todos[index].isDone,
                          activeColor: Theme.of(context).colorScheme.secondary,
                          onChanged: (value) {
                            alterTodo(index);
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state.status == TodoStatus.initial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

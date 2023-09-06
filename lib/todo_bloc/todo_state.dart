part of 'todo_bloc.dart';

enum TodoStatus {
  initial,
  loading,
  success,
  error,
}

class TodoState extends Equatable {
  final List<Todo> todos;
  final TodoStatus status;

  const TodoState({
    this.todos = const <Todo>[],
    this.status = TodoStatus.initial,
  });

  TodoState copyWith({
    List<Todo>? todos,
    TodoStatus? status,
  }) {
    return TodoState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todos': todos,
      'status': status.name,
    };
  }

  factory TodoState.fromJson(Map<String, dynamic> json) {
    final List<Todo> fromJsonTodos =
        (json['todos'] as List<Map<String, dynamic>>)
            .map((e) => Todo.fromJson(e))
            .toList();

    final TodoStatus fromJsonStatus = TodoStatus.values
        .firstWhere((element) => element.name == json['status']);

    return TodoState(
      todos: fromJsonTodos,
      status: fromJsonStatus,
    );
  }

  @override
  List<Object> get props => [todos, status];
}

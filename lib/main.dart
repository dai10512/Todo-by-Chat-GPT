import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

// Model
@immutable
class Todo {
  const Todo({
    required this.id,
    required this.description,
  });

  final String id;
  final String description;

  Todo copyWith({
    String? id,
    String? description,
  }) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
    );
  }
}

// ViewModel
class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier() : super([]);

  // Todo の追加
  void addTodo(String description) {
    var uuid = const Uuid();
    final todo = Todo(
      id: uuid.v4(),
      description: description,
    );
    state = [...state, todo];
  }

  void removeTodo(int index) {
    final tmpList = [...state];
    tmpList.removeAt(index);
    state = tmpList;
  }
}

final todosProvider =
    StateNotifierProvider<TodosNotifier, List<Todo>>((ref) => TodosNotifier());

//runApp
void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

//View
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'TODO App',
      home: TodoList(),
    );
  }
}

class TodoList extends ConsumerWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    final todos = ref.watch(todosProvider);
    final textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(todos[index].description),
                  onLongPress: () {
                    ref.read(todosProvider.notifier).removeTodo(index);
                  },
                );
              },
            ),
          ),
          TextField(
            controller: textController,
          ),
          TextButton(
            onPressed: () {
              ref.read(todosProvider.notifier).addTodo(textController.text);
              textController.clear();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

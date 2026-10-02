import 'package:flutter/material.dart';

void main() {
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Заметки',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const NotesScreen(),
    );
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _textController = TextEditingController();

  final List<String> _notes = [];

  void _saveNote() {
    final text = _textController.text.trim();

    if (text.isEmpty) {
      return;
    }

    setState(() {
      _notes.add(text);
      _textController.clear();
    });
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  Future<void> _editNote(int index) async {
    final editedText = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController(
          text: _notes[index],
        );

        return AlertDialog(
          title: const Text('Редактировать заметку'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Введите текст заметки',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () {
                final text = controller.text.trim();

                if (text.isNotEmpty) {
                  Navigator.pop(context, text);
                }
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );

    if (editedText == null || editedText.trim().isEmpty) {
      return;
    }

    setState(() {
      _notes[index] = editedText.trim();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заметки'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Введите текст заметки',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            FilledButton(
              onPressed: _saveNote,
              child: const Text('Сохранить'),
            ),

            const SizedBox(height: 20),

            const Text(
              'Мои заметки',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: _notes.isEmpty
                  ? const Center(
                      child: Text('Заметок пока нет'),
                    )
                  : ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.only(
                            bottom: 8,
                          ),
                          child: ListTile(
                            title: Text(_notes[index]),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'Редактировать',
                                  onPressed: () {
                                    _editNote(index);
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  tooltip: 'Удалить',
                                  onPressed: () {
                                    _deleteNote(index);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
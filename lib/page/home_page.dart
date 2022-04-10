import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:simple_memo/utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final titleController = TextEditingController();
  final commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    const storage = FlutterSecureStorage();
    final title = await storage.read(key: titleKey) ?? '';
    final comment = await storage.read(key: commentKey) ?? '';
    setState(() {
      titleController.text = title;
      commentController.text = comment;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Simple Memo',
                style: TextStyle(fontSize: 38.0, fontWeight: FontWeight.w100),
              ),
              ListTile(
                leading: const Icon(Icons.chat),
                tileColor: Colors.white24,
                title: Text(titleController.text),
                subtitle: Text(commentController.text),
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'タイトルを入力してね'),
              ),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(hintText: 'コメントを入力してね'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      const storage = FlutterSecureStorage();
                      await storage.write(
                          key: titleKey, value: titleController.text);
                      await storage.write(
                          key: commentKey, value: commentController.text);
                      final title = await storage.read(key: titleKey) ?? '';
                      final comment = await storage.read(key: commentKey) ?? '';
                      setState(() {
                        titleController.text = title;
                        commentController.text = comment;
                      });
                    },
                    child: const Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      const storage = FlutterSecureStorage();
                      setState(() {
                        titleController.text = '';
                        commentController.text = '';
                        storage.deleteAll();
                      });
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

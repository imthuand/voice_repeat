import 'package:flutter/material.dart';
import 'data/db/app_db.dart';
import 'features/persons/person_select_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDb();
  runApp(VoiceRepeatApp(db: db));
}

class VoiceRepeatApp extends StatelessWidget {
  const VoiceRepeatApp({super.key, required this.db});
  final AppDb db;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PersonSelectScreen(db: db),
    );
  }
}
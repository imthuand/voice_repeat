import 'package:flutter/material.dart';
import '../../data/db/app_db.dart';
import '../../data/repositories/ritual_repo.dart';
import '../voice_buttons/voice_buttons_screen.dart';

class PersonSelectScreen extends StatefulWidget {
  const PersonSelectScreen({super.key, required this.db});
  final AppDb db;

  @override
  State<PersonSelectScreen> createState() => _PersonSelectScreenState();
}

class _PersonSelectScreenState extends State<PersonSelectScreen> {
  String? personId;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    final repo = RitualRepo(widget.db);
    final id = await repo.ensureDefaultPerson();
    await repo.ensureInitialSlots(id, initial: 4);
    setState(() => personId = id);
  }

  @override
  Widget build(BuildContext context) {
    final id = personId;
    if (id == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return VoiceButtonsScreen(db: widget.db, personId: id);
  }
}
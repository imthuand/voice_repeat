import 'dart:async';

import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/constants.dart';
import '../../data/db/app_db.dart';
import '../../data/repositories/alarm_repo.dart';
import '../../data/repositories/ritual_repo.dart';
import '../../infrastructure/audio_service.dart';
import '../../infrastructure/file_storage.dart';
import 'voice_buttons_controller.dart';

class VoiceButtonsScreen extends StatefulWidget {
  const VoiceButtonsScreen({
    super.key,
    required this.db,
    required this.personId,
  });

  final AppDb db;
  final String personId;

  @override
  State<VoiceButtonsScreen> createState() => _VoiceButtonsScreenState();
}

class _VoiceButtonsScreenState extends State<VoiceButtonsScreen> {
  late final RitualRepo repo;
  late final AlarmRepo alarmRepo;
  late final VoiceButtonsController controller;

  int _lastUiMessageId = 0;
  bool _showBottomModeBar = false;
  int _selectedModeIndex = 0;

  @override
  void initState() {
    super.initState();
    repo = RitualRepo(widget.db);
    alarmRepo = AlarmRepo(widget.db);
    controller = VoiceButtonsController(
      repo: repo,
      alarmRepo: alarmRepo,
      audio: AudioService(),
      storage: FileStorage(),
      personId: widget.personId,
    );

    Future.microtask(() async {
      await repo.ensureDefaultPerson();
      await repo.ensureDefaultSleeve(widget.personId);
      await repo.ensureInitialSlots(widget.personId, initial: 4);
      await controller.initializeSleeveSelection();
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _SleeveThemeData _themeForSleeve(Sleeve sleeve) {
    const palettes = <_SleeveThemeData>[
      _SleeveThemeData(
        primary: Color(0xFFFFB86C),
        secondary: Color(0xFFFFE0B2),
        accent: Color(0xFFFF8A3D),
        icon: Icons.wb_sunny_rounded,
      ),
      _SleeveThemeData(
        primary: Color(0xFF7CC7FF),
        secondary: Color(0xFFD7F0FF),
        accent: Color(0xFF2F9BFF),
        icon: Icons.cloud_rounded,
      ),
      _SleeveThemeData(
        primary: Color(0xFFC5A3FF),
        secondary: Color(0xFFEADBFF),
        accent: Color(0xFF8B5DFF),
        icon: Icons.nights_stay_rounded,
      ),
      _SleeveThemeData(
        primary: Color(0xFF7EE3B1),
        secondary: Color(0xFFDDF8EA),
        accent: Color(0xFF29B870),
        icon: Icons.forest_rounded,
      ),
      _SleeveThemeData(
        primary: Color(0xFFFF9FB0),
        secondary: Color(0xFFFFE0E6),
        accent: Color(0xFFFF5B7F),
        icon: Icons.favorite_rounded,
      ),
      _SleeveThemeData(
        primary: Color(0xFFFFD36E),
        secondary: Color(0xFFFFF0C5),
        accent: Color(0xFFFFB300),
        icon: Icons.star_rounded,
      ),
    ];

    final key = '${sleeve.sleeveId}:${sleeve.name}';
    final hash = key.codeUnits.fold<int>(0, (a, b) => a + b);
    return palettes[hash % palettes.length];
  }

  Future<void> _renameDialog(
    BuildContext context,
    String itemId,
    String current,
  ) async {
    final c = TextEditingController(text: current);

    final label = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF16181D),
        title: const Text('Label', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: c,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Zähne putzen',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.45)),
            filled: true,
            fillColor: const Color(0xFF1D2026),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, c.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (label == null) return;

    await repo.rename(
      personId: widget.personId,
      itemId: itemId,
      label: label,
    );
  }

  Future<void> _createSleeveDialog() async {
    final c = TextEditingController();

    final name = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF16181D),
        title: const Text('New sleeve', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: c,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Morning',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.45)),
            filled: true,
            fillColor: const Color(0xFF1D2026),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, c.text.trim()),
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (name == null || name.isEmpty) return;
    await controller.createSleeve(name);
  }

  Future<void> _renameSleeveDialog(Sleeve sleeve) async {
    final c = TextEditingController(text: sleeve.name);

    final name = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF16181D),
        title:
            const Text('Rename sleeve', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: c,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Morning',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.45)),
            filled: true,
            fillColor: const Color(0xFF1D2026),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, c.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (name == null || name.isEmpty) return;
    await controller.renameActiveSleeve(name);
  }

  Future<void> _moveItemDialog(RitualItem item) async {
    final sleeves = await (widget.db.select(widget.db.sleeves)
          ..where((t) => t.personId.equals(widget.personId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.sortOrder),
            (t) => OrderingTerm(expression: t.name),
          ]))
        .get();

    if (!mounted) return;

    final candidates =
        sleeves.where((s) => s.sleeveId != item.sleeveId).toList();

    if (candidates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No other sleeve available.')),
      );
      return;
    }

    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF121418),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Move to sleeve',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              ...candidates.map((sleeve) {
                final theme = _themeForSleeve(sleeve);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () => Navigator.pop(context, sleeve.sleeveId),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.primary.withValues(alpha: 0.20),
                            theme.accent.withValues(alpha: 0.13),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            _ThemeOrb(theme: theme, size: 42),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                sleeve.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.white70,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );

    if (selected == null) return;
    await repo.moveItemToSleeve(
      personId: widget.personId,
      itemId: item.itemId,
      targetSleeveId: selected,
    );
  }

  Future<bool> _confirmDeleteDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF16181D),
        title: const Text(
          'Delete slot permanently',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This removes the slot and its button completely. This action is destructive.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete permanently'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<bool> _confirmDeleteSleeveDialog(Sleeve sleeve) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF16181D),
        title:
            const Text('Delete sleeve', style: TextStyle(color: Colors.white)),
        content: Text(
          'Delete sleeve "${sleeve.name}"? This is only allowed when all items in the sleeve are empty.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete sleeve'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<void> _runIntegrityMenuAction(String action) async {
    if (action == 'check') {
      await controller.runIntegrityCheck();
      return;
    }

    if (action == 'repairRecorded') {
      await controller.runIntegrityCheckRepairRecorded();
      return;
    }

    if (action == 'repairAll') {
      await controller.runIntegrityCheckRepairAll();
      return;
    }
  }

  Future<void> _showAlarmEditor({
    required RitualItem item,
    RitualSchedule? existing,
  }) async {
    var enabled = existing?.enabled ?? true;
    var hour = existing?.hour ?? 7;
    var minute = existing?.minute ?? 30;
    var selectedDays = <int>{
      ...AlarmWeekday.ordered.where(
        (d) => AlarmWeekday.contains(existing?.weekdayMask ?? 0, d),
      ),
    };

    if (selectedDays.isEmpty) {
      selectedDays = {
        AlarmWeekday.monday,
        AlarmWeekday.tuesday,
        AlarmWeekday.wednesday,
        AlarmWeekday.thursday,
        AlarmWeekday.friday,
      };
    }

    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF121418),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final label =
                item.label.isEmpty ? 'Voice ${item.slotIndex + 1}' : item.label;

            Future<void> pickTime() async {
              final now = TimeOfDay(hour: hour, minute: minute);
              final picked = await showTimePicker(
                context: context,
                initialTime: now,
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.dark(),
                    ),
                    child: child!,
                  );
                },
              );

              if (picked == null) return;

              setModalState(() {
                hour = picked.hour;
                minute = picked.minute;
              });
            }

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  18,
                  12,
                  18,
                  22 + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 42,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.alarm_rounded,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Alarm',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                label,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.70),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: enabled,
                          onChanged: (value) {
                            setModalState(() => enabled = value);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _AlarmTimeCard(
                      timeText: alarmRepo.formatTime(hour, minute),
                      onTap: pickTime,
                    ),
                    const SizedBox(height: 14),
                    _AlarmPresetRow(
                      currentMask: AlarmWeekday.maskOf(selectedDays),
                      onDaily: () {
                        setModalState(() {
                          selectedDays = {...AlarmWeekday.ordered};
                        });
                      },
                      onWeekdays: () {
                        setModalState(() {
                          selectedDays = {
                            AlarmWeekday.monday,
                            AlarmWeekday.tuesday,
                            AlarmWeekday.wednesday,
                            AlarmWeekday.thursday,
                            AlarmWeekday.friday,
                          };
                        });
                      },
                      onWeekend: () {
                        setModalState(() {
                          selectedDays = {
                            AlarmWeekday.saturday,
                            AlarmWeekday.sunday,
                          };
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AlarmWeekday.ordered.map((day) {
                        final active = selectedDays.contains(day);
                        return FilterChip(
                          selected: active,
                          onSelected: (value) {
                            setModalState(() {
                              if (value) {
                                selectedDays.add(day);
                              } else if (selectedDays.length > 1) {
                                selectedDays.remove(day);
                              }
                            });
                          },
                          label: Text(
                            AlarmWeekday.weekdayShortLabels[day] ?? '?',
                          ),
                          selectedColor: Colors.white,
                          backgroundColor: Colors.white.withValues(alpha: 0.06),
                          labelStyle: TextStyle(
                            color: active ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          checkmarkColor: Colors.black,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),
                    if (existing != null)
                      _ActionSheetButton(
                        icon: Icons.delete_outline,
                        label: 'Remove alarm',
                        isDestructive: true,
                        onTap: () => Navigator.pop(context, 'delete'),
                      ),
                    if (existing != null) const SizedBox(height: 10),
                    _ActionSheetButton(
                      icon: Icons.save_outlined,
                      label: 'Save alarm',
                      onTap: () => Navigator.pop(context, 'save'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result == 'delete') {
      await controller.deleteAlarmSchedule(item.itemId);
      return;
    }

    if (result == 'save') {
      await controller.saveAlarmSchedule(
        itemId: item.itemId,
        label: item.label,
        enabled: enabled,
        hour: hour,
        minute: minute,
        weekdayMask: AlarmWeekday.maskOf(selectedDays),
      );
    }
  }

  Future<void> _showTileActionSheet({
    required RitualItem item,
    required bool isEmpty,
    required RitualSchedule? schedule,
    required Future<void> Function() onRename,
    required Future<void> Function() onMove,
    required Future<void> Function() onArchive,
    required Future<void> Function() onDelete,
  }) async {
    if (!mounted) return;

    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF121418),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  item.label.isEmpty ? 'Voice actions' : item.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 14),
              _ActionSheetButton(
                icon: Icons.alarm_rounded,
                label: schedule == null ? 'Add alarm' : 'Edit alarm',
                onTap: () => Navigator.pop(context, 'alarm'),
              ),
              const SizedBox(height: 10),
              _ActionSheetButton(
                icon: Icons.edit_outlined,
                label: 'Rename',
                onTap: () => Navigator.pop(context, 'rename'),
              ),
              const SizedBox(height: 10),
              _ActionSheetButton(
                icon: Icons.drive_file_move_outline,
                label: 'Move to sleeve',
                onTap: () => Navigator.pop(context, 'move'),
              ),
              const SizedBox(height: 10),
              _ActionSheetButton(
                icon: Icons.archive_outlined,
                label: 'Archive',
                enabled: !isEmpty && item.activePath != null,
                onTap: () => Navigator.pop(context, 'archive'),
              ),
              const SizedBox(height: 10),
              _ActionSheetButton(
                icon: Icons.delete_outline,
                label: 'Delete permanently',
                isDestructive: true,
                onTap: () => Navigator.pop(context, 'delete'),
              ),
            ],
          ),
        ),
      ),
    );

    if (action == 'alarm') {
      await _showAlarmEditor(item: item, existing: schedule);
    }
    if (action == 'rename') await onRename();
    if (action == 'move') await onMove();
    if (action == 'archive') await onArchive();
    if (action == 'delete') await onDelete();
  }

  Future<void> _showSleeveActionSheet(Sleeve sleeve) async {
    if (sleeve.sleeveId == SleeveDefaults.defaultId) return;

    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF121418),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  sleeve.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _ActionSheetButton(
                icon: Icons.edit_outlined,
                label: 'Rename sleeve',
                onTap: () => Navigator.pop(context, 'rename'),
              ),
              const SizedBox(height: 10),
              _ActionSheetButton(
                icon: Icons.delete_outline,
                label: 'Delete sleeve',
                isDestructive: true,
                onTap: () => Navigator.pop(context, 'delete'),
              ),
            ],
          ),
        ),
      ),
    );

    if (action == 'rename') {
      await _renameSleeveDialog(sleeve);
      return;
    }

    if (action == 'delete') {
      final confirmed = await _confirmDeleteSleeveDialog(sleeve);
      if (!confirmed) return;
      await controller.deleteActiveSleeve();
    }
  }

  Future<void> _openSleevePicker(List<Sleeve> sleeves) async {
    final activeId = controller.activeSleeveId;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF121418),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Choose sleeve',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: () async {
                        Navigator.pop(sheetContext);
                        await _createSleeveDialog();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('New'),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: sleeves.map((sleeve) {
                      final theme = _themeForSleeve(sleeve);
                      final selected = sleeve.sleeveId == activeId;
                      final canEdit =
                          sleeve.sleeveId != SleeveDefaults.defaultId;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () async {
                            Navigator.pop(sheetContext);
                            await controller.setActiveSleeve(sleeve.sleeveId);
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  theme.primary.withValues(
                                    alpha: selected ? 0.24 : 0.13,
                                  ),
                                  theme.accent.withValues(
                                    alpha: selected ? 0.16 : 0.08,
                                  ),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: selected
                                    ? Colors.white.withValues(alpha: 0.18)
                                    : Colors.white.withValues(alpha: 0.06),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.accent.withValues(
                                    alpha: selected ? 0.10 : 0.04,
                                  ),
                                  blurRadius: 16,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  _ThemeOrb(theme: theme, size: 46),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          sleeve.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          sleeve.sleeveId ==
                                                  SleeveDefaults.defaultId
                                              ? 'Default sleeve'
                                              : 'Tap to switch',
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.66,
                                            ),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (selected)
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.white,
                                    ),
                                  if (!selected && canEdit)
                                    InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      onTap: () async {
                                        Navigator.pop(sheetContext);
                                        await _showSleeveActionSheet(sleeve);
                                      },
                                      child: Container(
                                        width: 38,
                                        height: 38,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.10,
                                          ),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: const Icon(
                                          Icons.more_horiz_rounded,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _integrityInfoBanner({
    required List<RitualItem> items,
    required String emptyText,
  }) {
    final issueCount = items
        .where((e) => e.integrityStatus != RitualRepo.integrityOk)
        .length;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(18, 16, 18, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: issueCount == 0
            ? const Color(0xFF12151A)
            : const Color(0xFF1A1715),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: issueCount == 0
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.orange.withValues(alpha: 0.20),
        ),
      ),
      child: Row(
        children: [
          Icon(
            issueCount == 0 ? Icons.verified_outlined : Icons.error_outline,
            color: issueCount == 0 ? Colors.white54 : Colors.orangeAccent,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              issueCount == 0
                  ? emptyText
                  : '$issueCount integrity issue${issueCount == 1 ? '' : 's'} detected. Prefer repair over delete where possible.',
              style: TextStyle(
                color: issueCount == 0 ? Colors.white70 : Colors.orangeAccent,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sleeveSelector(List<Sleeve> sleeves) {
    final activeId = controller.activeSleeveId;
    final activeSleeve = sleeves.firstWhere(
      (s) => s.sleeveId == activeId,
      orElse: () => sleeves.isNotEmpty
          ? sleeves.first
          : Sleeve(
              sleeveId: SleeveDefaults.defaultId,
              personId: widget.personId,
              name: SleeveDefaults.defaultName,
              sortOrder: 0,
              createdAt: 0,
              updatedAt: 0,
            ),
    );

    final theme = _themeForSleeve(activeSleeve);
    final accentSoft = theme.primary.withValues(alpha: 0.16);
    final accentStrong = theme.accent.withValues(alpha: 0.12);

    return GestureDetector(
      onTap: () => _openSleevePicker(sleeves),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(18, 18, 18, 0),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              accentSoft,
              accentStrong,
              const Color(0xFF12151A),
            ],
            stops: const [0.0, 0.32, 1.0],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: theme.accent.withValues(alpha: 0.06),
              blurRadius: 18,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            _ThemeOrb(theme: theme, size: 48),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current sleeve',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.58),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activeSleeve.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Tap to switch or manage sleeves',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.66),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.unfold_more_rounded,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomModeReveal() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragUpdate: (details) {
                if (details.delta.dy < -2 && !_showBottomModeBar) {
                  setState(() => _showBottomModeBar = true);
                } else if (details.delta.dy > 2 && _showBottomModeBar) {
                  setState(() => _showBottomModeBar = false);
                }
              },
              onTap: () {
                setState(() => _showBottomModeBar = !_showBottomModeBar);
              },
              child: Column(
                children: [
                  Container(
                    width: 46,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _showBottomModeBar
                        ? 'Hide modes'
                        : (_selectedModeIndex == 0
                            ? 'Show archive'
                            : 'Show active'),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.38),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 180),
              crossFadeState: _showBottomModeBar
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox(height: 0),
              secondChild: Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF12151A),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _ModePill(
                        text: 'Active',
                        selected: _selectedModeIndex == 0,
                        onTap: () {
                          setState(() {
                            _selectedModeIndex = 0;
                            _showBottomModeBar = false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _ModePill(
                        text: 'Archive',
                        selected: _selectedModeIndex == 1,
                        onTap: () {
                          setState(() {
                            _selectedModeIndex = 1;
                            _showBottomModeBar = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0C10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0C10),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Voice Repeat',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Integrity actions',
            onPressed: () => _runIntegrityMenuAction('check'),
            icon: const Icon(Icons.shield_outlined),
          ),
          PopupMenuButton<String>(
            color: const Color(0xFF16181D),
            surfaceTintColor: Colors.transparent,
            tooltip: 'More integrity actions',
            icon: const Icon(Icons.more_horiz),
            onSelected: _runIntegrityMenuAction,
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'repairRecorded',
                child: Text(
                  'Check and repair active',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              PopupMenuItem(
                value: 'repairAll',
                child: Text(
                  'Check and repair all',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<List<Sleeve>>(
        stream: repo.watchSleeves(widget.personId),
        builder: (context, sleeveSnap) {
          final sleeves = sleeveSnap.data ?? const <Sleeve>[];

          if (sleeves.isNotEmpty &&
              !sleeves.any((s) => s.sleeveId == controller.activeSleeveId)) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await controller.setActiveSleeve(SleeveDefaults.defaultId);
            });
          }

          return AnimatedBuilder(
            animation: controller,
            builder: (_, __) {
              final msg = controller.uiMessage;
              if (msg != null && msg.id > _lastUiMessageId) {
                _lastUiMessageId = msg.id;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: const Color(0xFF16181D),
                      content: Text(msg.text),
                    ),
                  );
                });
              }

              final currentSleeveId = controller.activeSleeveId;

              return Stack(
                children: [
                  Column(
                    children: [
                      if (sleeves.isNotEmpty) _sleeveSelector(sleeves),
                      Expanded(
                        child: IndexedStack(
                          index: _selectedModeIndex,
                          children: [
                            StreamBuilder<List<RitualItem>>(
                              stream: repo.watchActive(
                                widget.personId,
                                sleeveId: currentSleeveId,
                              ),
                              builder: (context, snap) {
                                final items = snap.data ?? const [];
                                final sleeve = sleeves.firstWhere(
                                  (s) => s.sleeveId == currentSleeveId,
                                  orElse: () => sleeves.isNotEmpty
                                      ? sleeves.first
                                      : Sleeve(
                                          sleeveId: SleeveDefaults.defaultId,
                                          personId: widget.personId,
                                          name: SleeveDefaults.defaultName,
                                          sortOrder: 0,
                                          createdAt: 0,
                                          updatedAt: 0,
                                        ),
                                );
                                return _gridActive(context, items, sleeve);
                              },
                            ),
                            StreamBuilder<List<RitualItem>>(
                              stream: repo.watchArchived(
                                widget.personId,
                                sleeveId: currentSleeveId,
                              ),
                              builder: (context, snap) {
                                final items = snap.data ?? const [];
                                return _listArchive(context, items);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _bottomModeReveal(),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _gridActive(
    BuildContext context,
    List<RitualItem> items,
    Sleeve sleeve,
  ) {
    return Column(
      children: [
        _integrityInfoBanner(
          items: items,
          emptyText:
              'Active items in this sleeve are currently in a healthy state.',
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 90),
            child: GridView.builder(
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.97,
              ),
              itemBuilder: (_, i) {
                final it = items[i];
                return StreamBuilder<RitualSchedule?>(
                  stream: alarmRepo.watchScheduleForItem(it.itemId),
                  builder: (context, scheduleSnap) {
                    final schedule = scheduleSnap.data;
                    return _PlayfulVoiceTile(
                      item: it,
                      displayIndex: i + 1,
                      sleeveTheme: _themeForSleeve(sleeve),
                      scheduleSummary: schedule == null
                          ? null
                          : alarmRepo.describeSchedule(schedule),
                      hasAlarm: schedule != null,
                      alarmEnabled: schedule?.enabled ?? false,
                      isRecording: controller.recordingItemId == it.itemId,
                      isPlaying: controller.playingItemId == it.itemId,
                      onIntegrityTap: () {},
                      onAlarmTap: () async {
                        await _showAlarmEditor(
                          item: it,
                          existing: schedule,
                        );
                      },
                      onOpenActions: () async {
                        final isEmpty = it.state == ItemState.empty;
                        await _showTileActionSheet(
                          item: it,
                          isEmpty: isEmpty,
                          schedule: schedule,
                          onRename: () async {
                            await _renameDialog(context, it.itemId, it.label);
                          },
                          onMove: () async {
                            await _moveItemDialog(it);
                          },
                          onArchive: () async {
                            final path = it.activePath;
                            if (path == null) return;
                            await controller.archive(it.itemId, path);
                          },
                          onDelete: () async {
                            final confirmed = await _confirmDeleteDialog();
                            if (!confirmed) return;
                            await controller.deleteActive(
                              it.itemId,
                              activePath: it.activePath,
                            );
                          },
                        );
                      },
                      onHoldStart: () => controller.startHold(it.itemId),
                      onHoldEnd: () => controller.stopHold(it.itemId),
                      onTap: () async {
                        final path = it.activePath;
                        if (path == null) return;

                        final didPlay = await controller.togglePlay(
                          it.itemId,
                          path,
                        );
                        if (didPlay) {
                          await repo.markPlayed(
                            personId: widget.personId,
                            itemId: it.itemId,
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _listArchive(BuildContext context, List<RitualItem> items) {
    return Column(
      children: [
        _integrityInfoBanner(
          items: items,
          emptyText:
              'Archived items in this sleeve are currently in a healthy state.',
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 90),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final it = items[i];
              return Dismissible(
                key: ValueKey('arch_${it.itemId}'),
                background: _swipeBg(
                  'RESTORE',
                  Icons.unarchive_outlined,
                  left: true,
                ),
                secondaryBackground: _swipeBg(
                  'DELETE',
                  Icons.delete_outline,
                  left: false,
                ),
                confirmDismiss: (dir) async {
                  if (dir == DismissDirection.startToEnd) {
                    final ap = it.archivedPath;
                    if (ap != null) {
                      await controller.restore(it.itemId, ap);
                    }
                    return false;
                  } else {
                    final confirmed = await _confirmDeleteDialog();
                    if (!confirmed) return false;
                    await controller.deleteArchived(
                      it.itemId,
                      archivedPath: it.archivedPath,
                    );
                    return false;
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF12151A),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    title: Text(
                      it.label.isEmpty ? 'Archived item' : it.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'Used ${it.usageCountTotal} times',
                        style: const TextStyle(color: Colors.white60),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Move',
                          onPressed: () => _moveItemDialog(it),
                          icon: const Icon(
                            Icons.drive_file_move_outline,
                            color: Colors.white70,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final path = it.archivedPath;
                            if (path == null) return;

                            final didPlay =
                                await controller.togglePlay(it.itemId, path);
                            if (didPlay) {
                              await repo.markPlayed(
                                personId: widget.personId,
                                itemId: it.itemId,
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _swipeBg(String text, IconData icon, {required bool left}) {
    return Container(
      alignment: left ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF1C2129),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: left
            ? [
                Icon(icon, color: Colors.white70),
                const SizedBox(width: 10),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ]
            : [
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(icon, color: Colors.white70),
              ],
      ),
    );
  }
}

class _SleeveThemeData {
  const _SleeveThemeData({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.icon,
  });

  final Color primary;
  final Color secondary;
  final Color accent;
  final IconData icon;
}

class _ThemeOrb extends StatelessWidget {
  const _ThemeOrb({
    required this.theme,
    required this.size,
  });

  final _SleeveThemeData theme;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            theme.secondary,
            theme.primary,
            theme.accent,
          ],
          stops: const [0.0, 0.62, 1.0],
        ),
        borderRadius: BorderRadius.circular(size),
        boxShadow: [
          BoxShadow(
            color: theme.accent.withValues(alpha: 0.20),
            blurRadius: 14,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        theme.icon,
        color: Colors.white,
        size: size * 0.44,
      ),
    );
  }
}

class _ModePill extends StatelessWidget {
  const _ModePill({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white70,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ActionSheetButton extends StatelessWidget {
  const _ActionSheetButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.enabled = true,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool enabled;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final fg = !enabled
        ? Colors.white.withValues(alpha: 0.30)
        : isDestructive
            ? Colors.redAccent
            : Colors.white;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: enabled ? onTap : null,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: enabled ? 0.05 : 0.03),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.white.withValues(alpha: enabled ? 0.06 : 0.03),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: enabled ? 0.07 : 0.03),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: fg, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: fg,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlarmTimeCard extends StatelessWidget {
  const _AlarmTimeCard({
    required this.timeText,
    required this.onTap,
  });

  final String timeText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.schedule_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  timeText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Icon(
                Icons.edit_outlined,
                color: Colors.white70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlarmPresetRow extends StatelessWidget {
  const _AlarmPresetRow({
    required this.currentMask,
    required this.onDaily,
    required this.onWeekdays,
    required this.onWeekend,
  });

  final int currentMask;
  final VoidCallback onDaily;
  final VoidCallback onWeekdays;
  final VoidCallback onWeekend;

  @override
  Widget build(BuildContext context) {
    final allMask = AlarmWeekday.maskOf(AlarmWeekday.ordered);
    final weekdaysMask = AlarmWeekday.maskOf(const [
      AlarmWeekday.monday,
      AlarmWeekday.tuesday,
      AlarmWeekday.wednesday,
      AlarmWeekday.thursday,
      AlarmWeekday.friday,
    ]);
    final weekendMask = AlarmWeekday.maskOf(const [
      AlarmWeekday.saturday,
      AlarmWeekday.sunday,
    ]);

    return Row(
      children: [
        Expanded(
          child: _PresetChip(
            text: 'Daily',
            selected: currentMask == allMask,
            onTap: onDaily,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _PresetChip(
            text: 'Weekdays',
            selected: currentMask == weekdaysMask,
            onTap: onWeekdays,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _PresetChip(
            text: 'Weekend',
            selected: currentMask == weekendMask,
            onTap: onWeekend,
          ),
        ),
      ],
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: selected
              ? Colors.white
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.black : Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayfulVoiceTile extends StatefulWidget {
  const _PlayfulVoiceTile({
    required this.item,
    required this.displayIndex,
    required this.sleeveTheme,
    required this.hasAlarm,
    required this.alarmEnabled,
    required this.scheduleSummary,
    required this.isRecording,
    required this.isPlaying,
    required this.onIntegrityTap,
    required this.onAlarmTap,
    required this.onOpenActions,
    required this.onHoldStart,
    required this.onHoldEnd,
    required this.onTap,
  });

  final RitualItem item;
  final int displayIndex;
  final _SleeveThemeData sleeveTheme;
  final bool hasAlarm;
  final bool alarmEnabled;
  final String? scheduleSummary;
  final bool isRecording;
  final bool isPlaying;
  final VoidCallback onIntegrityTap;
  final Future<void> Function() onAlarmTap;
  final Future<void> Function() onOpenActions;
  final Future<void> Function() onHoldStart;
  final Future<void> Function() onHoldEnd;
  final Future<void> Function() onTap;

  @override
  State<_PlayfulVoiceTile> createState() => _PlayfulVoiceTileState();
}

class _PlayfulVoiceTileState extends State<_PlayfulVoiceTile> {
  static const holdThreshold = Duration(milliseconds: 220);

  Timer? _timer;
  bool _holdActivated = false;
  bool _pointerDown = false;
  int _pressToken = 0;

  void _reset() {
    _timer?.cancel();
    _timer = null;
    _holdActivated = false;
    _pointerDown = false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final it = widget.item;
    final isEmpty = it.state == ItemState.empty;
    final theme = widget.sleeveTheme;

    final border = widget.isRecording
        ? Colors.redAccent
        : widget.isPlaying
            ? Colors.lightBlueAccent
            : isEmpty
                ? Colors.white.withValues(alpha: 0.10)
                : Colors.white.withValues(alpha: 0.15);

    final shadow = widget.isRecording
        ? Colors.redAccent.withValues(alpha: 0.18)
        : widget.isPlaying
            ? Colors.lightBlueAccent.withValues(alpha: 0.16)
            : theme.accent.withValues(alpha: 0.12);

    final title =
        it.label.isEmpty ? 'Voice ${widget.displayIndex}' : it.label;

    final statusText = widget.isRecording
        ? 'Recording'
        : widget.isPlaying
            ? 'Playing'
            : isEmpty
                ? 'Empty'
                : 'Ready';

    final statusColor = widget.isRecording
        ? Colors.redAccent
        : widget.isPlaying
            ? Colors.lightBlueAccent
            : isEmpty
                ? Colors.white70
                : theme.accent;

    final subtitleText = widget.hasAlarm
        ? widget.scheduleSummary!
        : (isEmpty ? 'Hold to create' : '${it.usageCountTotal} plays');

    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) {
        _pointerDown = true;
        _holdActivated = false;
        _pressToken++;
        final token = _pressToken;

        _timer?.cancel();
        _timer = Timer(holdThreshold, () async {
          if (!_pointerDown) return;
          if (token != _pressToken) return;

          _holdActivated = true;
          HapticFeedback.mediumImpact();
          await widget.onHoldStart();

          if (!_pointerDown || token != _pressToken) {
            await widget.onHoldEnd();
            _reset();
          }
        });
      },
      onPointerUp: (_) async {
        _pointerDown = false;
        _pressToken++;
        _timer?.cancel();

        if (_holdActivated) {
          HapticFeedback.selectionClick();
          await widget.onHoldEnd();
          _reset();
          return;
        }

        await widget.onTap();
        _reset();
      },
      onPointerCancel: (_) async {
        final wasHold = _holdActivated;
        _pointerDown = false;
        _pressToken++;
        _timer?.cancel();

        if (wasHold) {
          await widget.onHoldEnd();
        }

        _reset();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isEmpty
                ? [
                    const Color(0xFF181B21),
                    const Color(0xFF111318),
                  ]
                : [
                    theme.primary.withValues(alpha: 0.82),
                    theme.accent.withValues(alpha: 0.78),
                  ],
          ),
          border: Border.all(color: border, width: 1.4),
          boxShadow: [
            BoxShadow(
              color: shadow,
              blurRadius: 18,
              spreadRadius: 1,
              offset: const Offset(0, 7),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            children: [
              Positioned(
                right: -18,
                top: -12,
                child: _BubbleCloud(
                  color: Colors.white.withValues(alpha: isEmpty ? 0.03 : 0.08),
                  size: 76,
                ),
              ),
              Positioned(
                left: -12,
                bottom: -14,
                child: _BubbleCloud(
                  color: Colors.white.withValues(alpha: isEmpty ? 0.02 : 0.06),
                  size: 58,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _MiniIconBubble(
                          color: isEmpty
                              ? Colors.white.withValues(alpha: 0.10)
                              : Colors.white.withValues(alpha: 0.16),
                          icon: isEmpty
                              ? Icons.mic_none_rounded
                              : widget.isPlaying
                                  ? Icons.graphic_eq_rounded
                                  : Icons.chat_bubble_rounded,
                        ),
                        const Spacer(),
                        InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: widget.onAlarmTap,
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: widget.hasAlarm
                                  ? Colors.white.withValues(alpha: 0.18)
                                  : Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: widget.hasAlarm
                                  ? Border.all(
                                      color: Colors.white.withValues(alpha: 0.18),
                                    )
                                  : null,
                            ),
                            child: Icon(
                              widget.hasAlarm
                                  ? Icons.alarm_rounded
                                  : Icons.alarm_add_rounded,
                              color: widget.hasAlarm
                                  ? (widget.alarmEnabled
                                      ? Colors.white
                                      : Colors.white70)
                                  : Colors.white70,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: widget.onOpenActions,
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(
                                alpha: isEmpty ? 0.08 : 0.14,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.more_horiz_rounded,
                              color: isEmpty ? Colors.white70 : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: isEmpty
                            ? Colors.white.withValues(alpha: 0.10)
                            : Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                        height: 1.05,
                        shadows: isEmpty
                            ? null
                            : [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 8,
                                ),
                              ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitleText,
                      style: TextStyle(
                        color: isEmpty
                            ? Colors.white70
                            : Colors.white.withValues(alpha: 0.84),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniIconBubble extends StatelessWidget {
  const _MiniIconBubble({
    required this.color,
    required this.icon,
  });

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: Colors.white, size: 21),
    );
  }
}

class _BubbleCloud extends StatelessWidget {
  const _BubbleCloud({
    required this.color,
    required this.size,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 0.72,
      child: CustomPaint(
        painter: _BubbleCloudPainter(color: color),
      ),
    );
  }
}

class _BubbleCloudPainter extends CustomPainter {
  _BubbleCloudPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    final r1 = Rect.fromCircle(
      center: Offset(size.width * 0.30, size.height * 0.54),
      radius: size.height * 0.23,
    );
    final r2 = Rect.fromCircle(
      center: Offset(size.width * 0.52, size.height * 0.42),
      radius: size.height * 0.28,
    );
    final r3 = Rect.fromCircle(
      center: Offset(size.width * 0.72, size.height * 0.55),
      radius: size.height * 0.22,
    );
    final r4 = Rect.fromLTWH(
      size.width * 0.20,
      size.height * 0.46,
      size.width * 0.60,
      size.height * 0.26,
    );

    path.addOval(r1);
    path.addOval(r2);
    path.addOval(r3);
    path.addRRect(
      RRect.fromRectAndRadius(r4, Radius.circular(size.height * 0.16)),
    );

    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.08), 6, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BubbleCloudPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
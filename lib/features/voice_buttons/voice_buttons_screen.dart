import 'dart:async';

import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/constants.dart';
import '../../data/db/app_db.dart';
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

class _VoiceButtonsScreenState extends State<VoiceButtonsScreen>
    with SingleTickerProviderStateMixin {
  late final RitualRepo repo;
  late final VoiceButtonsController controller;

  int _lastUiMessageId = 0;
  bool _showBottomModeBar = false;
  int _selectedModeIndex = 0;

  @override
  void initState() {
    super.initState();
    repo = RitualRepo(widget.db);
    controller = VoiceButtonsController(
      repo: repo,
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
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
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ...candidates.map(
                (sleeve) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    sleeve.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.white54,
                  ),
                  onTap: () => Navigator.pop(context, sleeve.sleeveId),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (selected == null) return;
    await controller.moveItemToSleeve(
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

  Future<void> _integrityDialog(BuildContext context, RitualItem it) async {
    final status = it.integrityStatus;
    final title =
        status == RitualRepo.integrityOk ? 'Integrity OK' : 'Integrity issue';

    final details = <String>[];
    details.add('Status: $status');
    details.add('State: ${it.state}');

    if (it.activePath != null && it.activePath!.isNotEmpty) {
      details.add('Active file: ${it.activePath}');
    }

    if (it.archivedPath != null && it.archivedPath!.isNotEmpty) {
      details.add('Archived file: ${it.archivedPath}');
    }

    if (it.integrityCheckedAt != null) {
      details.add(
        'Checked: ${DateTime.fromMillisecondsSinceEpoch(it.integrityCheckedAt!).toLocal()}',
      );
    }

    final canRepairRecorded =
        status != RitualRepo.integrityOk &&
        it.state == RitualRepo.stateRecorded;
    final canRepairArchived =
        status != RitualRepo.integrityOk &&
        it.state == RitualRepo.stateArchived;

    final action = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF16181D),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(
          details.join('\n\n'),
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'check'),
            child: const Text('Run check again'),
          ),
          if (canRepairRecorded)
            TextButton(
              onPressed: () => Navigator.pop(context, 'repairRecorded'),
              child: const Text('Repair active item to empty'),
            ),
          if (canRepairArchived)
            TextButton(
              onPressed: () => Navigator.pop(context, 'repairArchived'),
              child: const Text('Repair archived item to empty'),
            ),
          if (status != RitualRepo.integrityOk)
            TextButton(
              onPressed: () => Navigator.pop(context, 'delete'),
              child: const Text('Delete slot permanently'),
            ),
        ],
      ),
    );

    if (action == 'check') {
      await controller.runIntegrityCheck();
      return;
    }

    if (action == 'repairRecorded') {
      await controller.repairRecordedIssueToEmpty(it.itemId);
      return;
    }

    if (action == 'repairArchived') {
      await controller.repairArchivedIssueToEmpty(it.itemId);
      return;
    }

    if (action == 'delete') {
      final confirmed = await _confirmDeleteDialog();
      if (!confirmed) return;

      if (it.state == RitualRepo.stateArchived) {
        await controller.deleteArchived(
          it.itemId,
          archivedPath: it.archivedPath,
        );
      } else {
        await controller.deleteActive(
          it.itemId,
          activePath: it.activePath,
        );
      }
    }
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

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(18, 18, 18, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF12151A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sleeve',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.45),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: activeSleeve.sleeveId,
                    dropdownColor: const Color(0xFF16181D),
                    isExpanded: true,
                    iconEnabledColor: Colors.white70,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    items: sleeves
                        .map(
                          (sleeve) => DropdownMenuItem<String>(
                            value: sleeve.sleeveId,
                            child: Text(sleeve.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) async {
                      if (value == null) return;
                      await controller.setActiveSleeve(value);
                    },
                  ),
                ),
              ),
              _HeaderIconButton(
                tooltip: 'New sleeve',
                icon: Icons.add,
                onTap: _createSleeveDialog,
              ),
              const SizedBox(width: 8),
              _HeaderIconButton(
                tooltip: 'Rename sleeve',
                icon: Icons.edit_outlined,
                onTap: activeSleeve.sleeveId == SleeveDefaults.defaultId
                    ? null
                    : () => _renameSleeveDialog(activeSleeve),
              ),
              const SizedBox(width: 8),
              _HeaderIconButton(
                tooltip: 'Delete sleeve',
                icon: Icons.delete_outline,
                onTap: activeSleeve.sleeveId == SleeveDefaults.defaultId
                    ? null
                    : () async {
                        final confirmed =
                            await _confirmDeleteSleeveDialog(activeSleeve);
                        if (!confirmed) return;
                        await controller.deleteActiveSleeve();
                      },
              ),
            ],
          ),
        ],
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
    return StreamBuilder<List<Sleeve>>(
      stream: repo.watchSleeves(widget.personId),
      builder: (context, sleeveSnap) {
        final sleeves = sleeveSnap.data ?? const <Sleeve>[];

        if (sleeves.isNotEmpty &&
            !sleeves.any((s) => s.sleeveId == controller.activeSleeveId)) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await controller.setActiveSleeve(SleeveDefaults.defaultId);
          });
        }

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
                tooltip: 'More integrity actions',
                icon: const Icon(Icons.more_horiz),
                onSelected: _runIntegrityMenuAction,
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'repairRecorded',
                    child: Text('Check and repair active'),
                  ),
                  PopupMenuItem(
                    value: 'repairAll',
                    child: Text('Check and repair all'),
                  ),
                ],
              ),
            ],
          ),
          body: AnimatedBuilder(
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
                                return _gridActive(context, items);
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
          ),
        );
      },
    );
  }

  Widget _gridActive(BuildContext context, List<RitualItem> items) {
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
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.98,
              ),
              itemBuilder: (_, i) {
                final it = items[i];
                return _ActiveTile(
                  item: it,
                  displayIndex: i + 1,
                  isRecording: controller.recordingItemId == it.itemId,
                  isPlaying: controller.playingItemId == it.itemId,
                  onIntegrityTap: () => _integrityDialog(context, it),
                  onHoldStart: () => controller.startHold(it.itemId),
                  onHoldEnd: () => controller.stopHold(it.itemId),
                  onTap: () async {
                    final path = it.activePath;
                    if (path == null) return;

                    final didPlay = await controller.togglePlay(it.itemId, path);
                    if (didPlay) {
                      await repo.markPlayed(
                        personId: widget.personId,
                        itemId: it.itemId,
                      );
                    }
                  },
                  onRename: () => _renameDialog(context, it.itemId, it.label),
                  onArchive: () async {
                    final path = it.activePath;
                    if (path == null) return;
                    await controller.archive(it.itemId, path);
                  },
                  onMove: () => _moveItemDialog(it),
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
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        if (it.integrityStatus != RitualRepo.integrityOk)
                          IconButton(
                            tooltip: 'Integrity',
                            onPressed: () => _integrityDialog(context, it),
                            icon: const Icon(
                              Icons.error_outline,
                              color: Colors.orangeAccent,
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

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: enabled
                ? const Color(0xFF1A1E25)
                : const Color(0xFF12151A),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Icon(
            icon,
            size: 18,
            color: enabled ? Colors.white70 : Colors.white24,
          ),
        ),
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

class _ActiveTile extends StatefulWidget {
  const _ActiveTile({
    required this.item,
    required this.displayIndex,
    required this.isRecording,
    required this.isPlaying,
    required this.onIntegrityTap,
    required this.onHoldStart,
    required this.onHoldEnd,
    required this.onTap,
    required this.onRename,
    required this.onArchive,
    required this.onMove,
    required this.onDelete,
  });

  final RitualItem item;
  final int displayIndex;
  final bool isRecording;
  final bool isPlaying;
  final VoidCallback onIntegrityTap;
  final Future<void> Function() onHoldStart;
  final Future<void> Function() onHoldEnd;
  final Future<void> Function() onTap;
  final VoidCallback onRename;
  final Future<void> Function() onArchive;
  final Future<void> Function() onMove;
  final Future<void> Function() onDelete;

  @override
  State<_ActiveTile> createState() => _ActiveTileState();
}

class _ActiveTileState extends State<_ActiveTile> {
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

    final border = widget.isRecording
        ? Colors.redAccent
        : widget.isPlaying
            ? Colors.lightBlueAccent
            : isEmpty
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.white.withValues(alpha: 0.12);

    final glow = widget.isRecording
        ? Colors.redAccent.withValues(alpha: 0.18)
        : widget.isPlaying
            ? Colors.lightBlueAccent.withValues(alpha: 0.15)
            : Colors.transparent;

    final title =
        it.label.isEmpty ? 'Button ${widget.displayIndex}' : it.label;

    final status = widget.isRecording
        ? 'Recording'
        : isEmpty
            ? 'Hold to record'
            : widget.isPlaying
                ? 'Playing'
                : 'Tap to play';

    final footer = '${it.usageCountTotal} plays';

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
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: border, width: 1.4),
          color: const Color(0xFF12151A),
          boxShadow: [
            BoxShadow(
              color: glow,
              blurRadius: 18,
              spreadRadius: 1,
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      height: 1.1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (it.integrityStatus != RitualRepo.integrityOk)
                  IconButton(
                    tooltip: 'Integrity',
                    onPressed: widget.onIntegrityTap,
                    icon: const Icon(
                      Icons.error_outline,
                      color: Colors.orangeAccent,
                      size: 20,
                    ),
                  ),
                PopupMenuButton<String>(
                  color: const Color(0xFF16181D),
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white60,
                    size: 20,
                  ),
                  onSelected: (v) async {
                    if (v == 'rename') widget.onRename();
                    if (v == 'archive') await widget.onArchive();
                    if (v == 'move') await widget.onMove();
                    if (v == 'delete') await widget.onDelete();
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'rename',
                      child: Text('Rename'),
                    ),
                    PopupMenuItem(
                      value: 'archive',
                      enabled: !isEmpty && it.activePath != null,
                      child: const Text('Archive'),
                    ),
                    const PopupMenuItem(
                      value: 'move',
                      child: Text('Move to sleeve'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete permanently'),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: widget.isRecording
                    ? Colors.redAccent.withValues(alpha: 0.15)
                    : widget.isPlaying
                        ? Colors.lightBlueAccent.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: widget.isRecording
                      ? Colors.redAccent
                      : widget.isPlaying
                          ? Colors.lightBlueAccent
                          : Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              footer,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.45),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
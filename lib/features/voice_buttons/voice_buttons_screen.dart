import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  late final TabController tabs;

  int _lastUiMessageId = 0;

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
    tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabs.dispose();
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
        title: const Text('Label'),
        content: TextField(
          controller: c,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Zähne putzen'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
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

  Future<void> _integrityDialog(BuildContext context, RitualItem it) async {
    final status = it.integrityStatus;
    final title = status == RitualRepo.integrityOk ? 'OK' : 'Integrity issue';

    final details = <String>[];
    details.add('Status: $status');
    details.add('State: ${it.state}');

    if (it.activePath != null && it.activePath!.isNotEmpty) {
      details.add('Active: ${it.activePath}');
    }

    if (it.archivedPath != null && it.archivedPath!.isNotEmpty) {
      details.add('Archive: ${it.archivedPath}');
    }

    if (it.integrityCheckedAt != null) {
      details.add(
        'Checked: ${DateTime.fromMillisecondsSinceEpoch(it.integrityCheckedAt!).toLocal()}',
      );
    }

    final canRepairRecorded =
        status != RitualRepo.integrityOk && it.state == RitualRepo.stateRecorded;
    final canRepairArchived =
        status != RitualRepo.integrityOk && it.state == RitualRepo.stateArchived;

    final action = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(details.join('\n\n')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'check'),
            child: const Text('Run check'),
          ),
          if (canRepairRecorded)
            TextButton(
              onPressed: () => Navigator.pop(context, 'repairRecorded'),
              child: const Text('Repair to empty'),
            ),
          if (canRepairArchived)
            TextButton(
              onPressed: () => Navigator.pop(context, 'repairArchived'),
              child: const Text('Repair to empty'),
            ),
          if (status != RitualRepo.integrityOk)
            TextButton(
              onPressed: () => Navigator.pop(context, 'delete'),
              child: const Text('Delete slot'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Voice Repeat'),
        actions: [
          IconButton(
            tooltip: 'Integrity check',
            onPressed: () => controller.runIntegrityCheck(),
            icon: const Icon(Icons.shield_outlined),
          ),
        ],
        bottom: TabBar(
          controller: tabs,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Archive'),
          ],
        ),
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
                SnackBar(content: Text(msg.text)),
              );
            });
          }

          return TabBarView(
            controller: tabs,
            children: [
              StreamBuilder<List<RitualItem>>(
                stream: repo.watchActive(widget.personId),
                builder: (context, snap) {
                  final items = snap.data ?? const [];
                  return _gridActive(context, items);
                },
              ),
              StreamBuilder<List<RitualItem>>(
                stream: repo.watchArchived(widget.personId),
                builder: (context, snap) {
                  final items = snap.data ?? const [];
                  return _listArchive(context, items);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _gridActive(BuildContext context, List<RitualItem> items) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: GridView.builder(
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.55,
        ),
        itemBuilder: (_, i) {
          final it = items[i];
          return _ActiveTile(
            item: it,
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
            onDelete: () => controller.deleteActive(
              it.itemId,
              activePath: it.activePath,
            ),
          );
        },
      ),
    );
  }

  Widget _listArchive(BuildContext context, List<RitualItem> items) {
    return ListView.separated(
      padding: const EdgeInsets.all(14),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
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
              await controller.deleteArchived(
                it.itemId,
                archivedPath: it.archivedPath,
              );
              return false;
            }
          },
          child: ListTile(
            tileColor: Colors.white10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              it.label.isEmpty ? 'Archived item' : it.label,
              style: const TextStyle(color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              'Used ${it.usageCountTotal} times',
              style: const TextStyle(color: Colors.white70),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (it.integrityStatus != RitualRepo.integrityOk)
                  IconButton(
                    tooltip: 'Integrity',
                    onPressed: () => _integrityDialog(context, it),
                    icon: const Icon(
                      Icons.error_outline,
                      color: Colors.white70,
                    ),
                  ),
                IconButton(
                  onPressed: () async {
                    final path = it.archivedPath;
                    if (path == null) return;

                    final didPlay = await controller.togglePlay(it.itemId, path);
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
        );
      },
    );
  }

  Widget _swipeBg(String text, IconData icon, {required bool left}) {
    return Container(
      alignment: left ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white10,
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

class _ActiveTile extends StatefulWidget {
  const _ActiveTile({
    required this.item,
    required this.isRecording,
    required this.isPlaying,
    required this.onIntegrityTap,
    required this.onHoldStart,
    required this.onHoldEnd,
    required this.onTap,
    required this.onRename,
    required this.onArchive,
    required this.onDelete,
  });

  final RitualItem item;
  final bool isRecording;
  final bool isPlaying;
  final VoidCallback onIntegrityTap;
  final Future<void> Function() onHoldStart;
  final Future<void> Function() onHoldEnd;
  final Future<void> Function() onTap;
  final VoidCallback onRename;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

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
    final isEmpty = it.state == 'empty';

    final border = widget.isRecording
        ? Colors.redAccent
        : widget.isPlaying
            ? Colors.lightBlueAccent
            : isEmpty
                ? Colors.white24
                : Colors.white;

    final title = it.label.isEmpty ? 'Button ${it.slotIndex + 1}' : it.label;

    final status = widget.isRecording
        ? 'Recording'
        : isEmpty
            ? 'Hold to record'
            : widget.isPlaying
                ? 'Playing'
                : 'Tap to play';

    final footer = '$status • ${it.usageCountTotal} plays';

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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: border, width: 2.5),
          color: Colors.black,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      height: 1.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (it.integrityStatus != RitualRepo.integrityOk)
                  IconButton(
                    tooltip: 'Integrity',
                    onPressed: widget.onIntegrityTap,
                    icon: const Icon(
                      Icons.error_outline,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white70,
                    size: 20,
                  ),
                  onSelected: (v) {
                    if (v == 'rename') widget.onRename();
                    if (v == 'archive') widget.onArchive();
                    if (v == 'delete') widget.onDelete();
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
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              footer,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 11,
                height: 1.0,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
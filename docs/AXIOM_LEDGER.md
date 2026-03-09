# AXIOM LEDGER

## Current Version
- v1.0 baseline
- Working branch: v1.1 hardening
- Current reference commit: eb33100

## Core Invariants
- Never zero empty slots
- New slot only if none empty exists
- No illegal state transitions
- No recording continues after pointer release
- File based storage only, no in memory buffering
- App private storage only

## Confirmed Product Semantics
- Delete removes the slot row and the button disappears
- Clear keeps the slot row but empties its content
- Playback and recording operate on files, not memory buffers

## Data Model
### schemaVersion
- Current: 2
- Planned next: 3 for integrity layer

### Tables
- Persons
- RitualItems
- RitualEvents

## Public APIs
### RitualRepo
- ensureDefaultPerson()
- ensureInitialSlots()
- ensureAtLeastOneEmpty()
- watchActive()
- watchArchived()
- rename()
- setRecorded()
- markPlayed()
- setArchived()
- restore()
- clearToEmpty()
- deleteSlot()

### VoiceButtonsController
- startHold()
- stopHold()
- togglePlay()
- archive()
- restore()
- deleteActive()
- deleteArchived()
- clearSlotKeepButton()

## Current Technical Structure
- UI: voice_buttons_screen.dart
- Orchestration: voice_buttons_controller.dart
- Domain and invariants: ritual_repo.dart
- Persistence: app_db.dart
- File storage: file_storage.dart
- Audio boundary: audio_service.dart
- Verification script: tool/verify.bat

## Next Planned Work
### Commit 1
- Lock contract files
- Expand shared constants
- No behavior change

### Commit 2
- Integrity layer in Drift
- Reconciliation light service
- Detection only, no auto fix

### Commit 3
- Minimal UI surfacing for integrity checks
- Badge and manual check action
- Error feedback improvements
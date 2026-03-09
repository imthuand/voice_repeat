# AXIOM LEDGER

## Current Version
- v1.0 baseline
- Working branch: v1.1 hardening
- Current reference commit: d0b9b28

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
- Current: 3

### Tables
- Persons
- RitualItems
- RitualEvents

### RitualItems notable fields
- itemId
- personId
- slotIndex
- label
- state
- activePath
- archivedPath
- sizeBytes
- usageCountTotal
- lastUsedAt
- sleeveId
- searchText
- recordedAt
- archivedAt
- integrityStatus
- integrityCheckedAt
- createdAt
- updatedAt

### RitualEvents notable fields
- eventId
- itemId
- personId
- eventType
- timestamp
- metadata
- sleeveId
- slotIndex
- itemState
- path
- sizeBytes
- source
- enforcementMode

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
- logEvent()

### VoiceButtonsController
- startHold()
- stopHold()
- togglePlay()
- archive()
- restore()
- deleteActive()
- deleteArchived()
- clearSlotKeepButton()
- runIntegrityCheck()

### IntegrityService
- checkPerson()

## Current Technical Structure
- UI: voice_buttons_screen.dart
- Orchestration: voice_buttons_controller.dart
- Domain and invariants: ritual_repo.dart
- Persistence: app_db.dart
- File storage: file_storage.dart
- Audio boundary: audio_service.dart
- Integrity detection: integrity_service.dart
- Verification script: tool/verify.bat

## Current Branch Stabilization Status
### Already present in codebase
- schemaVersion 3
- integrityStatus on RitualItems
- integrityCheckedAt on RitualItems
- fileExists in FileStorage
- listActiveFiles in FileStorage
- listArchivedFiles in FileStorage

### Commit 2A purpose
- Reconcile ledger with real codebase
- Move shared constants to one source of truth
- Normalize repo and integrity service to shared constants
- No intended user visible behavior change

## Next Planned Work
### Commit 2B
- Minimal UI surfacing for integrity checks
- Badge and manual check action
- Error feedback improvements

### Commit 3
- Strict enforcement preparation
- No silent fallback paths where avoidable
- Better auditability
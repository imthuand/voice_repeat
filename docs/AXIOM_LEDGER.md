# AXIOM LEDGER

## Current Version
- v1.0 baseline
- Working branch: v1.1 hardening
- Current reference commit: 81047d8

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
- repairMissingRecordedToEmpty()
- repairMissingArchivedToEmpty()
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
- repairRecordedIssueToEmpty()
- repairArchivedIssueToEmpty()
- runIntegrityCheck()
- runIntegrityCheckRepairRecorded()
- runIntegrityCheckRepairAll()

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

## Current Branch Status
### Already implemented
- schemaVersion 3
- Integrity status fields persisted on RitualItems
- File existence checks in FileStorage
- Manual integrity check from UI
- Integrity issue badge in UI
- Snackbar based user feedback in controller and screen
- Shared constants normalized across integrity layer
- Strict enforcement mode prepared in repo and integrity events
- Recovery and repair domain paths for missing recorded and archived items
- Recovery actions exposed in integrity dialog

### Commit 4C purpose
- Make integrity actions available from a single app level menu
- Allow one click check only, repair active, or repair all
- Keep delete clearly separate from repair
- Improve speed of field recovery without changing domain rules

## Enforcement Model
### Soft
- Prefer resilience
- Record issues and continue where safe
- Current default mode

### Strict
- Fail fast on invalid transition inputs
- Reject missing paths and zero sized recordings at repo boundary
- Improve auditability and future repair workflows

## Recovery Model
### Detection
- Integrity service identifies missing path and missing file states

### Repair
- Missing recorded item can be repaired to empty
- Missing archived item can be repaired to empty
- Repair logs an explicit auto fixed event
- Repair restores integrity status to ok
- Repair preserves the invariant that there is always at least one empty slot

## Next Planned Work
### Next commit
- Distinguish delete and repair even more clearly in UI
- Optional confirmation for destructive delete
- Better repair result summaries

### Later
- Sleeves
- Scheduling and alarms
- richer reconciliation and repair workflows
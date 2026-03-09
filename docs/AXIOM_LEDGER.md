# AXIOM LEDGER

## Current Version
- v1.0 baseline
- Working branch: v1.1 hardening
- Current reference commit: e11bf05

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
- Current: 4

### Tables
- Persons
- Sleeves
- RitualItems
- RitualEvents

### Sleeves notable fields
- sleeveId
- personId
- name
- sortOrder
- createdAt
- updatedAt

### RitualItems notable fields
- itemId
- personId
- slotIndex
- sleeveId
- label
- state
- activePath
- archivedPath
- sizeBytes
- usageCountTotal
- lastUsedAt
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
- ensureDefaultSleeve()
- ensureInitialSlots()
- ensureAtLeastOneEmpty()
- watchSleeves()
- createSleeve()
- renameSleeve()
- deleteSleeve()
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
- setActiveSleeve()
- createSleeve()
- renameActiveSleeve()
- deleteActiveSleeve()
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
### Already implemented before sleeves
- schemaVersion 3 hardening and integrity layer
- file existence checks in FileStorage
- manual integrity check from UI
- integrity issue badge in UI
- snackbar based user feedback in controller and screen
- shared constants normalized across integrity layer
- strict enforcement mode prepared in repo and integrity events
- recovery and repair domain paths for missing recorded and archived items
- global integrity actions for check only, repair active, and repair all
- finalized integrity UX hardening

### Sleeve v1 purpose
- Introduce explicit sleeve domain model
- Keep default sleeve stable
- Make active and archived queries sleeve aware
- Add sleeve switching and sleeve management in UI
- Keep migration low risk by preserving existing items on default sleeve
- Avoid advanced sleeve features such as drag and drop, icons, colors, and reordering for now

## Sleeve Rules
- Every person has a stable default sleeve
- New sleeves get one empty slot immediately
- Default sleeve cannot be deleted
- A sleeve can only be deleted when all of its items are empty
- Active and archived views are always filtered by current sleeve
- Integrity checks still run across the whole person scope

## Next Planned Work
### Next major step
- Sleeve refinement and move items between sleeves
- Optional sleeve reordering
- Optional sleeve icons and colors

### Later
- Scheduling and alarms
- richer reconciliation and repair workflows
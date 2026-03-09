# AXIOM LEDGER

## Current Version
- v1.0 baseline
- Working branch: v1.1 hardening
- Current reference commit: 465248c

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
- Current: 5

### Tables
- Persons
- Sleeves
- RitualItems
- RitualEvents

### Persons notable fields
- personId
- displayName
- role
- language
- lastActiveSleeveId
- createdAt
- updatedAt

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
- getLastActiveSleeveId()
- setLastActiveSleeveId()
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
- initializeSleeveSelection()
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
### Already implemented before this step
- schemaVersion 4 sleeves foundation
- sleeve aware queries
- sleeve creation, rename, delete
- integrity and recovery hardening
- global integrity repair actions

### This commit purpose
- Make sleeve selection the primary navigation control
- Persist the last used sleeve per person
- Restore last used sleeve on startup
- Fall back to default sleeve after sleeve deletion
- Remove hidden horizontal sleeve overflow

## Sleeve Rules
- Every person has a stable default sleeve
- New sleeves get one empty slot immediately
- Default sleeve cannot be deleted
- A sleeve can only be deleted when all of its items are empty
- Active and archived views are always filtered by current sleeve
- Integrity checks still run across the whole person scope
- Last used sleeve is restored on app start when it still exists
- If the active sleeve is deleted, the app switches to default sleeve and persists that change

## Next Planned Work
### Next major step
- Move items between sleeves
- Optional sleeve reordering
- Optional sleeve icons and colors

### Later
- Scheduling and alarms
- richer reconciliation and repair workflows
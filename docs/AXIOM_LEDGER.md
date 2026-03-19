# AXIOM LEDGER

## Current Version
- v1.0 baseline
- Working branch: v1.1 hardening
- Current reference commit: 0f6520d

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
- Sleeve is the primary navigation context
- Active and Archive are view modes within the current sleeve
- Last used sleeve is restored on startup
- If the active sleeve is deleted, the app switches to default sleeve

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
- moveItemToSleeve()
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
- moveItemToSleeve()
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
- recording and playback stable
- archive, restore, delete flows stable
- strict slot invariants enforced through repo logic
- integrity detection and repair flows
- sleeves v1 domain layer
- sleeve selector as primary navigation context
- active and archive filtered by current sleeve
- last active sleeve persisted and restored
- fallback to default sleeve after sleeve deletion
- move between sleeves flow
- first visual foundation pass
- verify pipeline green at commit 0f6520d

### This commit purpose
- replace the cheap system style sleeve dropdown
- introduce a visual sleeve hero selector
- move sleeve switching into a bottom sheet
- make active voice tiles more playful and characterful
- add sleeve theme colors and stronger visual differentiation
- keep archive calmer and more restrained than active

## Sleeve Rules
- Every person has a stable default sleeve
- New sleeves get one empty slot immediately
- Default sleeve cannot be deleted
- A sleeve can only be deleted when all items are empty
- Active and archived views are always filtered by current sleeve
- Integrity checks still run across the whole person scope
- Last used sleeve is restored on app start when it still exists
- If the active sleeve is deleted, the app switches to default sleeve and persists that change
- A moved item keeps its content, state, metadata, and integrity status
- A move to the same sleeve is rejected
- Source and target sleeves must both preserve the empty slot invariant after move

## UX Rules
- Sleeve remains the main context selector
- Active and Archive are secondary modes, not constant top level tabs
- Mode switching can be hidden until intentionally revealed
- The hidden mode switch must remain discoverable through a visible bottom handle
- Recording, playing, empty, and normal states should be visually distinct
- Destructive actions must stay clearly marked and confirmed where required
- Sleeve switching should feel modern and intentional, not like a classic form control
- Active tiles can be more playful and expressive than archive rows

## Design Direction v2
- Dark, calm, playful premium interface
- Visual sleeve identity through theme color and icon
- Sleeve selector presented as a hero control, not a basic input
- Active voice tiles use softer organic shapes and layered bubble language
- More depth, shadow, and personality
- Archive remains simpler and more operational
- Functional clarity remains more important than decoration

## Known Constraints
- Sleeve themes are currently derived in UI only
- Theme selection is not yet user configurable
- Bubble and playful styling is visual only for now
- No advanced motion system yet
- No design token layer yet
- Active and archive bottom reveal remains intentionally simple in v1

## Next Planned Work
### Immediate next layer after this design pass
- review the new sleeve selector and tile language on device
- decide whether to push design one step further or move back to feature work
- assess whether per sleeve themes should later become configurable

### Likely next functional step
- alarm and scheduling domain foundation
- no background auto playback yet
- first define model, storage, and UI setup cleanly

### Later
- richer alarm behavior
- notifications or timed playback decision
- optional sleeve theme customization
- richer reconciliation and repair workflows
# AXIOM LEDGER

## Current Version
- v1.0 baseline
- Working branch: v1.1 hardening
- Current reference commit: e9955c0

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
- One alarm schedule per active button in alarm foundation v1
- Alarm icon on tile is the direct entry point into scheduling

## Data Model
### schemaVersion
- Current: 6

### Tables
- Persons
- Sleeves
- RitualItems
- RitualEvents
- RitualSchedules

### RitualSchedules notable fields
- scheduleId
- itemId
- personId
- kind
- label
- enabled
- hour
- minute
- weekdayMask
- createdAt
- updatedAt
- lastTriggeredAt
- nextTriggerAt

## Public APIs
### RitualRepo
- unchanged core item lifecycle and sleeve APIs

### AlarmRepo
- getScheduleForItem()
- watchScheduleForItem()
- saveScheduleForItem()
- setEnabledForItem()
- deleteScheduleForItem()
- describeWeekdayMask()
- formatTime()
- describeSchedule()

### VoiceButtonsController
- existing voice and sleeve methods
- saveAlarmSchedule()
- deleteAlarmSchedule()

## Current Technical Structure
- UI: voice_buttons_screen.dart
- Voice orchestration: voice_buttons_controller.dart
- Item domain and invariants: ritual_repo.dart
- Alarm domain foundation: alarm_repo.dart
- Persistence: app_db.dart
- File storage: file_storage.dart
- Audio boundary: audio_service.dart
- Integrity detection: integrity_service.dart
- Verification script: tool/verify.bat

## Current Branch Status
### Already implemented
- recording and playback stable
- archive, restore, delete flows stable
- sleeve system stable
- integrity flows stable
- adult playful design refinement
- action sheets instead of raw tile popup menus

### This commit purpose
- introduce alarm foundation v1
- add persistent schedule model
- add direct bell icon entry on active tiles
- add intuitive alarm editor with time and weekday selection
- keep future OS scheduling open without overcommitting runtime behavior yet

## UX Rules
- Alarm entry should be obvious and one tap away on the tile
- Alarm editing should feel lightweight and friendly
- Time selection and day selection should be clear without feeling technical
- Alarm setup should not require leaving the tile context
- Save and remove paths should both be obvious

## Design Direction for Alarms
- bell icon as first class tile affordance
- one schedule per item in v1
- daily, weekdays, weekend, and custom day patterns supported through weekday mask
- schedule summary shown directly on the tile once configured

## Known Constraints
- This step does not yet perform live OS level scheduling
- Android exact alarms need special access and are denied by default for many new installs
- iOS local notification scheduling is possible later, but this step intentionally focuses on data and UX foundation first
- No background auto playback yet
- Notification runtime and rescheduling logic will be the next alarm layer

## Next Planned Work
### Next alarm layer
- connect saved schedules to local notifications
- compute and persist nextTriggerAt
- add boot and permission recovery logic
- decide exact reminder behavior versus regular local notification behavior

### Later
- optional multiple alarms per button
- optional alarm theme variations
- optional sound preview or linked playback logic
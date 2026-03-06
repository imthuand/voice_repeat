# AXIOM LEDGER

## Current Version
- v1.0 baseline (commit 366896e)

## Core Invariants
- Never zero empty slots
- New slot only if none empty exists
- No illegal state transitions
- No recording continues after pointer release
- File based storage only, no in memory buffering
- App private storage only

## Data Model
### schemaVersion
- Current: 2

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

### VoiceButtonsController
- startHold()
- stopHold()
- togglePlay()
- archive()
- restore()
- deleteActive()
- deleteArchived()
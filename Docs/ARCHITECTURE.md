# Architecture

## Shape

Slipstream is a functional core inside a main-actor shell, and every run passes through the same four layers.

~~~text
SwiftUI screens
    ↓ RunAction
RunPresentationModel
    ↓ RunEvent
RunReducer
    ↓ RunEffect
App shell services and task store
~~~

The reducer owns every product state transition. The app shell owns time, UIKit, haptics, tasks, and the simulated services. Views render `RunViewState` and send intent, nothing more.

## Modules

The Swift package in `Packages/SlipstreamKit/` holds four modules, and the app target holds the rest.

| Module | Responsibility |
| --- | --- |
| SlipstreamDomain | Run models, source-neutral music and cadence values, track-fit planning, adaptation policy, state, events, effects, the reducer, and the summary |
| SlipstreamMotion | The cadence provider boundary, deterministic filtering and simulation, and the Core Motion adapter |
| SlipstreamAudio | Local tempo analysis, the source-neutral playback contract, a deterministic player, beat timing, and playback events |
| SlipstreamDesign | Screens, controls, the fluid field, the tempo aperture, previews, and design tokens |
| App target (`App/`) | Presentation mapping, effect execution, UIKit, task ownership, and the Apple Music player and importer |

## State ownership

`RunReducer` is the only authority for phase changes. Mutually exclusive phases are enums. The reducer stays free of SwiftUI, Core Motion, audio frameworks, UIKit, and the wall clock.

`RunPresentationModel` owns one `RunState`, maps it to `RunViewState`, and executes the reducer's effects. `RunTaskStore` owns replacement, cancellation, and protection against stale generations for all async work.

## View structure

`SlipstreamScreen` keeps one continuous atmospheric surface and routes state to a focused screen:

- `ReadyScreen`
- `ActiveRunScreen`
- `RunRecoveryScreen`
- `RunSummaryScreen`

Run controls, the rhythm control, summary metrics, duration formatting, the aperture, and the fluid field each live in their own types. Views hold only thin UI actions, and business transitions stay in the reducer.

## Cancellation

Every replaceable task has a `RunTaskKind`, and starting a replacement cancels the prior generation. Pausing cancels acquisition, the control timeout, and the ticker. Route loss and finishing cancel all session work before the pause or stop effect runs.

Stale events carry a session, acquisition, timeout, or hold identifier, and the reducer ignores any that do not match.

## Collection navigation

The reducer receives the selected tracks. In the shipping app it gets only the imported tracks that are ready to adapt, while deterministic fixtures keep their configured collection. The domain makes no assumption about collection size.

`TrackMatchPlanner` is the source-neutral seam for coarse matching. Given a requested BPM and a quality envelope, it ranks ready tracks by the smallest stretch against their measured running-range pulse. A lower musical pulse takes part only when analysis independently found a supported stride pulse. Ties keep source order, and the planner keeps the current song when switching would gain only a marginal improvement. Preparation may update the next queue candidate, but only Skip or a natural boundary that the player confirms changes transport. That connection belongs to the reducer and the player queue, never to SwiftUI.

## Production seams

Real motion and audio sit behind the same boundaries as the simulated ones. Nothing in SwiftUI bypasses the reducer, and no Core Motion, MusicKit, or audio callback mutates view state directly.

Every production service needs:

- Async event streams
- An explicit start, pause, resume, and stop lifecycle
- Teardown that is safe under cancellation
- Session identity on its callbacks
- A deterministic adapter for tests

Apple Music is the selected production player. `AppleMusicPlaybackController` lives on the main actor in the app target and implements the source-neutral `MusicPlaybackProviding` boundary. When an imported collection is restored, the normal app pairs it with `CoreMotionCadenceProvider`. Automated fixtures and previews keep deterministic simulation. The codebase has no second production player.

Stable cadence enters the reducer with session and acquisition identity. The reducer owns `AdaptationState`, evaluates the current track's tempo, and emits a bounded rate effect that carries session, playback operation, rate request, and track identity. Player feedback must match all four before the reducer records the applied rate. Cadence sensing continues while the phone is locked, so a loss of confidence can hold the rate, ease toward normal speed, and return to acquisition without any direct platform mutation.

`RhythmControlState` is source-neutral run state. Auto applies a bounded correction to reliable cadence, and Manual supplies a musical target without inventing cadence. Both go through the same `AdaptationPolicy`, so rate limits, ramping, deadband, confidence handling, compatibility, and identified MusicKit feedback stay authoritative. The SwiftUI control freezes its displayed target during a drag, sends intent through `RunPresentationModel`, and never writes to the player.

## Music analysis and import

The Debug-only MusicKit harness sits in the app target and is not a production player. It resolves opaque library tracks by strict agreement on title, artist, album, and duration, downloads each preview into temporary storage, passes the local file through `TempoAnalyzing`, records the estimate, and deletes the file. `LocalTempoAnalyzer` owns PCM decoding off the main thread. `TempoEstimator` owns the versioned Accelerate spectral-flux and fractional-lag autocorrelation behind the same small interface.

`AppleMusicImportService` reuses the strict resolver, analyzes three tracks at a time, and reports honest progress. `MusicCollectionStore` saves the selected collection and the versioned analysis cache atomically. `MusicSelectionModel` owns replacement identity and ignores stale import callbacks. SwiftUI sends only choose, change, and start intent.

`TempoCorpusValidator` is an opt-in development executable. It checks fixed catalog songs whose published titles declare a tempo, analyzes temporary previews hosted by the provider, writes JSON evidence, and removes the audio. Normal automated tests stay offline.

## Phone data

Everything the app saves lives in one folder under Application Support, set by `App/PhoneDataFolder.swift`. That folder's name must never change, for the reason given in [DEVELOPMENT.md](DEVELOPMENT.md).

Debug builds record every run. `RunDiagnosticsRecorder` observes accepted reducer transitions from the app shell and records control mode, requested BPM, derived and applied rates, limit state, player progress, cadence, track changes, recovery events, and summary truth. `RunDiagnosticsStore` appends that record to one `.jsonl` file per run in the folder's `run-records/` directory and keeps the newest 60. It never changes reducer state and is not product run history. [PHONE.md](PHONE.md) explains how to pull and read the records.

## Invariants

- The interface reports capability honestly
- Paused and acquiring time never inflate the active summary
- Route restoration never resumes active playback on its own
- Finish requires a visible control plus a hold
- Progress resets on track navigation
- Reduce Motion freezes ambient motion
- There is no Slipstream backend, and Apple Music is the only production network path
- Tempo-match measurement enters the reducer as evidence from the app shell. The reducer never infers a match from cadence alone
- Playback progress and recovery callbacks carry session and operation identity before they enter the reducer
- Applied-rate callbacks also carry request and track identity, so stale feedback cannot alter a replacement run

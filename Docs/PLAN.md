# Product plan

## Active milestone

Milestone 2 turns the interaction prototype into a useful music product. [MILESTONE-2.md](Specs/MILESTONE-2.md) specifies it in full: playlist import, real cadence, adaptive playback, honest measurement, source selection, testing, and physical completion.

The finish line is one real outdoor run, not a feature checklist. Samay should be able to import one Apple Music playlist, start running, hear the music settle into his cadence, lock the phone, recover from normal interruptions, finish, and trust the summary. Scope stops growing until that run works.

The wheel keeps one release-blocking contract. It can never display or commit a BPM that the current song cannot produce inside its proven playback-rate range. At either limit, the value and the detent feedback stop together, one restrained haptic marks the limit, and turning back responds at once.

Work in this order:

1. Install the current build, walk Easy Miles, and read the record. This answers what the August 19 walk could not: whether cues played, what happened at a song boundary, and whether the reach line fired. It is also the first chance to hear the crossfade.
2. Run the ordered checks in [PHONE.md](PHONE.md): endpoint listening, transport and Finish feel, blinded direction trials, song-change causes, and lock, call, and route recovery.
3. Complete one 20-minute outdoor run with an imported playlist. It has to feel good, survive normal phone conditions, and end with an honest summary.

After that run, the open question is beat phase. Tempo match and beat lock stay distinct until phase is measured. The gate for that and the move to app-owned audio are written in [FELT-SYNCHRONIZATION-EXECUTION-SPEC.md](Archive/FELT-SYNCHRONIZATION-EXECUTION-SPEC.md).

The source decision and the deferred reliability requirements are in [MUSIC-SOURCE-RESOLUTION-SPEC.md](Archive/MUSIC-SOURCE-RESOLUTION-SPEC.md). A later reliability failure must be fixed before Milestone 2 is complete. It does not reopen Spotify or a second provider.

## Decision waiting on Samay

After the next walk, Samay decides whether to bring back Auto fine-tune or delete its code. Fine-tune let the runner nudge Auto up to 20 BPM above or below the sensed cadence while Auto kept following it. The app has no control for it now, because turning the wheel switches to Manual, and PRODUCT.md no longer promises it. The reducer path, its tests, and one preview remain, and [MILESTONE-2.md](Specs/MILESTONE-2.md) still records the original requirement. Nobody touches any of it until the decision. If the walk leaves Samay wanting to nudge Auto, the wheel gains a way to send `adjustRhythmControl`. If it does not, the path and its tests go.

This came out of the November sweep and was not built, because it changes the product.

## Milestone boundary

Inside the milestone:

- One imported collection
- One selected production playback system
- Core Motion cadence from one declared phone placement
- Tempo analysis on the phone
- Compatible-track selection plus fine correction inside a declared range that passes physical listening
- One calm in-run BPM control for automatic matching, manual targeting, and small corrections
- Background continuity with the screen locked
- The existing pause, resume, skip, route recovery, finish, and summary behavior
- Physical calibration, listening evidence, and one 20-minute outdoor run

Outside it:

- Playlist generation and recommendations
- Spotify or a second production music provider
- A beat-lock claim before phase and latency are measured
- Run history, GPS, coaching, social features, a backend, subscriptions, and broad hardware support

## Stop rule

Do not redesign the app or build playlist generation before imported music and the physical body-to-music loop work. The BPM control belongs to that loop and is not a settings feature. The November 5 color, name, and icon pass is the one exception, made at Samay's direct request, and it left layout and behavior alone. If public MusicKit cannot make a clean change that Samay can reliably feel, reopen the source decision. The full mechanics and evidence thresholds are in [ADAPTIVE-AUDIO.md](Research/ADAPTIVE-AUDIO.md).

## Testing debt

- 32 interface tests still launch the app. Many check a fixed setup state and could move to `ScreenRenderingTests`, which would leave about 5 for real touch and the whole flow. Move them one group at a time, and make sure each moved test still catches what the old one caught.
- Two tests that reach for `finish-run` failed once each on 2026-11-24 and passed on rerun: `ScreenRenderingTests.finishKeepsItsPlaceWhenItArms` as the first screen drawn in a gate, and `RunFlowUITests.testFinishHoldReleasedEarlyKeepsTheRunThenCompletes`, where the run controls had already withdrawn before a busy Simulator clone tapped. Make both wait for the controls to be present, or reveal them, before acting.
- Direct drawing cannot set Reduced Transparency, because the system offers no override for it. Glass under that setting needs a look on a real phone.

## Debt before any public release

None of this affects today's Debug phone builds.

- Run a trademark check on the name Slipstream.
- Diagnostics and Simulator launch flags still compile into Release, although Release never records and the Debug screens are absent. Wrap them in `#if DEBUG` before an App Store build.
- `RunReducer.init(trackCount:)` exists only for tests, and it keeps a `demo-0` fallback in the domain. Move those tests to `init(tracks:)`.
- `FeedbackAuditionView` plays cues directly. It is a Debug harness that goes away once a cue family is chosen.
- If `resume` is still in flight when the runner pauses, Apple Music can start playing after the pause. The ticker no longer restarts, but playback itself is unguarded.

## Completed gates

### Repository foundation

The project generates, builds, tests, and stores evidence without production dependencies.

### Interaction prototype

Every meaningful state renders deterministically, and the main flow and recovery paths pass. Visual hierarchy, accessibility, progress, controls, finish safety, and the summary were settled at prototype level.

### Music setup chain

Empty selection, playlist loading and selection, exact analysis progress, partial and complete readiness, a typed disclosure of results, and recovery specific to each action share one continuous playlist instrument. The playlist's identity stays put while status and actions change around it. Fresh iPhone 17 Pro Simulator frames cover the compact, empty, current-selection, large-library, long-name, accessibility XXXL, and Reduce Motion cases.

### Core reset software baseline

Every Debug run records its base commit, branch, dirty state, source fingerprint, build time, app version, and build number. It explains the current song speed, the phone's rhythm, the settled Auto target, the requested playback change, Apple Music's reply, the delay, the result, and the remaining difference. Deterministic tests cover the behaviors reported at the time. Fresh Simulator frames cover low-tempo two-step music, all four command results, a song reset, accessibility XXXL, Reduce Motion, and Increased Contrast.

### Track-scoped Manual and tempo close

Manual stays active on the same confirmed song through pause, resume, route loss, and recovery. It returns to Auto only when the player confirms a different song or the runner chooses Auto. The tempo wheel has an accessible close action that restores the playback controls without changing playback or rhythm.

### Transport, song-change cause, and the first Auto feedback prototype

Play, Pause, Previous, Next, and Finish form one control system. Three separate interactive Liquid Glass circles carry transport, with a larger tinted primary, and a quiet Finish button below them arms a hold whose fill stays inside its own capsule. Both causes of the reported Finish overflow were reproduced on video and removed. Every confirmed song change carries a cause of natural end, outside change, or explicit Previous or Next, and the hidden Debug screen shows it. A transaction owned by the reducer decides when one directional Auto cue is valid, and a Debug audition screen plays three prototype haptic families with paired arrival sounds by hand. Physical feel, sound quality, and how the cues coexist with Apple Music remain open.

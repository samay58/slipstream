![Slipstream: music in stride](Brand/GitHub-Cover.png)

# Slipstream

*music in stride*

Slipstream is a native iPhone music player that lets movement and music settle into one rhythm. You import an Apple Music playlist. The phone reads each song's tempo locally, senses your steps through Core Motion, picks songs that fit, and gently changes their speed while you walk or run.

It is deliberately small. There is no backend, account, analytics, GPS, or coaching, and no third-party code ships in the app.

## Where it stands

The software works end to end. Whether it feels right on a body is still open, and the milestone ends with one 20-minute outdoor run on one imported playlist. [STATUS](Docs/STATUS.md) says what a phone has and has not proved, and [PLAN](Docs/PLAN.md) says what happens next.

## Build

You need Xcode with an iOS 26 or later SDK and [XcodeGen](https://github.com/yonaskolb/XcodeGen).

~~~sh
./Scripts/bootstrap.sh    # Generate Slipstream.xcodeproj from project.yml
./Scripts/check.sh        # Run only the tests your changes can affect
./Scripts/gate.sh         # Run every software check before a phone install or a push
./Scripts/sim.sh run      # See the app in Simulator
~~~

A Debug launch in Simulator uses two local placeholder playlists, simulated cadence, and silent playback, so the whole flow works without Apple Music. Physical iPhones and Release builds never take that path.

The app was first called Samadhi. Its bundle identifier and the folder that holds its data on the phone keep that name, because the phone has the only copy of the imported playlist and its analysis. [DEVELOPMENT](Docs/DEVELOPMENT.md) explains.

## Layout

| Path | Holds |
| --- | --- |
| `App/` | The app shell: Apple Music, haptics, task ownership, diagnostics, and Debug harnesses |
| `Packages/SlipstreamKit/` | The tested core: `SlipstreamDomain`, `SlipstreamMotion`, `SlipstreamAudio`, `SlipstreamDesign`, and the tempo and replay tools |
| `Tests/` | App-model and interface tests |
| `Scripts/` | The gate, the fast check, the Simulator loop, and the phone loop |
| `Docs/` | The project guide below |
| `Evidence/` | Proof behind the claims, described in [Evidence/README.md](Evidence/README.md) |

## Project guide

| Question | Read |
| --- | --- |
| What are we building, and how should it feel? | [PRODUCT](Docs/PRODUCT.md) |
| Where are we now? | [STATUS](Docs/STATUS.md) |
| What happens next? | [PLAN](Docs/PLAN.md) |
| How do I work on it? | [DEVELOPMENT](Docs/DEVELOPMENT.md) |
| How do I install on the phone, and what must a phone check prove? | [PHONE](Docs/PHONE.md) |
| How is the code shaped? | [ARCHITECTURE](Docs/ARCHITECTURE.md) |
| What proves current behavior? | [TESTING](Docs/TESTING.md) |
| Why were key choices made? | [DECISIONS](Docs/DECISIONS.md) |
| What changed over time? | [PROGRESS](Docs/PROGRESS.md) |
| What exactly does the milestone require? | [Specs](Docs/Specs/) |
| What did research establish? | [Research](Docs/Research/) |
| What is finished and kept for reference? | [Archive](Docs/Archive/README.md) |

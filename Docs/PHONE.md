# Phone

This covers the real iPhone: what it needs, how to sign and install, the ordered checks only a body and an ear can make, and how to read what a run leaves behind. Never uninstall the app. The phone holds the only copy of the selected collection and its analysis cache.

## What the phone needs

- An iPhone 17 Pro on iOS 27 with Developer Mode on and an active Apple Music subscription.
- A Mac paired with it. Pairing is per Mac. Connect by cable once, accept the trust prompt, then turn on Connect via network in Xcode's Devices and Simulators window. After that the phone only needs to be awake on the same network.
- Team `ZL5U59XBJ6` and App ID `com.samaydhawan.Samadhi` with the MusicKit App Service enabled. The identifier keeps the app's first name on purpose, as [DEVELOPMENT.md](DEVELOPMENT.md) explains.

## Signing

MusicKit requires the exact App ID. A wildcard profile builds and installs, then fails at the first catalog request. Automatic signing can quietly pick a wildcard, so `./Scripts/phone.sh install` selects an exact profile itself and refuses to install anything else.

There are two ways to get the profile onto a Mac:

1. In Xcode, open Settings, then Accounts, select the team, and choose Download Manual Profiles.
2. In the Apple developer portal, download the iOS App Development profile for the exact App ID, then open the file.

The profile must list the signing certificate of the Mac doing the build, or the build fails before compiling. The current profile is `Samadhi Development 2026-08-15`, regenerated in the developer portal on 2026-11-05. Apple issued it for a year, so it expires on 2027-11-05 at 2:23 PM Eastern. Earlier copies lasted only 7 days. If it has expired, create a new one for the exact App ID, the current Apple Development certificate, and the registered iPhone.

Right after pairing, `./Scripts/phone.sh status` can report no pairing until a first connection, and `xcrun devicectl device info details --device <name>` makes that connection.

Do not create a Media Services key or embed a developer token. Apple issues the token automatically to a correctly signed app.

## Installing

~~~sh
./Scripts/phone.sh status
./Scripts/phone.sh install
./Scripts/phone.sh launch --core-diagnostics
~~~

`install` builds with the exact profile, checks the embedded profile and the signature, installs over the existing app, and confirms that the selected collection did not change. It saves any new run records first, so an install never risks a log. If the phone is locked, the install still succeeds and only the launch waits.

`--core-diagnostics` opens the hidden Debug screen. Compare its source fingerprint with the one `install` printed. They must match before any result counts.

## The phone check

These checks are the judgments software cannot make: body, ear, Bluetooth, lock screen, and real Apple Music. Run them in order. Each one names what to do, what counts, and where the result goes. None of them needs debugging. If a step fails, record it and move on. The whole check should take about 45 minutes, and if it runs longer, stop and record where the time went.

Start with `./Scripts/phone.sh install`.

### Launch and fingerprint (2 minutes)

- Open Slipstream, start a short run, open the hidden Debug screen, and read the source fingerprint. It must match the fingerprint of the signed build you inspected before installing.
- Record match or mismatch. On a mismatch, stop and rebuild.

### Endpoint listening (10 minutes, headphones)

- Use the Debug endpoint controls on one song with a clear beat. Play 0.90 and 1.10 first, since that pair is known, then 0.85 and 1.15, each for a full musical section.
- Record Apple Music's read-back for 0.85 and 1.15 from the Debug screen, requested against reported.
- Judge each endpoint as clean, slightly rough, or unusable, and name the song.
- Write the result in `Evidence/Device/YYYY-MM-DD-phone-check/README.md`.

### Transport and Finish feel (5 minutes)

- Judge the glass wheel, the speaker's pulse, and the glass sheet in daylight. The Simulator only approximates glass.
- Judge the lime button and the lime center cap in full sun.
- With the controls visible, press Pause, Resume, Previous, and Next several times. Each Previous or Next should tick once, and the song changes only when Apple Music confirms it.
- Tap Finish and release early twice, then hold to completion once. The fill must never show outside the pill, an early release must snap the fill back, and completion must feel like one event.
- Walk for one minute with the phone in the pocket and the screen on, and confirm Finish does not trigger by accident.
- Give Pause, Resume, Previous, Next, Finish arm, hold, cancel, and complete one word each: good, off, or broken. Add one line for anything off.

### Blinded faster or slower trials (10 minutes)

- Launch with `./Scripts/phone.sh launch --feedback-audition`, or run the `Slipstream Feedback Audition` scheme from Xcode. Keep the Music app playing a real song in the background so ducking or gaps are audible.
- For each family (pulse, swell, and step), run the 10-trial blinded mode with the phone in the pocket and headphones on. Tap Play cue, leave the phone in the pocket while it plays, and take it out only to answer. Do the set once on the `Core Haptics audio` path and once on the `Local audio player` path. Locked-screen delivery belongs to the lock-screen check below.
- Record family, sound path, seed, and score. A pass is 8 of 10 or better.
- Then play small, medium, and large in a row for one direction, and say whether size reads as rising strength without changing the felt direction.
- Note whether the music ducked, paused, gapped, or changed route at any cue.

### Song boundary with a known cause (5 minutes)

- Start a normal run and let one song play out. After the change, open the Debug screen and read `Last song change`, which should say `Natural end of the song`. Then press Next once and confirm it says `Next requested here`.
- If either one says `Changed outside Slipstream`, write down what happened just before the change.
- Listen to the natural change as a crossfade. Say whether it softens the break, whether the new song's speed correction fights the blend, whether Next also crossfades, and whether four seconds feels right.
- Record both causes as correct, or name the one that was wrong.

### Lock screen, interruption, and route (10 minutes)

- Lock the phone for two minutes during a run with Auto active. The music must continue, and once the phone is open again the Debug screen must show no stale or replayed Auto cue.
- Take or simulate a call, then end it. Slipstream should show the recovery screen and require an explicit resume, and a Manual setting must survive on the same song.
- Disconnect the headphones, reconnect them, and resume. The same expectations hold. Record whether the audio route came back cleanly.

### Save

- Run `./Scripts/phone.sh pull`, then write the notes and the parsed result into `Evidence/Device/YYYY-MM-DD-phone-check/`. The raw record stays local.
- Put three lines at the top of that README: the fingerprint, the endpoint verdict, and the blinded score for each family.

## Reading a run

Once a run finishes, pull its record while the phone is awake:

~~~sh
./Scripts/phone.sh pull
~~~

This keeps every new run in `~/Documents/Slipstream Run Records/runs/`, one file per run however often you pull, refreshes `ledger.csv` beside it, and prints the latest run and the ledger. Set `SLIPSTREAM_RUN_ARCHIVE` to use another folder. The records stay out of Git.

~~~sh
python3 Scripts/runs.py ledger        # One line per run, oldest first
python3 Scripts/runs.py read <file>   # One run in detail
swift run --package-path Packages/SlipstreamKit RunReplay <file.jsonl>   # That run through today's logic
~~~

Each run is one `.jsonl` file that only ever grows, with no limit on length. It holds the playlist and its measured tempos, every input to the reducer and what the reducer asked for, the state after each change, steps, distance, and pace from the pedometer, and the phone's battery, heat, lock state, and sound output. A run costs about 9 MB an hour. The phone keeps the newest 60, so pull at least that often. Builds before version 1.2 build 5 wrote a single JSON file, and `runs.py` reads both.

### Reading cue outcomes

A cue the reducer sent is not a cue that played. In the run file:

1. Entries of kind `autoFeedbackDelivery` carry `autoFeedbackTransactionID`, `autoFeedbackMoment` (`began` or `arrived`), `autoFeedbackFamily`, `autoFeedbackSoundPath`, `autoFeedbackDeliveryOutcome`, and `autoFeedbackDeliveryDetail`.
2. `playedThroughEngine` means the haptic engine started the pattern. `playedLocalSoundOnly` means there was no engine and the arrival sound used the local player. `engineUnavailable`, `patternMissing`, and `cancelledBeforePlay` mean nothing physical happened, and the detail says why.
3. Pair each delivery with the `autoFeedback` entry that has the same transaction identifier. A `began` with no delivery entry after it is a bug in the app shell.
4. Entries of kind `hapticEngine` trace the engine's life: `created`, `started`, `startFailed`, `stopped` with Apple's reason, `reset`, and `unsupported`. A `stopped: application suspended` between a `began` and its `arrived` is the locked-screen case that [AUTO-CHANGE.md](Specs/AUTO-CHANGE.md) calls out.

On an unlocked phone, the hidden Debug screen shows the last three outcomes under `What became of the cues`, and its `Next song` row says whether a fitting song was prepared.

"Played" is the engine's word, not the hand's. Whether anyone could feel a cue in a pocket stays a physical judgment.

## Debug tools

### Feedback audition

A Debug-only screen plays the Auto feedback prototypes by hand.

1. Start a real song in the Music app and leave it playing. Ducking, gaps, and route changes show up only against real Apple Music.
2. Launch with `./Scripts/phone.sh launch --feedback-audition`, or run the `Slipstream Feedback Audition` scheme in Xcode.
3. Use headphones at a safe volume, and keep the phone in the pocket for anything about tactile recognition.
4. Pick a family, direction, size, and sound path, then play the start, the arrival, or both. Sound and haptics toggle independently.
5. For a blinded run, note the seed and start the 10 trials. Copy the summary line, which carries family, sound path, seed, and score.

Nothing here becomes a product asset before this comparison. The bar is in [AUTO-CHANGE.md](Specs/AUTO-CHANGE.md).

### Focused core loop

The `Slipstream Apple Music Core Loop` scheme, or launching with `--apple-music-core-loop`, runs one known catalog song through real cadence and real Apple Music, with `What Slipstream saw` on screen. Use it to tell a playback problem from a playlist problem.

### Explaining a rejected song

`TempoProbe` prints the analyzer's decision and its strongest tempo candidates for Apple catalog song identifiers. It makes no product claim and does not touch the phone.

~~~sh
swift run --package-path Packages/SlipstreamKit TempoProbe 1497226892 1561775000
~~~

### Tempo corpus

The accuracy check against real previews needs no device. It downloads 12 fixed previews to temporary storage, analyzes them, deletes them, and fails below 10 of 12. Normal tests never use the network.

~~~sh
swift run --package-path Packages/SlipstreamKit TempoCorpusValidator \
  --output Evidence/Audio/YYYY-MM-DD-tempo-corpus-validation.json
~~~

Older procedures and device records are in [DEVICE-HISTORY.md](Archive/DEVICE-HISTORY.md).

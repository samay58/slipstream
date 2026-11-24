# Current status

Last checked on 2026-11-05. The code rename to Slipstream on 2026-11-24 is the one later change noted here.

The app is one good walk short of knowing whether its August repairs and its November design work hold up. The phone has version 1.3, build 8, recorded in `Evidence/Device/2026-11-05-install-1.3/`, and it already shows the name Slipstream. The code, project, and package took the name on 2026-11-24, after that install. The signing profile runs until 2027-11-05.

Everything from November is installed and none of it has been walked or run on. That covers the sweep that fixed recovery dead ends and several timing bugs, the design refresh of setup and the run screens with a Liquid Glass tempo wheel drawn as a speaker, and the November 5 color pass and rename. An unfinished 10-minute run from October 26 was pulled from the phone and has not been read yet. The next step is one walk.

## Product state

| Area | Current truth | Proof |
| --- | --- | --- |
| Music source | Apple Music is the only production player | Authorization, catalog access, preview decoding, playback, and rate writes passed on iPhone |
| Music import | One playlist can be selected, analyzed on the phone, restored, retried, and filtered to ready tracks. Library songs resolve through their own catalog identifier first. When an explicit and a clean version tie, the app picks the edit that is in the playlist | Automated tests, Simulator frames, and an earlier phone import. The tie fix is not yet proved on the phone |
| Tempo analysis | Version 5 keeps musical BPM separate from the step relationship and judges each tempo against its half and double, so swung and dotted grooves keep their true beat | 12 of 12 public preview references, deterministic tests, and a 138-song read of the phone's cache |
| Motion | Steady readings from 90 through 210 SPM are accepted. Walking needs five seconds of steady evidence, and running can settle once the motion filter locks. Broken movement such as lifting builds no target | Saved phone replay, stale-data rejection tests, and one attributed workout |
| Auto | A responsive sensor estimate feeds a separate, calm musical target. Raw cadence cannot change the music before that target settles | Noise, spike, faster, slower, missing-input, and walking tests |
| Manual | Manual stays with the confirmed song and returns to Auto once a different song is confirmed | Reducer, app-model, and interface tests |
| Playback range | The software allows 0.85 through 1.15 of normal speed. An automatic change ramps by at most two percentage points per second, so normal speed reaches either end in at most eight seconds. Only 0.90 and 1.10 have been heard | Shared limits and endpoint tests. Listening at 0.85 and 1.15 is open, and clean sound there needs Samay's approval |
| Tempo wheel | A speaker driver under a clear glass lens. The cone and center cap push forward at the music's current tempo while the surround stays still. The pulse does not line up with individual beats, because analysis measures tempo and not beat positions. The cap turns lime once the tempo has matched. A quiet close action has its own 44-point target | Interface tests and inspected Simulator frames |
| Color and appearance | Phoenix Workbench lime and lilac on paper or near-black. Setup, recovery, and the summary follow the system appearance, and the run screens are always dark. `Scripts/render-icon.py` draws the icon, a lilac sphere on lime lines, which Samay approved on his phone. Lime in sun is unjudged | `PaletteContrastTests`, direct drawing of 16 screens in both appearances, and Simulator frames in `Evidence/Simulator/2026-11-05-color-refresh/` |
| Transport and Finish | Previous, Pause or Resume, and Next are three interactive Liquid Glass circles, with the primary larger and tinted. Finish is a quiet button below them that arms a hold drawn inside its own capsule | Serial interface tests, two of which fail if Pause or Finish moves when it changes state, and the sheets in `Evidence/Simulator/2026-11-05-color-refresh/`. Feel on the phone is open |
| Reading a playlist | Each song read draws one contour line shaped by its measured tempo and plucks the progress string. The field's color rises with the count of songs read, and the song, tempo, and count pass in one centered stack | Unit tests for the map and the warmth, interface tests, and inspected Simulator frames and video. The test read an invented playlist one song at a time, so real import pacing and frame rate on a phone are open |
| Auto feedback | The reducer owns one directional transaction per meaningful Auto change. Three prototype haptic families, six arrival sounds, and a hidden audition screen exist, and every cue reports what became of it. No family has been chosen | Domain, app-model, and asset tests. Nothing about feel, sound against real music, or locked-screen delivery is physically proved |
| Song crossfade | Songs change through Apple Music's built-in crossfade, set to four seconds. It softens the break without aligning beats | Compiles against the SDK. No software test can hear it, and nobody has heard it on a phone |
| Song boundaries | In the last 45 seconds of a song, the reducer judges the queued next song against the settled target and prepares one better fit when the queued song cannot follow | Reducer tests. Not yet seen at a real boundary on the phone |
| Reach | When fewer than a quarter of the ready songs can reach the settled target for twenty seconds, the run screen says so once per run per direction | Reducer tests and direct drawing in every environment |
| Recovery | Each audio recovery names its cause: headphones, an interruption, or Apple Music failing. Only the matching event clears it, and every recovery can end the run | Reducer tests, an interface test, and an inspected Simulator frame. Not yet seen on the phone |
| Run record | Each run is one file that only grows. It holds every input, every state change, pedometer steps, distance, and pace, and the phone's conditions. The phone keeps the newest 60, and `phone.sh pull` keeps every run on the Mac with a ledger across runs. `RunReplay` puts any recorded run through today's logic | Store, replay, and long-run tests, and a recorded Simulator run that replayed with no differences. No walk has been recorded in this form yet |
| Song-change cause | Every confirmed song change records a natural end, an outside change, or an explicit Previous or Next | Attribution tests and the Debug row `Last song change` |
| Release isolation | Neither the hidden Debug screen nor the audition screen ships in Release | Release binary strings and symbol counts |

## What the phone has proved

The August 17 workout came from an exact-profile build with a matching source fingerprint. Delayed cadence readings acquired 133 SPM, and Apple Music reported the requested rate of 1.0390625 after 0.066 seconds. Most retained movement readings sat in the brisk-walking range, below the 120 SPM floor the app had then. Samay felt Auto changing the music, and the changes felt jarring and unexplained. The workout mixed walking, light jogging, and lifting, so it cannot tune walking.

The August 19 brisk walk lasted 441 seconds at an average of 113 SPM on the analyzer version 5 build. Auto settled once and wrote 0.90. A natural boundary landed on a 163.75 BPM song the walk could not reach. Only 7 of 41 ready songs can reach a walking cadence inside the rate window, so Auto held the floor for most of the walk. Samay felt perhaps one haptic and could not tell when a change happened. The analysis is in `Evidence/Device/2026-08-19-walk-easy-miles/`.

That walk exposed four software gaps: a lossy record, no proof that cues played, no look-ahead at song boundaries, and silence about a playlist out of reach. Commit `0aa99a7` repaired all four, recorded in `Evidence/Device/2026-08-19-walk-repair-install/`.

## Software gate

Run `./Scripts/gate.sh`. [TESTING.md](TESTING.md) records the latest result.

## Still open

Each of these needs a body, an ear, or real Apple Music. [PHONE.md](PHONE.md) puts them in order.

- Walk Easy Miles on this build for at least ten minutes, pocketed and partly locked, then pull and read the record.
- Hear 0.85 and 1.15 through headphones for a full musical section, and read back what Apple Music reports.
- Judge transport and Finish by hand.
- Run the blinded faster and slower trials for all three haptic families on both sound paths.
- Judge the glass and the speaker's pulse on a real screen and measure frame rate there, because the Simulator only approximates glass and its drawing costs differ from a phone's.
- Hear the crossfade at a natural song change, and confirm `Last song change` after a natural end and after an explicit Next.
- Check screen lock, an interruption, and route recovery.
- Run a clean walking-only check that also shows lifting does not move the music. The 90 SPM floor and the five-second delay are software choices, not tuned constants.
- Complete one 20-minute outdoor run.

[PROGRESS.md](PROGRESS.md) holds implementation history, [DECISIONS.md](DECISIONS.md) holds product choices, and [TESTING.md](TESTING.md) holds exact checks and the limits of what they prove.

# Development

The Mac Mini is the main development machine. It has the disk for current Xcode, several Simulator runtimes, and heavy tools, and it stays on. A laptop with Xcode installed can do the same work from its own checkout, so nothing here depends on one machine. GitHub `main` is the source of truth. Push before changing machines, and pull when you arrive.

## Names

Everything in the repository is called Slipstream: the project `Slipstream.xcodeproj` and its scheme, the package `Packages/SlipstreamKit/` with its four modules, the test targets, the `-SLIPSTREAM_*` launch arguments, and the `SLIPSTREAM_*` environment variables. The app was first called Samadhi, and three things keep that name on purpose:

- The bundle identifier `com.samaydhawan.Samadhi`
- The phone's data folder, `Application Support/Samadhi`, set once in `App/PhoneDataFolder.swift`
- The provisioning profile named Samadhi Development, which Apple issued for that identifier

The phone holds the only copy of the selected playlist and its analysis. A new identifier would install as a different app, and a new folder name would leave that data behind, so never rename either. Records in `Docs/Archive/` and `Evidence/` predate the rename and use the old paths.

## Setting up a Mac

1. Install Xcode and XcodeGen. Keep one current Simulator runtime with an iPhone 17 Pro. The scripts create that Simulator if the runtime is present.
2. Select the Xcode to use with `sudo xcode-select -s /Applications/Xcode.app`, and run `sudo DevToolsSecurity -enable` once. Without it, the test host launches frozen and `xcodebuild test` hangs with no error, waiting for an authorization nobody can see.
3. Clone the repository and run `./Scripts/bootstrap.sh`.
4. Run `./Scripts/gate.sh`. A pass means this Mac can do everything short of the phone.
5. For phone work, install the exact provisioning profile and pair the phone, as [PHONE.md](PHONE.md) describes. Never copy certificates, Derived Data, or Simulator contents between Macs.

The scripts use `DEVELOPER_DIR` if it is set, and otherwise the Xcode chosen with `xcode-select`. Do not run Simulator commands under two Xcode versions at once. Doing so restarts the shared Simulator service and can kill a running test.

## The loop

Slipstream improves in widening rings, from logic out to the phone. Stay in the innermost ring that can answer the question, and move outward only when it cannot.

| Ring | Question it answers | Command | Time |
| --- | --- | --- | --- |
| Changes | What can my edits have broken? | `./Scripts/check.sh` runs only the tests they can affect | Seconds to a minute |
| Logic | Does the reducer, filter, or analyzer behave? | `swift test --package-path Packages/SlipstreamKit` | Seconds |
| Look | Does it read right in every environment? | `./Scripts/sim.sh matrix <name> [args]` | About a minute |
| Motion | Does the interaction hold up frame by frame? | `./Scripts/sim.sh frames <test>` or `record <name> <seconds>` | Minutes |
| Gate | Is it ready for a phone? | `./Scripts/gate.sh` | About 4 minutes, and instant if nothing that affects it changed |
| Phone | Does it feel right on a body? | `./Scripts/phone.sh install`, then `pull` after moving | A walk |

### Which test goes where

Most interface behavior belongs in `Tests/SlipstreamTests/ScreenRenderingTests.swift`. Those tests draw a screen directly from its state, so they read real positions, labels, and button actions in a fraction of a second. Their environments apply, including the largest text size.

`Tests/SlipstreamUITests/` holds what direct drawing cannot prove: real touch, gestures such as the wheel, sheets, and the whole app wired together. These tests launch the app, so each takes about 10 seconds. They run on four Simulator clones, and Xcode splits the work by test class, so keep the classes roughly equal in running time.

GitHub runs an older compiler than this Mac, so a long math expression can pass here and fail there. `check.sh` catches these by failing on any expression that takes longer than 500 milliseconds to type-check. Give each step one explicit type.

### Logic

Write the failing reducer test first. The core is pure, so most behavior can be proved here without a Simulator. `swift test --filter "BoundaryLookAhead|Reach"` narrows the run to one area.

### Look

`./Scripts/sim.sh flags` lists the launch arguments that put the app into a known state. This one shows the partial import screen in all six environments on one contact sheet:

~~~sh
./Scripts/sim.sh matrix setup-partial -SLIPSTREAM_FAST_MODE -SLIPSTREAM_MUSIC_PARTIAL
~~~

The six environments are default, dark, accessibility XXXL, Reduce Motion, Increased Contrast, and Reduced Transparency. The Simulator cannot change those system settings from a launch argument, so the Reduce Motion and Increased Contrast arguments set the app's design overrides directly. Reduced Transparency has no such override yet. Open the sheet and read it. An agent must inspect the image before claiming a visual result.

### Motion

UI tests in `Tests/SlipstreamUITests/` drive states that take interaction to reach, and they attach frames. To export them:

~~~sh
./Scripts/sim.sh frames testTransportAndFinishAfterStateEvidence
~~~

For a press, a hold, or a transition, `./Scripts/sim.sh record finish-hold 6` records video and splits it into frames at 30 per second. A running UI test stalls the capture, so record motion without one where you can. Launching with `-SLIPSTREAM_FAST_MODE` plus `-SLIPSTREAM_MUSIC_READING_DEMO` starts reading a playlist on its own, and `-SLIPSTREAM_RUN_DEMO` starts a run on its own. The August overflow in Finish showed up only this way.

### Phone

The phone answers what nothing else can: cadence, sound, touch, and locked-screen behavior. Keep these sessions short and specific. [PHONE.md](PHONE.md) holds the setup, the ordered checks, and how to read a run.

~~~sh
./Scripts/phone.sh status     # Is it reachable, and is signing ready?
./Scripts/phone.sh install    # Exact profile, verified signature, in-place install
# Walk or run.
./Scripts/phone.sh pull       # Keeps every new run, prints the latest and the ledger across runs
~~~

The printed summary answers what a walk leaves behind: which build ran, what became of each cue, and why each song changed. To test a change to Auto against real walks, run `swift run --package-path Packages/SlipstreamKit RunReplay <file.jsonl>` on any kept run.

### Recording what was learned

Raw captures stay in `Evidence/Temp/`, which Git ignores. Commit a dated folder with a short README and at most five frames or one contact sheet, as [Evidence/README.md](../Evidence/README.md) describes. Update [STATUS.md](STATUS.md) when a claim changes.

## Agent tools

Start Claude Code or Codex from the repository folder. A session started anywhere else loads neither `AGENTS.md` nor `.mcp.json`, so it works without the Xcode tools.

`.mcp.json` registers Xcode's own agent service. Its 54 tools let an agent build, test, read console output, render a SwiftUI preview (`RenderPreview`), and synthesize taps (`DeviceInteractionSynthesize`) without an open Xcode window. It needs Xcode 27.2 or later and one setup step with `sudo`:

~~~sh
sudo xcrun mcp-server enable
xcrun mcp-server open Slipstream.xcodeproj
~~~

The first agent call raises a permission prompt on the Mac's screen. Choose Always Allow. Everything else in the loop works without this service.

Previews in `Packages/SlipstreamKit/Sources/SlipstreamDesign/SlipstreamPreviews.swift` cover the screen states, so a rendered preview is the fastest visual check when no launch argument reaches a state.

## Keeping the machine lean

Build products from the scripts live in `.build/xcode/`, which Git ignores and which is safe to delete. `Evidence/Temp/` is scratch space and is also safe to clear once a result is committed.

## Boundaries

- A Simulator pass never proves MusicKit, cadence, listening quality, haptics, or background behavior.
- Never uninstall the app from the phone. It holds the only copy of the selected collection and its analysis cache.
- Do not claim a physical install until the signed build, application identifier, install result, and launch have been read back.

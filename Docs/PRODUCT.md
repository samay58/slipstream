# Slipstream

Slipstream is a native iPhone music player for running. It senses the runner's cadence and matches each song's tempo to it, so the music carries the stride instead of fighting it. The tagline is "music in stride."

## Promise

Movement and music should feel like one calm system. The runner opens the app, presses Start, and begins moving. The music finds their rhythm, and the interface confirms the match and then gets out of the way.

What the app should create is absorbed attention, steady motion, and less self-consciousness. Success is not more workout data. It is a runner who forgets the app because they are inside the music.

That means:

- A fast arrival into rhythm
- A stable feel even when body data is noisy
- Confidence without a constant stream of metrics
- Attention that stays on the music
- Safe, honest recovery when sensing or audio fails

## The first milestone

The first real product milestone is done when Samay can go for a normal outdoor run with one imported Apple Music playlist, hear an unmistakable response when his rhythm changes, and feel his stride settle onto the music without thinking about the app.

Done means the app can:

- Import one Apple Music playlist
- Analyze enough tracks on the phone to build a usable queue
- Start a run in one or two clear actions
- Sense cadence from one declared phone placement
- Choose a track whose native pulse fits the requested rhythm
- Correct playback rate finely inside a declared range that passes physical listening
- Let the runner set a manual BPM without leaving the run
- Make a deliberate rhythm change audible enough to verify without watching a number
- Keep audio stable, pitch-stable, and continuous through lock, pause, resume, and route recovery
- Show honest progress and a tempo-matched summary
- Keep failure states calm, legible, and recoverable
- Pass one 20-minute outdoor run with listening notes and saved evidence

It does not mean perfect recommendations, a beat-lock claim without phase evidence, support for every music source, run history, GPS fitness tracking, social features, or a polished App Store business. The first milestone earns the right to exist by making one real run feel better. A feature that does not improve that run, lower its risk, or make the app easier to trust during it waits.

The live checklist toward this milestone is in [PLAN.md](PLAN.md), and what the phone has proved so far is in [STATUS.md](STATUS.md).

## Product laws

### One action before motion

A returning runner starts with one deliberate action.

### Music first

Cadence is an input, not the content. The song, its atmosphere, and its rhythm outrank telemetry.

### Confirm, then withdraw

The interface shows itself during preparation, during uncertainty, and while the runner is touching a control. Stable playback should feel quiet.

### Understandable without looking

An automatic music change has to make sense when the phone is locked or in a pocket, so it cannot depend on text that flashes on screen. Sparse touch and sound mark only meaningful, verified changes, and then attention returns to the music.

### Control without clutter

Automatic matching is the default. When it feels wrong, the runner can reveal one precise rhythm control, correct it, and go back to the music. Manual control never grows into a settings screen or a permanent telemetry panel.

### Continuity over spectacle

Objects transform in place, and motion explains a change of state. No transition competes with the music.

### Stability over responsiveness theater

Raw sensor changes never drive a frantic interface. The app stays composed when its input is noisy.

### Honest capability

The app never implies beat-perfect adaptation, real cadence quality, or audio quality before physical proof exists.

### No Slipstream backend

There is no Slipstream account, cloud backend, remote listening history, analytics SDK, ad identifier, or model call. The app reaches a music provider only when the runner selects one. Tempo analysis and everything Slipstream saves stay on the phone.

### No product inflation

There is no dashboard, map, coaching layer, streak, social surface, recommendation feed, or tab bar. The central interaction has to carry the product.

## What stays out

Core Motion and the Apple Music player run in the normal flow whenever an imported collection has ready tracks. Spotify, GPS, maps, pace, distance, lifting adaptation, coaching, plans, social features, accounts, analytics, subscriptions, and any backend stay out of the product build.

## Name and look

### The name

A slipstream is the pocket of moving air behind a runner or rider that pulls them along with almost no effort. That is how the app should feel: you run in the music's slipstream. The word also holds "stream," and it names flow without naming meditation. "In step" is a lowercase run metric, not a second brand.

The app was first called Samadhi. The code, the project, and the repository now say Slipstream, and three things keep the old name on purpose. They are the bundle identifier `com.samaydhawan.Samadhi`, the phone's data folder `Application Support/Samadhi` (one constant in `App/PhoneDataFolder.swift`), and the provisioning profile named Samadhi Development. The phone holds the only copy of the selected playlist and its analysis, and changing the identifier or the folder would strand that data. Older records in `Docs/Archive/` and `Evidence/` use Samadhi for the same product.

### Character

The app is tactile, restrained, native, and at home in the dark. Depth signals hierarchy and is never decoration.

- One visual owner at a time
- Open typography instead of passive cards
- Glass only for raised interactive controls
- A full-screen atmosphere that supports the music's identity
- Motion frozen or reduced when the tempo wheel owns attention
- Readable text across the palette, Dynamic Type, high contrast, and Reduce Motion

The products that set the craft bar are reviewed in [DESIGN-BENCHMARKS.md](Research/DESIGN-BENCHMARKS.md).

### Color

Two hues come from Phoenix Workbench, and each one means something.

- Lime `#D8F24C` means go and live. It fills the primary action and marks the music following the runner: the wheel's center cap, the progress arc, and the word Auto.
- Lilac means the runner took over. It marks Manual and the hold that ends a run. It is `#6E5C9E` on paper and on the hold's fill, and `#B8A9E8` on the dark ground. In the icon and the mark the lilac sphere is identity and carries no state.
- Moss `#566400` replaces lime on any thin line in light mode, because lime on paper has a contrast of about 1.1 to 1. On paper, lime only ever appears as a fill with dark text on it.
- The neutrals are Workbench paper `#F4F0E7` with ink `#15170F`, and near-black `#0B0D08` with ink `#F2F1E6`. Both lean slightly green so they agree with the lime.

There is no orange, apricot, clay, plum, or olive anywhere. `PaletteContrastTests` holds every text and line pairing to 4.5 to 1.

### Dark mode

Setup, recovery, and the summary follow the system appearance. The run screens are always dark, like Apple's Workout app, because lime on black reads at arm's length in sun and the glass has more to bend. `SlipstreamColor` names colors by role, so a new screen gets both appearances without extra work.

Behind every screen sits a field of two soft radial lights over the ground, lime low on the left and lilac high on the right, under a still layer of faint noise. The app draws them together at high precision, so the noise lands before the colors are rounded to the display's 8 bits. That is true dithering, and it removes the banding that dark gradients otherwise show.

### App icon

The icon is a polished lilac sphere on a full field of lime, with bold lines of air parting around it and swaying behind it. Lilac and lime are the two brand colors, and the lime field is the loudest thing on a Home Screen. The lines are real flow past a sphere, which makes it a literal slipstream, and the wake's left and right sway is the rhythm of a stride.

`Scripts/render-icon.py` draws all three versions from code, so a change is a number and a rerun, and no image model is involved. Light is ink on lime, dark is lime on near-black, and tinted is a grayscale of the light version. Samay approved it on his phone on 2026-11-05. Every earlier direction is in `Evidence/Brand/`.

### In-app mark

`BrandMark` reduces the icon to one lilac sphere with four bold lines streaming behind it, drawn natively so it stays sharp at 38 points. The lines are lime in dark mode and ink in light mode. Nothing sits ahead of the sphere, because lines wrapped around it read as an eye.

### The playlist map

The signature of the interface is the map a playlist draws of itself. Each song the app reads draws one contour line whose ripple comes from its measured tempo, and the progress line is a string the same songs pluck. The map stays thin and in the field's own colors. It frames the playlist name and never crosses it.

### The speaker

The tempo wheel is a speaker driver seen head on, under a clear glass lens, with a low light beneath it. It has thin ribs, one domed center cap, and no photo-real detail. It is drawn in the field's own ink so the field stays visible through it, and it pulses only at the music's current tempo. The cap turns lime only once the tempo has matched, so the one bright thing on the screen means something.

### Repository cover

`Brand/GitHub-Cover.png` shows the mark, the name, and the tagline over a contour map in the dark palette. The contour tempos in it are illustrative.

## Glossary

Product, code, tests, and evidence use these terms the same way.

| Term | Meaning |
| --- | --- |
| Cadence | The runner's stable steps per minute. The app senses it from movement and keeps it separate from any requested musical rhythm. |
| Requested musical BPM | The rhythm Slipstream is trying to produce. In Auto it comes from stable cadence. In Manual it comes straight from the runner. |
| Native pulse | One plausible half-time, full-time, or double-time reading of a track's analyzed tempo. A track can have more than one useful reading, but only one drives a given match. |
| Track fit | How little a track has to be stretched to reach the requested musical BPM inside the quality envelope. Good track fit is the coarse layer of adaptation. |
| Tempo match | Music and cadence share the same frequency within the documented tolerance. It says nothing about a beat and a footfall landing at the same instant. |
| Beat lock | The music's beat positions and the runner's footfalls line up. Slipstream must measure end-to-end phase and latency before it makes this claim. |
| Felt synchronization | The runner hears the tempo respond and settles their steps onto the music without trying. This is the product outcome. Tempo match is evidence toward it and never a substitute. |
| Quality envelope | The playback-rate range that passed physical listening on the supported player and audio route. A successful rate write does not widen it. |
| Auto follows | Slipstream follows reliable cadence, ignores sensor noise, chooses compatible music, and makes restrained corrections. |
| Manual leads | The runner declares a musical BPM. Slipstream chooses compatible music and applies bounded correction without inventing a measured cadence. |

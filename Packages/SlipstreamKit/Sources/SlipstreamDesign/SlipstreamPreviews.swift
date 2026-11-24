import SlipstreamDomain
import SwiftUI

private let previewSend: @MainActor (RunAction) -> Void = { _ in }

#Preview("Ready, demo pack") {
    SlipstreamScreen(state: RunViewState(phase: .ready), send: previewSend)
}

#Preview("Ready, choose music") {
    SlipstreamScreen(
        state: RunViewState(phase: .ready, musicSelection: .none),
        send: previewSend
    )
}

#Preview("Ready, loading playlists") {
    SlipstreamScreen(
        state: RunViewState(
            phase: .ready,
            musicSelection: .loadingPlaylists(current: nil)
        ),
        send: previewSend
    )
}

#Preview("Ready, analyzing music") {
    SlipstreamScreen(
        state: RunViewState(
            phase: .ready,
            musicSelection: .analyzing(
                ImportedCollectionPresentation(
                    name: "City Pocket",
                    totalTrackCount: 8,
                    readyTrackCount: 1,
                    completedTrackCount: 2,
                    tracks: [
                        ImportedTrackPresentation(
                            id: "one",
                            title: "Soft Current",
                            status: .ready
                        ),
                        ImportedTrackPresentation(
                            id: "two",
                            title: "Afterimage",
                            status: .rhythmUnclear
                        ),
                    ]
                )
            )
        ),
        send: previewSend
    )
}

#Preview("Ready, partially analyzed") {
    SlipstreamScreen(
        state: RunViewState(
            phase: .ready,
            musicSelection: .ready(
                ImportedCollectionPresentation(
                    name: "City Pocket",
                    totalTrackCount: 3,
                    readyTrackCount: 1,
                    completedTrackCount: 3,
                    tracks: [
                        ImportedTrackPresentation(
                            id: "one",
                            title: "Soft Current",
                            status: .ready
                        ),
                        ImportedTrackPresentation(
                            id: "two",
                            title: "Afterimage",
                            status: .rhythmUnclear
                        ),
                        ImportedTrackPresentation(
                            id: "three",
                            title: "Quiet Arcade",
                            status: .catalogMatchUnavailable
                        ),
                    ]
                )
            )
        ),
        send: previewSend
    )
}

#Preview("Ready, music failure") {
    SlipstreamScreen(
        state: RunViewState(
            phase: .ready,
            musicSelection: .failed(.importFailed(name: "City Pocket"))
        ),
        send: previewSend
    )
}

#Preview("Ready, authorization failure") {
    SlipstreamScreen(
        state: RunViewState(
            phase: .ready,
            musicSelection: .failed(.authorizationDenied)
        ),
        send: previewSend
    )
}

#Preview("Ready, accessibility text") {
    SlipstreamScreen(
        state: RunViewState(
            phase: .ready,
            musicSelection: .ready(
                ImportedCollectionPresentation(
                    name: "The Streetlights Kept Time All the Way Home",
                    totalTrackCount: 6,
                    readyTrackCount: 1,
                    completedTrackCount: 6,
                    tracks: [
                        ImportedTrackPresentation(id: "one", title: "Soft Current", status: .ready),
                        ImportedTrackPresentation(id: "two", title: "Afterimage", status: .rhythmUnclear),
                    ]
                )
            )
        ),
        send: previewSend
    )
    .environment(\.dynamicTypeSize, .accessibility5)
}

#Preview("Start transformation") {
    SlipstreamScreen(state: RunViewState(phase: .preparing), send: previewSend)
}

#Preview("Listening for stride") {
    SlipstreamScreen(state: RunViewState(phase: .acquiring), send: previewSend)
}

#Preview("Locked, low cadence") {
    SlipstreamScreen(state: RunViewState(phase: .running, cadenceSPM: 142, showLockBrief: true), send: previewSend)
}

#Preview("Locked, high cadence") {
    SlipstreamScreen(state: RunViewState(phase: .running, cadenceSPM: 194), send: previewSend)
}

#Preview("Playlist out of reach") {
    SlipstreamScreen(
        state: RunViewState(phase: .running, cadenceSPM: 112, reachNotice: .mostlyFaster),
        send: previewSend
    )
}

#Preview("Tempo control, Auto") {
    SlipstreamScreen(
        state: RunViewState(
            phase: .running,
            cadenceSPM: 168,
            trackElapsedSeconds: 91,
            trackProgress: 0.43,
            rhythmControl: RhythmControlPresentation(
                mode: .automatic,
                requestedBPM: 168,
                appliedBPM: 167,
                isVisible: true
            )
        ),
        send: previewSend
    )
}

#Preview("Tempo control, fine tune") {
    SlipstreamScreen(
        state: RunViewState(
            phase: .running,
            cadenceSPM: 168,
            trackElapsedSeconds: 91,
            trackProgress: 0.43,
            rhythmControl: RhythmControlPresentation(
                mode: .automatic,
                automaticCorrectionBPM: 3,
                requestedBPM: 171,
                appliedBPM: 169,
                isVisible: true
            )
        ),
        send: previewSend
    )
}

#Preview("Tempo control, Manual") {
    SlipstreamScreen(
        state: RunViewState(
            phase: .running,
            cadenceSPM: 168,
            trackElapsedSeconds: 91,
            trackProgress: 0.43,
            rhythmControl: RhythmControlPresentation(
                mode: .manual,
                manualTargetBPM: 176,
                requestedBPM: 176,
                appliedBPM: 174,
                isVisible: true
            )
        ),
        send: previewSend
    )
}

#Preview("Tempo control, safety limit") {
    SlipstreamScreen(
        state: RunViewState(
            phase: .running,
            cadenceSPM: 168,
            trackElapsedSeconds: 91,
            trackProgress: 0.43,
            rhythmControl: RhythmControlPresentation(
                mode: .manual,
                manualTargetBPM: 200,
                requestedBPM: 200,
                appliedBPM: 170,
                isAtLimit: true,
                isVisible: true
            )
        ),
        send: previewSend
    )
}

#Preview("Controls visible") {
    SlipstreamScreen(
        state: RunViewState(
            phase: .running, controlsVisible: true, cadenceSPM: 168, trackElapsedSeconds: 91,
            trackProgress: 0.43), send: previewSend)
}

#Preview("Paused") {
    SlipstreamScreen(
        state: RunViewState(
            phase: .paused, controlsVisible: true, cadenceSPM: 168, trackElapsedSeconds: 91,
            trackProgress: 0.43), send: previewSend)
}

#Preview("Finish confirmation") {
    SlipstreamScreen(
        state: RunViewState(
            phase: .confirmingFinish, cadenceSPM: 168, trackElapsedSeconds: 91, trackProgress: 0.43
        ), send: previewSend)
}

#Preview("Finish holding") {
    SlipstreamScreen(
        state: RunViewState(
            phase: .confirmingFinish,
            cadenceSPM: 168,
            trackElapsedSeconds: 91,
            trackProgress: 0.43,
            finishHoldPressing: true
        ),
        send: previewSend
    )
}

#Preview("Finish confirmation, accessibility text") {
    SlipstreamScreen(
        state: RunViewState(
            phase: .confirmingFinish,
            cadenceSPM: 168,
            trackElapsedSeconds: 91,
            trackProgress: 0.43
        ),
        send: previewSend
    )
    .environment(\.dynamicTypeSize, .accessibility5)
}

#Preview("Transport, accessibility text") {
    SlipstreamScreen(
        state: RunViewState(
            phase: .running,
            controlsVisible: true,
            cadenceSPM: 168,
            trackElapsedSeconds: 91,
            trackProgress: 0.43
        ),
        send: previewSend
    )
    .environment(\.dynamicTypeSize, .accessibility5)
}

#Preview("Headphones disconnected") {
    SlipstreamScreen(state: RunViewState(phase: .routeRecovery(cause: .routeLost, restored: false)), send: previewSend)
}

#Preview("Route restored") {
    SlipstreamScreen(state: RunViewState(phase: .routeRecovery(cause: .routeLost, restored: true)), send: previewSend)
}

#Preview("Motion permission denied") {
    SlipstreamScreen(state: RunViewState(phase: .permissionRecovery), send: previewSend)
}

#Preview("Summary") {
    SlipstreamScreen(
        state: RunViewState(
            phase: .summary(
                RunSummary(durationSeconds: 1938, averageCadence: 171, tempoMatchedPercent: 84, songCount: 4)
            )
        ),
        send: previewSend
    )
}

#Preview("Reduce Motion, acquiring") {
    SlipstreamScreen(state: RunViewState(phase: .acquiring, forceReduceMotion: true), send: previewSend)
}

#Preview("Accessibility text") {
    SlipstreamScreen(
        state: RunViewState(
            phase: .running,
            cadenceSPM: 168,
            rhythmControl: RhythmControlPresentation(
                mode: .manual,
                manualTargetBPM: 176,
                requestedBPM: 176,
                appliedBPM: 174,
                isVisible: true
            )
        ),
        send: previewSend
    )
    .environment(\.dynamicTypeSize, .accessibility5)
}

#Preview("High contrast") {
    SlipstreamScreen(
        state: RunViewState(phase: .running, controlsVisible: true, cadenceSPM: 168, forceIncreasedContrast: true),
        send: previewSend)
}

#Preview("Long metadata") {
    SlipstreamScreen(
        state: RunViewState(
            phase: .running,
            controlsVisible: true,
            cadenceSPM: 168,
            track: TrackMetadata(
                title: "The Streetlights Kept Time All the Way Home",
                artist: "A Particularly Long Artist Name and the Night Windows"
            )
        ),
        send: previewSend
    )
}

#Preview("Missing artwork") {
    SlipstreamScreen(state: RunViewState(phase: .ready, hasArtwork: false), send: previewSend)
}

#Preview("Dark, ready") {
    SlipstreamScreen(state: RunViewState(phase: .ready), send: { _ in })
        .preferredColorScheme(.dark)
}

#Preview("Dark, reading") {
    SlipstreamScreen(
        state: RunViewState(
            phase: .ready,
            musicSelection: .analyzing(
                ImportedCollectionPresentation(
                    name: "Morning Miles",
                    totalTrackCount: 18,
                    readyTrackCount: 9,
                    completedTrackCount: 9,
                    tracks: []
                )
            )
        ),
        send: { _ in }
    )
    .preferredColorScheme(.dark)
}

#Preview("Dark, summary") {
    SlipstreamScreen(
        state: RunViewState(
            phase: .summary(
                RunSummary(durationSeconds: 1843, averageCadence: 168, tempoMatchedPercent: 86, songCount: 7)
            )
        ),
        send: { _ in }
    )
    .preferredColorScheme(.dark)
}

#Preview("Dark, recovery") {
    SlipstreamScreen(
        state: RunViewState(phase: .routeRecovery(cause: .routeLost, restored: true)),
        send: { _ in }
    )
    .preferredColorScheme(.dark)
}

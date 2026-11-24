// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SlipstreamKit",
    platforms: [.iOS(.v26), .macOS(.v26)],
    products: [
        .library(name: "SlipstreamDomain", targets: ["SlipstreamDomain"]),
        .library(name: "SlipstreamMotion", targets: ["SlipstreamMotion"]),
        .library(name: "SlipstreamAudio", targets: ["SlipstreamAudio"]),
        .library(name: "SlipstreamDesign", targets: ["SlipstreamDesign"]),
    ],
    targets: [
        .target(name: "SlipstreamDomain"),
        .target(name: "SlipstreamMotion", dependencies: ["SlipstreamDomain"]),
        .target(name: "SlipstreamAudio", dependencies: ["SlipstreamDomain"]),
        .target(name: "SlipstreamDesign", dependencies: ["SlipstreamDomain"]),
        .executableTarget(
            name: "TempoCorpusValidator",
            dependencies: ["SlipstreamAudio", "SlipstreamDomain"],
            path: "Tools/TempoCorpusValidator",
            resources: [.process("Corpus.json")]
        ),
        .executableTarget(
            name: "RunReplay",
            dependencies: ["SlipstreamDomain"],
            path: "Tools/RunReplay"
        ),
        .executableTarget(
            name: "TempoProbe",
            dependencies: ["SlipstreamAudio", "SlipstreamDomain"],
            path: "Tools/TempoProbe"
        ),
        .testTarget(name: "SlipstreamDomainTests", dependencies: ["SlipstreamDomain"]),
        .testTarget(name: "SlipstreamAudioTests", dependencies: ["SlipstreamAudio", "SlipstreamDomain"]),
        .testTarget(name: "SlipstreamMotionTests", dependencies: ["SlipstreamMotion"]),
        .testTarget(name: "SlipstreamDesignTests", dependencies: ["SlipstreamDesign"]),
    ]
)

// swift-tools-version: 6.0
import Foundation
import PackageDescription

// The linker copies the sound into the binary, so the tool is a single
// self-contained file — the modern equivalent of the 'snd ' resource.
let packageRoot = URL(fileURLWithPath: #filePath).deletingLastPathComponent().path

let package = Package(
    name: "hallelujah",
    platforms: [.macOS(.v15)],
    targets: [
        .executableTarget(
            name: "hallelujah",
            linkerSettings: [
                .unsafeFlags([
                    "-Xlinker", "-sectcreate",
                    "-Xlinker", "__TEXT",
                    "-Xlinker", "__hallelujah",
                    "-Xlinker", "\(packageRoot)/Hallelujah.aiff",
                ])
            ]
        )
    ]
)

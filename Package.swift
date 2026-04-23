// swift-tools-version: 5.10
import PackageDescription

// Updated by scripts/package_binary_artifact.sh during release preparation.
let truliooArtifactURL = "https://github.com/Trulioo/trulioo-ios/releases/download/v3.0.0-beta.0/Trulioo.xcframework.zip"
let truliooArtifactChecksum = "d28a726e57c3bb7bd87915473e48db14564e92ef2f9320aa550154e461d79bec"
let truliooCoreArtifactURL = "https://github.com/Trulioo/trulioo-ios/releases/download/v3.0.0-beta.0/TruliooCore.xcframework.zip"
let truliooCoreArtifactChecksum = "2b6e5b18f9389aafe69152430faccb247a06315b1b9b95213786e5c5c69e2a5c"

let package = Package(
    name: "Trulioo",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "Trulioo",
            targets: ["Trulioo", "TruliooCore"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "Trulioo",
            url: truliooArtifactURL,
            checksum: truliooArtifactChecksum
        ),
        .binaryTarget(
            name: "TruliooCore",
            url: truliooCoreArtifactURL,
            checksum: truliooCoreArtifactChecksum
        ),
    ]
)

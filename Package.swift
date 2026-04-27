// swift-tools-version: 5.10
import PackageDescription

// Updated by scripts/package_binary_artifact.sh during release preparation.
let truliooArtifactURL = "https://github.com/Trulioo/trulioo-ios/releases/download/3.0.0-beta.2/Trulioo.xcframework.zip"
let truliooArtifactChecksum = "4d9a1209ef5d2c4b0a4c751cc5464c1b17d03554bcc0161c9e328c0237902f14"
let truliooCoreArtifactURL = "https://github.com/Trulioo/trulioo-ios/releases/download/3.0.0-beta.2/TruliooCore.xcframework.zip"
let truliooCoreArtifactChecksum = "458b9b374644db0c76cdd2dfaedd6f5437c1799b6c8ae6f94264f83880670c87"

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

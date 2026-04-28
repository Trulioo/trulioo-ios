// swift-tools-version: 5.10
import PackageDescription

// Updated by scripts/package_binary_artifact.sh during release preparation.
let truliooArtifactURL = "https://github.com/Trulioo/trulioo-ios/releases/download/3.0.0/Trulioo.xcframework.zip"
let truliooArtifactChecksum = "adf19ac32a2d9230ae27f0d5508133306b5267752a7690fdfc0269e4ec086352"
let truliooCoreArtifactURL = "https://github.com/Trulioo/trulioo-ios/releases/download/3.0.0/TruliooCore.xcframework.zip"
let truliooCoreArtifactChecksum = "6549d0cdd241e69be0d75db553945a0ff020a490e418b4e07b5dee098cbfe5eb"

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

// swift-tools-version: 5.10
import PackageDescription

// Updated by scripts/package_binary_artifact.sh during release preparation.
let truliooArtifactURL = "https://github.com/Trulioo/trulioo-ios/releases/download/3.0.0-beta.3/Trulioo.xcframework.zip"
let truliooArtifactChecksum = "465ca65b08beb3df7f5d01c6c6940e436df72a0a54a35f5675fdd6a396235d91"
let truliooCoreArtifactURL = "https://github.com/Trulioo/trulioo-ios/releases/download/3.0.0-beta.3/TruliooCore.xcframework.zip"
let truliooCoreArtifactChecksum = "70b1c13b880dbe96e147685dd0dfce6b737af3dbc83b1b75328a3757815b2885"

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

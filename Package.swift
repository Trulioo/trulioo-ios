// swift-tools-version: 5.10
import PackageDescription

// Updated by scripts/package_binary_artifact.sh during release preparation.
let truliooArtifactURL = "https://github.com/Trulioo/trulioo-ios/releases/download/3.0.0-beta.1/Trulioo.xcframework.zip"
let truliooArtifactChecksum = "19bbddf774266d11e82ba47dab4aff438602350b9263bb9a73d1b68e98fad93b"
let truliooCoreArtifactURL = "https://github.com/Trulioo/trulioo-ios/releases/download/3.0.0-beta.1/TruliooCore.xcframework.zip"
let truliooCoreArtifactChecksum = "08faf803ce18e4bb2debaab7cb123d9e97c10afcbb99b98d5e447e11323c6f81"

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

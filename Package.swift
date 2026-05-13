// swift-tools-version: 5.10
import PackageDescription

// Updated by scripts/package/package_binary_artifact.sh during release preparation.
let truliooArtifactURL = "https://github.com/Trulioo/trulioo-ios/releases/download/3.1.0-beta.1/Trulioo.xcframework.zip"
let truliooArtifactChecksum = "f7296de010086407d650cc62e4838ba9ffe7ba97d298a0b8b8ccfa5086952585"
let truliooCoreArtifactURL = "https://github.com/Trulioo/trulioo-ios/releases/download/3.1.0-beta.1/TruliooCore.xcframework.zip"
let truliooCoreArtifactChecksum = "bfa4dff09ad7a7041ed8b0cf33ba3a6b823294d9516e62284b795af9855974ca"
let bureauArtifactURL = "https://github.com/Trulioo/trulioo-ios/releases/download/3.1.0-beta.1/bureau_id_fraud_sdk.xcframework.zip"
let bureauArtifactChecksum = "de1c654b25b3f790ac5d62f4e8b066a07952f893b87017508b8d22a868c391d0"

let package = Package(
    name: "Trulioo",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "Trulioo",
            targets: ["Trulioo", "TruliooCore", "bureau_id_fraud_sdk"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "bureau_id_fraud_sdk",
            url: bureauArtifactURL,
            checksum: bureauArtifactChecksum
        ),
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

// swift-tools-version: 5.10
import PackageDescription

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
            name: "Trulioo",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/4.0.0/Trulioo.xcframework.zip",
            checksum: "a24e3afdfb8ba9305ca7c7de62feb83ae4506cfa3a8e17a61cc341720511174b"
        ),
        .binaryTarget(
            name: "TruliooCore",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/4.0.0/TruliooCore.xcframework.zip",
            checksum: "5998d1315a94019b7b4c2ce8a5b3dfac6144219e63d9c81bb1a3d3e45fa46602"
        ),
        .binaryTarget(
            name: "bureau_id_fraud_sdk",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/4.0.0/bureau_id_fraud_sdk.xcframework.zip",
            checksum: "6475bcd4545863dbfc0f84b6644363bb53a025c9f1427d1187102c4205f1a741"
        ),
    ]
)

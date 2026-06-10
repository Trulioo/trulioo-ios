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
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.1.0-beta.5/Trulioo.xcframework.zip",
            checksum: "e9519972aa6e96d1e28809c40c6b2b2dae19f99fcc374112fe4f2114eed26800"
        ),
        .binaryTarget(
            name: "TruliooCore",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.1.0-beta.5/TruliooCore.xcframework.zip",
            checksum: "1bbd9ccb7df98fde434d9f9028d1cc71d2d70762ce19b215c0856b8aab7f27a1"
        ),
        .binaryTarget(
            name: "bureau_id_fraud_sdk",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.1.0-beta.5/bureau_id_fraud_sdk.xcframework.zip",
            checksum: "4f7dacd611f9828f90d9909a1a9457cab1db647856ea21484432567a5f66d03a"
        ),
    ]
)

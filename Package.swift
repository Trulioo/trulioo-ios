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
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.1.0/Trulioo.xcframework.zip",
            checksum: "a19403d239197393cab0fac18886bd4092d5e85ea6b3e741cc4ec2d09585d167"
        ),
        .binaryTarget(
            name: "TruliooCore",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.1.0/TruliooCore.xcframework.zip",
            checksum: "185f77c3725583bec39c307c1fabb1e739051fe50a424b03cf0edae96448c57f"
        ),
        .binaryTarget(
            name: "bureau_id_fraud_sdk",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.1.0/bureau_id_fraud_sdk.xcframework.zip",
            checksum: "4f7dacd611f9828f90d9909a1a9457cab1db647856ea21484432567a5f66d03a"
        ),
    ]
)

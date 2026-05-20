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
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.1.0-beta.2/Trulioo.xcframework.zip",
            checksum: "caf88d337acc291fde5c8724265796d2067feb9ac1edd7447529d872d6fde81e"
        ),
        .binaryTarget(
            name: "TruliooCore",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.1.0-beta.2/TruliooCore.xcframework.zip",
            checksum: "6ac9cbe67faf4975203fc437c7dfa8b35387f14e7cd12a762069570c0ce36d08"
        ),
        .binaryTarget(
            name: "bureau_id_fraud_sdk",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.1.0-beta.2/bureau_id_fraud_sdk.xcframework.zip",
            checksum: "ca83c9123cdc9431b77aff0b9be2333c9ec8f1be3a1447e82822be9484a05743"
        ),
    ]
)

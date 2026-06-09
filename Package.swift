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
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.1.0-beta.4/Trulioo.xcframework.zip",
            checksum: "4fa1b3c17f8cdf42c8d50bb03abe650b8bbb7d5ac7723b32abdae6b0fb78077e"
        ),
        .binaryTarget(
            name: "TruliooCore",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.1.0-beta.4/TruliooCore.xcframework.zip",
            checksum: "e1c8d18d5ef6818668dd74dbf3569e5e155700594a23b62aa7edaab7022a4948"
        ),
        .binaryTarget(
            name: "bureau_id_fraud_sdk",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.1.0-beta.4/bureau_id_fraud_sdk.xcframework.zip",
            checksum: "4f7dacd611f9828f90d9909a1a9457cab1db647856ea21484432567a5f66d03a"
        ),
    ]
)

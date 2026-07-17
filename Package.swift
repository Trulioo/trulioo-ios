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
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.2.1-beta.1/Trulioo.xcframework.zip",
            checksum: "ba58c031748134a1d53a183b79cb818a987cad4ab84590666cc9fc3046ad0082"
        ),
        .binaryTarget(
            name: "TruliooCore",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.2.1-beta.1/TruliooCore.xcframework.zip",
            checksum: "853e9469ac37bb3f9893b7fe478ff4d52f7ad3a62d3ddbe96f11a75a6201a75c"
        ),
        .binaryTarget(
            name: "bureau_id_fraud_sdk",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.2.1-beta.1/bureau_id_fraud_sdk.xcframework.zip",
            checksum: "909c22dacab4e420b40b123aafe98fd7051a60765fd3855ce72e5601b022c1df"
        ),
    ]
)

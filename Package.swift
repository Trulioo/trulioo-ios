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
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.1.0-beta.3/Trulioo.xcframework.zip",
            checksum: "c19d8cf1cfc488d3760f5336297d22dd612c7003924eb7e2281ef51a65954de4"
        ),
        .binaryTarget(
            name: "TruliooCore",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.1.0-beta.3/TruliooCore.xcframework.zip",
            checksum: "97e939bdacfbcc0153ed7be868b608efd31deb4e689b59123366b31e37ec53e8"
        ),
        .binaryTarget(
            name: "bureau_id_fraud_sdk",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.1.0-beta.3/bureau_id_fraud_sdk.xcframework.zip",
            checksum: "80456c2db0ba16c5756a08a9f5abb6b6c944196db809d69aca68e62c1b129008"
        ),
    ]
)

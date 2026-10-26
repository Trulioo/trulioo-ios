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
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/4.1.0-beta.0/Trulioo.xcframework.zip",
            checksum: "fdd5d94b44846de5629ffc4384fd5b99b64782278e48c5edc2d4e56d9dcba171"
        ),
        .binaryTarget(
            name: "TruliooCore",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/4.1.0-beta.0/TruliooCore.xcframework.zip",
            checksum: "f34146edd86e15868e2e228e84fa58f272a8187250258aa1da338402a39a6776"
        ),
        .binaryTarget(
            name: "bureau_id_fraud_sdk",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/4.1.0-beta.0/bureau_id_fraud_sdk.xcframework.zip",
            checksum: "7d18aeee65be3fc78d85864d4e68151218dc9e417b36167fcfa07fe9e626dd45"
        ),
    ]
)

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
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/4.1.0/Trulioo.xcframework.zip",
            checksum: "93e3b0502a46093c2ae66dd60642ff7ad14b04cce3e8d4ccef6572d9eb60af83"
        ),
        .binaryTarget(
            name: "TruliooCore",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/4.1.0/TruliooCore.xcframework.zip",
            checksum: "269af18363ed24b2d35cfe1572de50163e21876dd397f834dc9cd7aa117aafd6"
        ),
        .binaryTarget(
            name: "bureau_id_fraud_sdk",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/4.1.0/bureau_id_fraud_sdk.xcframework.zip",
            checksum: "7d18aeee65be3fc78d85864d4e68151218dc9e417b36167fcfa07fe9e626dd45"
        ),
    ]
)

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
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.3.0-beta.0/Trulioo.xcframework.zip",
            checksum: "d3e742e5ae169ce60bdd6524479a14061c6a25f8685cecaf533105eb2f42e7a4"
        ),
        .binaryTarget(
            name: "TruliooCore",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.3.0-beta.0/TruliooCore.xcframework.zip",
            checksum: "3bef65ccf3778a04f8833c0d22ce504ccb01067ed8bb8fd761ba6aa9c85795b5"
        ),
        .binaryTarget(
            name: "bureau_id_fraud_sdk",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.3.0-beta.0/bureau_id_fraud_sdk.xcframework.zip",
            checksum: "6475bcd4545863dbfc0f84b6644363bb53a025c9f1427d1187102c4205f1a741"
        ),
    ]
)

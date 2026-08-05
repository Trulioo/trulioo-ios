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
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.2.2-beta.0/Trulioo.xcframework.zip",
            checksum: "83019aea72e04891fc4b09191c57ab112a4e0c2e72f0626105554e1ffbddcdea"
        ),
        .binaryTarget(
            name: "TruliooCore",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.2.2-beta.0/TruliooCore.xcframework.zip",
            checksum: "d7de37df888f4bc3d8e4ef58bccead373bf07f20c2e567fb6cc7dd1bd4ae6e6a"
        ),
        .binaryTarget(
            name: "bureau_id_fraud_sdk",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.2.2-beta.0/bureau_id_fraud_sdk.xcframework.zip",
            checksum: "6475bcd4545863dbfc0f84b6644363bb53a025c9f1427d1187102c4205f1a741"
        ),
    ]
)

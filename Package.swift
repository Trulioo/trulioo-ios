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
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.2.2/Trulioo.xcframework.zip",
            checksum: "3f305f7770b31ef3a80442f12c954c7f9f31922690461ed07880141341e07647"
        ),
        .binaryTarget(
            name: "TruliooCore",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.2.2/TruliooCore.xcframework.zip",
            checksum: "054e501718546c474c802df94976a5de0284694666a7358b8e8a7bafb94b482f"
        ),
        .binaryTarget(
            name: "bureau_id_fraud_sdk",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.2.2/bureau_id_fraud_sdk.xcframework.zip",
            checksum: "6475bcd4545863dbfc0f84b6644363bb53a025c9f1427d1187102c4205f1a741"
        ),
    ]
)

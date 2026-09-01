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
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/4.0.0-beta.0/Trulioo.xcframework.zip",
            checksum: "930709d48bdd7ab993014e800509802d7e1ee984a973d4eea27166266d5f7902"
        ),
        .binaryTarget(
            name: "TruliooCore",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/4.0.0-beta.0/TruliooCore.xcframework.zip",
            checksum: "7290249a59edf23ccc624ff63833767e52df2945d72ad60800cefdf7cd15d01b"
        ),
        .binaryTarget(
            name: "bureau_id_fraud_sdk",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/4.0.0-beta.0/bureau_id_fraud_sdk.xcframework.zip",
            checksum: "6475bcd4545863dbfc0f84b6644363bb53a025c9f1427d1187102c4205f1a741"
        ),
    ]
)

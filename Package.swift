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
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.1.0-beta.6/Trulioo.xcframework.zip",
            checksum: "de055856276d34fe1e1717e0a3f2e2aba587a056178a18ab77145691924ec965"
        ),
        .binaryTarget(
            name: "TruliooCore",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.1.0-beta.6/TruliooCore.xcframework.zip",
            checksum: "cce9560eb1c68420283a7371b916d8d43936e561b0d721d61c1da4cec2e21e79"
        ),
        .binaryTarget(
            name: "bureau_id_fraud_sdk",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.1.0-beta.6/bureau_id_fraud_sdk.xcframework.zip",
            checksum: "4f7dacd611f9828f90d9909a1a9457cab1db647856ea21484432567a5f66d03a"
        ),
    ]
)

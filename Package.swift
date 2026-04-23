// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "Trulioo",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "TruliooCore",
            targets: ["TruliooCore"]
        ),
        .library(
            name: "Trulioo",
            targets: ["Trulioo"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "bureau_id_fraud_sdk",
            path: "Vendor/bureau_id_fraud_sdk.xcframework"
        ),
        .target(
            name: "TruliooCore",
            dependencies: ["bureau_id_fraud_sdk"],
            path: "Sources/TruliooCore"
        ),
        .target(
            name: "Trulioo",
            dependencies: ["TruliooCore"],
            path: "Sources/Trulioo"
        ),
        .testTarget(
            name: "TruliooTests",
            dependencies: ["Trulioo", "TruliooCore"],
            path: "Tests/TruliooTests",
            resources: [
                .process("Fixtures"),
            ]
        ),
    ]
)

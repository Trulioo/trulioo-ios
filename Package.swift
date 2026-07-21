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
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.2.1/Trulioo.xcframework.zip",
            checksum: "0c9e83423eb0c2b4441c9cab301058e376d8928cc1771d10f42fe8d4f04fc867"
        ),
        .binaryTarget(
            name: "TruliooCore",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.2.1/TruliooCore.xcframework.zip",
            checksum: "c6dfb58174853b1e4cbfe04173bd7de022d4e51be5619c9e137b44d23cdb792d"
        ),
        .binaryTarget(
            name: "bureau_id_fraud_sdk",
            url: "https://github.com/Trulioo/trulioo-ios/releases/download/3.2.1/bureau_id_fraud_sdk.xcframework.zip",
            checksum: "909c22dacab4e420b40b123aafe98fd7051a60765fd3855ce72e5601b022c1df"
        ),
    ]
)

// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "BluemixObjectStorage",
    products: [
        .library(name: "BluemixObjectStorage", targets: ["BluemixObjectStorage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ibm-bluemix-mobile-services/bluemix-simple-http-client-swift.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "BluemixObjectStorage", dependencies: ["SimpleHttpClient"]),
        .testTarget(name: "BluemixObjectStorageTests", dependencies: ["SimpleHttpClient", "BluemixObjectStorage"]),
    ]
)

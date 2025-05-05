// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "KFirebaseAuthInterop",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        .library(
            name: "KFirebaseAuthInterop",
            type: .dynamic,
            targets: ["KFirebaseAuthInterop"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            from: "11.9.0"
        ),
    ],
    targets: [
        .target(
            name: "KFirebaseAuthInterop",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
            ],
            path: "Sources",
            exclude: ["Info.plist"],
            swiftSettings: [
                .interoperabilityMode(.Cxx),  // For better Obj-C interop
                .unsafeFlags([
                    "-emit-objc-header",
                    "-emit-objc-header-path",
                    "./Headers/KFirebaseAuthInterop-Swift.h"
                ])
            ],
            linkerSettings: [
                .linkedFramework("Foundation"),
                .linkedFramework("UIKit", .when(platforms: [.iOS])),
            ]
        )
    ]
)

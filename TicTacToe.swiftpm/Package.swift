// swift-tools-version: 5.9

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "TicTacToe",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .iOSApplication(
            name: "TicTacToe",
            targets: ["AppModule"],
            bundleIdentifier: "com.pkaidev.TicTacToe",
            teamIdentifier: "",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .gamecontroller),
            accentColor: .presetColor(.cyan),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "Sources/AppModule"
        )
    ]
)

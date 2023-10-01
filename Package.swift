// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-winrt-prototype",
    targets: [
        .target(
            name: "CWinRT",
            path: "CWinRT",
            linkerSettings: [ .linkedLibrary("WindowsApp.lib") ]),
        .target(
            name: "WinRT",
            dependencies: ["CWinRT"],
            path: "WinRT"),
        .target(
            name: "UWP",
            dependencies: ["CWinRT", "WinRT"],
            path: "UWP/Assembly"),
        .target(
            name: "UWP_WindowsSecurityCryptographyCore",
            dependencies: ["UWP"],
            path: "UWP/Namespaces/WindowsSecurityCryptographyCore"),
        .target(
            name: "UWP_WindowsStorageStreams",
            dependencies: ["UWP"],
            path: "UWP/Namespaces/WindowsStorageStreams"),
        .testTarget(
            name: "Tests",
            dependencies: [
                "WinRT",
                "UWP_WindowsSecurityCryptographyCore",
                "UWP_WindowsStorageStreams"],
            path: "Tests")
    ]
)

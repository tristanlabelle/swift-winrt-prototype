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
            name: "COM",
            dependencies: ["CWinRT"],
            path: "COM"),
        .target(
            name: "WindowsRuntime",
            dependencies: ["CWinRT", "COM"],
            path: "WindowsRuntime"),
        .target(
            name: "UWP_Assembly",
            dependencies: ["CWinRT", "WindowsRuntime"],
            path: "UWP/Assembly"),
        .target(
            name: "UWP_WindowsFoundation",
            dependencies: ["UWP_Assembly"],
            path: "UWP/Namespaces/WindowsFoundation"),
        .target(
            name: "UWP_WindowsFoundationDiagnostics",
            dependencies: ["UWP_Assembly"],
            path: "UWP/Namespaces/WindowsFoundationDiagnostics"),
        .target(
            name: "UWP_WindowsSecurityCryptographyCore",
            dependencies: ["UWP_Assembly"],
            path: "UWP/Namespaces/WindowsSecurityCryptographyCore"),
        .target(
            name: "UWP_WindowsStorageStreams",
            dependencies: ["UWP_Assembly"],
            path: "UWP/Namespaces/WindowsStorageStreams"),
        .testTarget(
            name: "Tests",
            dependencies: [
                "COM",
                "WindowsRuntime",
                "UWP_WindowsFoundation",
                "UWP_WindowsFoundationDiagnostics",
                "UWP_WindowsSecurityCryptographyCore",
                "UWP_WindowsStorageStreams"],
            path: "Tests")
    ]
)

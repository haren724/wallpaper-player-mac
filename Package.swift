// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Wallpaper_Player_User_Documentation",
    products: [
        .library(
            name: "Wallpaper_Player_User_Documentation",
            targets: ["UserDocumentation"])],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")],
    targets: [
        .target(name: "UserDocumentation")]
)

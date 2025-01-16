// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Wallpaper_Player_Documentation",
    products: [
        .library(
            name: "Wallpaper_Player_Documentation",
            targets: ["User_Documentation_en_US", "User_Documentation_zh_CN"])],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")],
    targets: [
        .target(name: "User_Documentation_en_US"),
        .target(name: "User_Documentation_zh_CN")]
)

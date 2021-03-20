// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "friend-bot",
  platforms: [
    .macOS(.v10_15)
  ],
  products: [
    .executable(name: "friend-bot", targets: ["friend-bot"]),
  ],
  dependencies: [
    .package(url: "https://github.com/Azoy/Sword", .branch("master")),
    .package(url: "https://github.com/vapor/fluent-sqlite-driver", "4.0.0"..<"5.0.0"),
    .package(url: "https://github.com/malcommac/Hydra.git", "2.0.0"..<"3.0.0"),
    .package(url: "https://github.com/sushichop/Puppy", "0.1.0"..<"1.0.0")
  ],
  targets: [
    .target(
      name: "friend-bot",
      dependencies: [
        "Sword",
        .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
        .product(name: "Hydra", package: "Hydra"),
        .product(name: "Puppy", package: "Puppy")
      ]
    ),
    .testTarget(
      name: "friend-botTests",
      dependencies: ["friend-bot"]
    ),
  ]
)

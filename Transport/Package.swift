// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Transport",
  platforms: [.iOS(.v14)],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "TransportHome",
      targets: ["TransportHome"]),
    
  ],
  dependencies: [
    .package(name: "ModernRIBs", url: "https://github.com/DevYeom/ModernRIBs", .exactItem("1.0.1")),
    .package(path: "../Platform"),
    .package(path: "../Finance")
  ],
  targets: [
    .target(
      name: "TransportHome",
      dependencies: [
        "ModernRIBs",
        .product(name: "FinanceRepository", package: "Finance"),
        .product(name: "Topup", package: "Finance"),
      ],
      resources: [
        .process("Resources")
      ]
    ),
  ]
)

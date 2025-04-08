// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "TryRegex",
  products: [
    .library(
      name: "StringProcessing",
      targets: ["StringProcessing"]
    ),
    .library(
      name: "RegexParser",
      targets: ["RegexParser"]
    ),
  ],
  targets: [
    .target(
      name: "RegexParser",
      dependencies: []
    ),
    .target(
      name: "StringProcessing",
      dependencies: [
        "RegexParser",
      ]
    ),
    .testTarget(
      name: "RegexTests",
      dependencies: [
        "StringProcessing",
      ]
    ),
  ]
)

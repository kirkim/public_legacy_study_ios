// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SegmentationPerson",
    platforms: [
      .macOS(.v10_15), .iOS(.v14), .tvOS(.v14)
    ],
    products: [
      .library(
          name: "SegmentationPerson",
          targets: ["SegmentationPerson"]
      )
    ],
    targets: [
      .binaryTarget(
          name: "SegmentationPerson",
          path: "./Sources/SegmentationPerson.xcframework"
      )
    ]
)

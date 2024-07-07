// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Benchmarks",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "Benchmarks",
            targets: ["Benchmarks"]
        ),
        .library(
            name: "Compressor",
            targets: ["Compressor"]
        ),
        .library(
            name: "BrotliCompressor", targets: ["BrotliCompressor"]
        ),
        .library(
            name: "GzipCompressor", targets: ["GzipCompressor"]
        ),
        .library(
            name: "PageClient", targets: ["PageClient"]
        ),
        .library(
            name: "SnappyCompressor", targets: ["SnappyCompressor"]
        ),
        .library(
            name: "ZStdCompressor",
            targets: ["ZStdCompressor"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/awxkee/zstd.swift", from: "1.0.1"),
        .package(url: "https://github.com/awxkee/snappy.swift", from: "1.0.0"),
        .package(url: "https://github.com/1024jp/GzipSwift", exact: "6.0.0"),
        .package(url: "https://github.com/f-meloni/SwiftBrotli", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "Benchmarks"
        ),
        .target(
            name: "Compressor"
        ),
        .target(
            name: "BrotliCompressor",
            dependencies: ["Compressor", .product(name: "SwiftBrotli", package: "SwiftBrotli")]
        ),
        .target(
            name: "GzipCompressor",
            dependencies: ["Compressor", .product(name: "Gzip", package: "GzipSwift")]
        ),
        .target(
            name: "PageClient",
            dependencies: [],
            resources: [.process("Resources/")]
        ),
        .target(
            name: "SnappyCompressor",
            dependencies: ["Compressor", .product(name: "snappy", package: "snappy.swift")]
        ),
        .target(
            name: "ZStdCompressor",
            dependencies: [
                "Compressor",
                .product(name: "zstd", package: "zstd.swift"),
            ]
        ),
        .testTarget(
            name: "BenchmarksTests",
            dependencies: ["Benchmarks"]
        ),
    ]
)

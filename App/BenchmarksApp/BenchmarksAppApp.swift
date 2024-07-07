//
//  BenchmarksAppApp.swift
//  BenchmarksApp
//
//  Created by Kirill Voloshin on 7/5/24.
//

import BrotliCompressor
import Compressor
import DeviceKit
import GzipCompressor
import PageClient
import SnappyCompressor
import SwiftUI
import ZStdCompressor

let WARMUP_ROUNDS = 20
let MEASURED_ROUNDS = 2000

@main
struct BenchmarksAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    runBenchmarks()
                }
        }
    }

    func formatResults(results: [Result]) -> String {
        var rows = [String]()
        rows.append("--- BENCHMARKS ---")
        rows.append("Device: \(Device.current.description)")
        rows.append("Battery: \(Device.current.batteryState?.description ?? "unknown")")
        #if DEBUG
            rows.append("Mode: Debug")
        #else
            rows.append("Mode: Release")
        #endif
        rows.append("Warmup iterations: \(WARMUP_ROUNDS)")
        rows.append("Measured iterations: \(MEASURED_ROUNDS)")
        rows.append("")

        let resultsByPage = results.reduce(into: [String: [Result]]()) {
            $0[$1.pageName, default: [Result]()].append($1)
        }

        for (page, pageResults) in resultsByPage {
            rows.append("-- \(page) --")
            rows.append("algorithm_level,time in ms")
            for result in pageResults {
                rows.append("\(result.algorithm)_\(result.level),\(result.averageTime)")
            }
        }

        return String(rows.joined(separator: "\n"))
    }

    func debugPrint(_ contents: String) {
        #if DEBUG
            print(contents)
        #endif
    }

    func runBenchmarks() {
        debugPrint("Loading pages")

        let pageClient = PageClient()

        let pages = pageClient.getPages()

        debugPrint("Loaded Pages")

        for page in pages {
            debugPrint("-- \(page.name) \(page.data.count.byteSize)")
        }

        debugPrint("running benchmarks")

        let compressors: [Compressor] = [
            //            .brotli,
            .gzip,
            .snappy,
            .zstd,
        ]

        var results = [Result]()

        let benchmarkStart = CFAbsoluteTimeGetCurrent()

        for compressor in compressors {
            debugPrint("-- Benchmarking \(compressor.name)")
            let levels = compressor.compressionLevels()
            for level in levels {
                for page in pages {
                    do {
                        let compressed = try compressor.compress(page.data, level)
                        var totalTime: Double = 0

                        for _ in 0 ..< WARMUP_ROUNDS {
                            let _ = try compressor.decompress(compressed)
                        }

                        for _ in 0 ..< MEASURED_ROUNDS {
                            let start = CFAbsoluteTimeGetCurrent()
                            let _ = try compressor.decompress(compressed)
                            totalTime += CFAbsoluteTimeGetCurrent() - start
                        }

                        let averageMS = String(format: "%.4f", (totalTime / Double(MEASURED_ROUNDS)) * 1000)

                        results.append(Result(algorithm: compressor.name, level: level, pageName: page.name + " (\(page.data.count.byteSize))", averageTime: averageMS))
                    } catch let err {
                        print("Error compressing with \(compressor.name) level \(level)")
                        print(err.localizedDescription)
                    }
                }
            }
        }

        debugPrint("Finished running benchmarks")

        debugPrint("Finished in \(CFAbsoluteTimeGetCurrent() - benchmarkStart) seconds")

        // To use this output, select everything in the console output and copy
        // Past into google sheets
        // Go to Format -> Clear Formatting
        // Go to Data -> Split text to columns -> use comma as separator
        print(formatResults(results: results))
    }
}

struct Result {
    let algorithm: String
    let level: Int
    let pageName: String
    let averageTime: String
}

extension Int {
    var byteSize: String {
        return ByteCountFormatter().string(fromByteCount: Int64(self))
    }
}

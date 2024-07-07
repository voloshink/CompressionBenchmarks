//
//  ZStdCompressor.swift
//
//
//  Created by Kirill Voloshin on 7/5/24.
//

import Compressor
import Foundation
import zstd

let ZStdCompressor = Compressor(name: "", compress: { _, _ in Data() }, decompress: { _ in Data() }, compressionLevels: { [] })

public extension Compressor {
    static var zstd: Self {
        let levels = Array(1 ... 22)

        return Compressor(
            name: "ZStd",
            compress: { data, level in
                #if DEBUG
                    guard levels.contains(level) else {
                        throw Compressor.Err.InvalidCompressionLevel
                    }
                #endif
                return try ZStd.compress(data, compressionLevel: level)
            },
            decompress: { data in
                try ZStd.decompress(data)
            },
            compressionLevels: {
                levels
            }
        )
    }
}

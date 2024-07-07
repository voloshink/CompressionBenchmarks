//
//  GzipCompressor.swift
//
//
//  Created by Kirill Voloshin on 7/5/24.
//

import Compressor
import Foundation
import Gzip

public extension Compressor {
    static var gzip: Self {
        let levels = Array(1 ... 9)
        return Compressor(
            name: "Gzip",
            compress: { data, level in
                #if DEBUG
                    guard levels.contains(level) else {
                        throw Compressor.Err.InvalidCompressionLevel
                    }
                #endif
                let compressionLevel = CompressionLevel(Int32(level))
                return try data.gzipped(level: compressionLevel)
            },
            decompress: { data in
                try data.gunzipped()
            }, compressionLevels: {
                levels
            }
        )
    }
}

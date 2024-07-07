//
//  SnappyCompressor.swift
//
//
//  Created by Kirill Voloshin on 7/5/24.
//

import Compressor
import Foundation
import snappy

typealias SnappyModule = snappy

public extension Compressor {
    static var snappy: Self {
        let levels = [1]

        return Compressor(
            name: "Snappy",
            compress: { data, level in
                #if DEBUG
                    guard levels.contains(level) else {
                        throw Compressor.Err.InvalidCompressionLevel
                    }
                #endif
                return try SnappyModule.compress(data)
            },
            decompress: { data in
                try SnappyModule.decompress(data)
            },
            compressionLevels: {
                levels
            }
        )
    }
}

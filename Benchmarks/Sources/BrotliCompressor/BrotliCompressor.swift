//
//  BrotliCompressor.swift
//
//
//  Created by Kirill Voloshin on 7/5/24.
//

import Compressor
import Foundation
import SwiftBrotli

public extension Compressor {
    static var brotli: Self {
        let brotli = Brotli()
        let compressionLevels = Array(1 ... 11)

        return Compressor(
            name: "Brotli",
            compress: { data, level in
                #if DEBUG
                    guard compressionLevels.contains(level) else {
                        throw Compressor.Err.InvalidCompressionLevel
                    }
                #endif
                let result = brotli.compress(data, quality: Int32(level))
                switch result {
                case let .success(data): return data
                case let .failure(error): throw error
                }
            },
            decompress: { data in
                let result = brotli.decompress(data)
                switch result {
                case let .success(data): return data
                case let .failure(error): throw error
                }
            },
            compressionLevels: {
                compressionLevels
            }
        )
    }
}

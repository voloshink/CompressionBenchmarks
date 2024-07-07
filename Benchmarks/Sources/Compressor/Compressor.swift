//
//  Compressor.swift
//
//
//  Created by Kirill Voloshin on 7/5/24.
//

import Foundation

public struct Compressor {
    public let name: String

    public let compress: (_ input: Data, _ level: Int) throws -> Data
    public let decompress: (_ input: Data) throws -> Data
    public let compressionLevels: () -> [Int]

    public init(name: String, compress: @escaping (Data, Int) throws -> Data, decompress: @escaping (Data) throws -> Data, compressionLevels: @escaping () -> [Int]) {
        self.name = name
        self.compress = compress
        self.decompress = decompress
        self.compressionLevels = compressionLevels
    }

    public enum Err: Error, LocalizedError {
        case InvalidCompressionLevel

        public var errorDescription: String? {
            switch self {
            case .InvalidCompressionLevel:
                return "Invalid compression level"
            }
        }
    }
}

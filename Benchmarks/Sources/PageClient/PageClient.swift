//
//  PageClient.swift
//
//
//  Created by Kirill Voloshin on 7/6/24.
//

import Foundation

public struct PageClient {
    static let pages: [PageFile] = [
        .init(name: "Home Root", fileName: "home_page_root"),
        .init(name: "Meals Root", fileName: "meals-page-root"),
        .init(name: "Promo Root", fileName: "promo-page-root"),
        .init(name: "Purchases Root", fileName: "purchases-page-root"),
        .init(name: "Search Results Kaas", fileName: "search-page-results-kaas"),
    ]

    public init() {}

    public func getPages() -> [PageData] {
        PageClient.pages.compactMap {
            guard let fileData = loadFile($0.fileName) else {
                print("Error loading page \($0.name) \($0.fileName)")
                return nil
            }

            return PageData(name: $0.name, data: fileData)
        }
    }

    private func loadFile(_ name: String) -> Data? {
        if let url = Bundle.module.url(forResource: name, withExtension: "json") {
            return try? Data(contentsOf: url)
        } else {
            return nil
        }
    }
}

struct PageFile {
    let name: String
    let fileName: String
}

public struct PageData {
    public let name: String
    public let data: Data
}

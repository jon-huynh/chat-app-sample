//
//  MockDataLoader.swift
//  OdolaWIP
//
//  Created by Jon Huynh on 12/17/24.
//

import Foundation

enum MockError: Error {
    case fileNotFound
    case failedToDecode
}

struct MockDataLoader {
    static func load<T: Decodable>(from fileName: String, type: T.Type) throws -> T {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw MockError.fileNotFound
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try ODLDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw MockError.failedToDecode
        }
    }
}

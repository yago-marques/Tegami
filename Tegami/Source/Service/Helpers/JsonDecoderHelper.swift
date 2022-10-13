//
//  UserDefaultsHelper.swift
//  Tegami
//
//  Created by Yago Marques on 13/10/22.
//

import Foundation

protocol JsonDecoderProtocol {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JsonDecoderProtocol {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(type, from: data)
    }
}

class JsonDecoderHelper: JsonDecoderProtocol { }

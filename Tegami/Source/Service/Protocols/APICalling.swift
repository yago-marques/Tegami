//
//  APICalling.swift
//  Tegami
//
//  Created by Yago Marques on 13/10/22.
//

import Foundation

protocol APICalling: AnyObject {
    func GET(at path: String, queries: [(String, String)], headers: [String: String], completion: @escaping (Result<(Data, Int), APICallError>) -> Void)
}

extension APICalling {
    func GET(
        at path: String,
        queries: [(String, String)] = [],
        headers: [String: String] = ["Content-Type": "application/json"],
        completion: @escaping (Result<(Data, Int), APICallError>) -> Void
    ) {
        GET(at: path, queries: queries, headers: headers, completion: completion)
    }
}

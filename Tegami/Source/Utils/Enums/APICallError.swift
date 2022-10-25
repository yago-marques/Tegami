//
//  APICallError.swift
//  Tegami
//
//  Created by Yago Marques on 10/10/22.
//

import Foundation

enum APICallError: Error {
    case invalidUrl
    case network(Error)
}

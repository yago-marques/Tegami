//
//  EndpointProtocol.swift
//  Tegami
//
//  Created by user on 13/10/22.
//

import Foundation

protocol EndpointProtocol {
    var urlBase: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String: String] { get }
    var queries: [URLQueryItem] { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

extension EndpointProtocol {
    var httpMethod: HTTPMethod {
        return .get
    }

    var headers: [String: String] {
        return [:]
    }

    var queries: [URLQueryItem] {
        return []
    }
    
    func makeURL() -> URL? {
        guard var component = URLComponents(string: "\(urlBase)\(path)") else { return nil }
        component.scheme = "https"
        component.queryItems = queries.isEmpty ? nil : queries
        return component.url
    }
}

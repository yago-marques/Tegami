//
//  TmdbInfoEndpoint.swift
//  Tegami
//
//  Created by user on 13/10/22.
//

import Foundation

struct TmdbInfoEndpoint: EndpointProtocol {
    
    private let title: String
    
    init(title: String) {
        self.title = title
    }
    
    var urlBase: String {
        return "https://api.themoviedb.org/3"
    }
    
    var path: String {
        return "/search/movie"
    }
    
    var queries: [URLQueryItem] {
        return [
            .init(name: "api_key", value: "2fb0d7c0095f63e9c881bb4317a570a9"),
            .init(name: "language", value: "pt-BR"),
            .init(name: "query", value: title),
            .init(name: "page", value: "1")
        ]
    }
}

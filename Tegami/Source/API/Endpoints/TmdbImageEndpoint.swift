//
//  TmdbImageEndpoint.swift
//  Tegami
//
//  Created by user on 14/10/22.
//

import Foundation

struct TmdbImageEndpoint: EndpointProtocol {
    
    let imagePath: String
    
    var urlBase: String {
        return "https://image.tmdb.org/t/p/w500"
    }
    
    var path: String {
        return imagePath
    }
}

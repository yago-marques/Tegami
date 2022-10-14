//
//  GhibliFilmsEnpoint.swift
//  Tegami
//
//  Created by user on 13/10/22.
//

import Foundation

struct GhibliFilmsEndpoint: EndpointProtocol {
    var urlBase: String {
        return "https://ghibliapi.herokuapp.com"
    }
    
    var path: String {
        return "/films"
    }
}

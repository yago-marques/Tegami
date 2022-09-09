//
//  API.swift
//  GhibliAPP
//
//  Created by Caio Soares on 09/09/22.
//

import Foundation

struct APICall {
    
    static let ghibliBaseURL: String = "https://ghibliapi.herokuapp.com/films"
    
    static func getAllGhibliData() async -> [GhibliInfo] {
        let url: URL = URL(string: ghibliBaseURL)!
        
        let request = URLRequest(url: url)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            print(String(data: data, encoding: .utf8)!)
        } catch {
            print(error)
        }
        return []
        
    }
}

final class API {
        
    static func get(path: String) async -> (Data?, URLResponse?)? {
        let url: URL = URL(string: path)!
        
        let request = URLRequest(url: url)
        
        do {
            let info = try await URLSession.shared.data(for: request)
            return info
        } catch {
            print(error)
        }
        return nil
    }
}

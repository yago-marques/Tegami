//
//  API.swift
//  GhibliAPP
//
//  Created by Caio Soares on 09/09/22.
//

import Foundation

protocol HTTPClient {
    func get(endpoint: EndpointProtocol, completion: @escaping (Result<(Data, HTTPURLResponse), APICallError>) -> Void)
}

final class URLSessionHTTPClient: HTTPClient {

    let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func get(endpoint: EndpointProtocol, completion: @escaping (Result<(Data, HTTPURLResponse), APICallError>) -> Void) {
        guard let url = endpoint.makeURL() else {
            return completion(.failure(.invalidUrl))
        }

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = endpoint.headers
        request.httpMethod = endpoint.httpMethod.rawValue
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.network(error)))
            }

            if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            }
        }

        task.resume()
    }
}

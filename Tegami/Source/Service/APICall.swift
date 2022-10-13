//
//  API.swift
//  GhibliAPP
//
//  Created by Caio Soares on 09/09/22.
//

import Foundation

final class APICall: APICalling {

    // MARK: - Dependency injection (to testing)
    let UrlSession: URling

    init(UrlSession: URling) {
        self.UrlSession = UrlSession
    }

    // MARK: - Generic GET request
    func GET(
        at path: String,
        queries: [(String, String)] = [],
        headers: [String: String] = ["Content-Type": "application/json"],
        completion: @escaping (Result<(Data, Int), APICallError>) -> Void
    ) {

        guard let url = buildUrl(with: path, queries: queries) else {
            return completion(.failure(.invalidUrl))
        }

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        
        let task = UrlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.network(error)))
            }

            if let data = data, let response = response {
                let statusCode = self.statusCode(of: response)

                completion(.success((data, statusCode)))
            }
        }

        task.resume()
    }

    // MARK: - Method to return an URL (using URLComponents)
    func buildUrl(
        with url: String,
        queries: [(String, String)] = []
    ) -> URL? {
        guard var component = URLComponents(string: url) else { return nil }
        component.scheme = "https"
        component.queryItems = self.buildQueries(with: queries)

        return component.url
    }

    // MARK: - Method to return a Query list
    func buildQueries(with queries: [(String, String)]) -> [URLQueryItem] {
        let myQueries = queries.map { (tupleKey, tupleValue) -> URLQueryItem in
            let query = URLQueryItem(name: tupleKey, value: tupleValue)

            return query
        }
        return myQueries
    }

    // MARK: - Method to return status code of request
    func statusCode(of response: URLResponse) -> Int {
        let httpResponse = response as? HTTPURLResponse

        if let statusCode = httpResponse?.statusCode {
            return statusCode
        }

        return 0
    }

}

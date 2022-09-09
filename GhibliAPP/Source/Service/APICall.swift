//
//  API.swift
//  GhibliAPP
//
//  Created by Caio Soares on 09/09/22.
//

import Foundation

final class APICall {

    // MARK: - Dependency injection (to testing)
    let UrlSession: URLSession

    init(UrlSession: URLSession = URLSession.shared) {
        self.UrlSession = UrlSession
    }

    // MARK: - Generic GET request
    func GET(
        at path: String,
        queries: [(String, String)] = [],
        headers: [String: String] = ["Content-Type": "application/json"]
    ) async -> (data: Data, status: Int)? {

        guard let url = buildUrl(with: path, queries: queries) else { return nil }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let status = statusCode(of: response) else { return nil }

            return (data, status)
        } catch {
            print(error)
        }

        return nil
    }

    // MARK: - Method to return an URL (using URLComponents)
    func buildUrl(
        with url: String,
        queries: [(String, String)] = []
    ) -> URL? {
        guard var component = URLComponents(string: url) else { return nil }
        component.scheme = "HTTPS"
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
    func statusCode(of response: URLResponse) -> Int? {
        let httpResponse = response as? HTTPURLResponse

        return httpResponse?.statusCode
    }

}

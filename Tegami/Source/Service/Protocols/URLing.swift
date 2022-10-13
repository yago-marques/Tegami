//
//  URLing.swift
//  Tegami
//
//  Created by Yago Marques on 13/10/22.
//

import Foundation

protocol URling {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

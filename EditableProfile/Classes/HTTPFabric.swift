//
//  HTTPFabric.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/21/20.
//

import Foundation
import Alamofire

// MARK: - comment:
// Main purpose is to separate 3rd-party Alamofire and the main app
// (maybe for moving this Fabric to another module etc) and
// (to no to test Alamafire at all cause it has own tests)

protocol HTTPFabric {
    func makeRequest<Response: Decodable>(_ request: HTTPURLRequestConvertible, completionHandler: @escaping (Result<Response, Error>) -> Void)
}

final class HTTPFabricImpl: HTTPFabric {
    
    func makeRequest<Response: Decodable>(_ request: HTTPURLRequestConvertible, completionHandler: @escaping (Result<Response, Error>) -> Void) {
        AF.request(AfRequest(requestConvertible: request))
            .validate()
            .responseDecodable(of: Response.self) { response in
                if let error = response.error {
                    completionHandler(.failure(error))
                    return
                }
                if let value = response.value {
                    completionHandler(.success(value))
                    return
                }
                completionHandler(.failure(NSError(domain: "HTTPFabric", code: -1, userInfo: ["Reason" : "Unexpected error"])))
            }
    }
}

// MARK: - Just wrapper for `URLRequestConvertible`

protocol HTTPURLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

fileprivate struct AfRequest: URLRequestConvertible {
    
    let requestConvertible: HTTPURLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        return try requestConvertible.asURLRequest()
    }
}

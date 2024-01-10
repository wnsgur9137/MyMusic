//
//  Endpoint.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/10/24.
//

import Foundation

// MARK: - HTTPMethodType
public enum HTTPMethodType: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

// MARK: - BodyEncoding
public enum BodyEncoding {
    case jsonSerializationData
    case stringEncodingAscii
}


// MARK: - Requestable
public protocol Requestable {
    var path: String { get }
    var isFullPath: Bool { get }
    var method: HTTPMethodType { get }
    var headerParameters: [String: String] { get }
    var queryParametersEncodable: Encodable? { get }
    var queryParameters: [String: Any] { get }
    var bodyParametersEncodable: Encodable? { get }
    var bodyParameters: [String: Any] { get }
    var bodyEncoding: BodyEncoding { get }
    
    func urlRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest
}

// MARK: - ResponseRequestable
public protocol ResponseRequestable: Requestable {
    associatedtype Response
    
    var responseDecoder: ResponseDecoder { get }
}

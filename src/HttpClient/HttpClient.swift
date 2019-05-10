//
//  HttpClient.swift
//  HttpClient
//
//  Created by Pontus Nilsson Tengnäs on 2019-05-01.
//  Copyright © 2019 Pontus Nilsson Tengnäs. All rights reserved.
//

import Foundation

public struct HttpClient {
    
    private let jsonDecoder: JSONDecoder
    
    public init() {
        jsonDecoder = JSONDecoder()
    }
    
    /// Performs an Http request to param `url`.
    /// Decodes JSON response to an instance of parameter `outType`
    ///
    /// - Parameters:
    ///     - url: The url to where the request is made
    ///     - httpMethod: Http method to use for the request
    ///     - outType: The type of the class/struct that should be returned if the request succeeds
    ///     - headers: Dictionary for Http request headers by key-value
    ///     - body: The body of the Http request, for example encoded JSON
    ///     - cachePolicy: Desired cache policy
    ///     - timeout: The timeout for the Http request
    ///     - completionHandler: The result of the request
    public func httpRequest<T: Decodable>(url: String,
                            httpMethod: HCHttpMethod,
                            outType: T.Type,
                            headers: [String: String]? = nil,
                            body: Data? = nil,
                            cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
                            timeout: Int = 30,
                            completionHandler: @escaping (_ result: HCClientResponse<T>?) -> ()) {
        
        if url.isEmpty {
            completionHandler(HCClientResponse.badInput("Url is empty"))
            return
        }
        
        guard let urlObject = URL(string: url) else {
            completionHandler(HCClientResponse.badInput("Input URL is not valid"))
            return
        }
        
        var request = URLRequest(url: urlObject, cachePolicy: cachePolicy, timeoutInterval: TimeInterval(timeout))
        request.httpMethod = httpMethod.rawValue
        
        if let headers = headers {
            request.appendHeaders(headers: headers)
        }
        
        if let body = body {
            request.httpBody = body
        }
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if let error = error {
                completionHandler(HCClientResponse.failure(error.localizedDescription))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(HCClientResponse.badInput("HttpResponse could not be created"))
                return
            }
            
            if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                guard let dataObj = data else {
                    completionHandler(HCClientResponse.badInput("Data object is empty"))
                    return
                }
                
                guard let returnObj: T = self.parseJson(data: dataObj) else {
                    completionHandler(HCClientResponse.failure("Failed JSON parse"))
                    return
                }
                
                completionHandler(HCClientResponse.success(httpResponse.statusCode, returnObj))
                
            } else {
                completionHandler(HCClientResponse.httpFailure(httpResponse.statusCode))
            }
            
            return
        }
        
        task.resume()
    }
    
    /// Decodes parameter `data` to an object of type `T`
    ///
    /// - Parameter data: The JSON data to be decoded
    ///
    /// - Returns: An instance of type `T` if decode succeeded, otherwise `nil`
    private func parseJson<T: Decodable>(data: Data) -> T? {
        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            print(error)
            print(error.localizedDescription)
            return nil
        }
    }
}

//
//  HttpClient.swift
//  HttpClient
//
//  Created by Pontus Nilsson Tengnäs on 2019-05-01.
//  Copyright © 2019 Pontus Nilsson Tengnäs. All rights reserved.
//

import Foundation

public struct HttpClient {
    
    public init() { }
    
    public func httpRequest(url: String,
                            httpMethod: HCHttpMethod,
                            headers: [String: String]? = nil,
                            body: Data? = nil,
                            cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
                            timeout: Int = 30,
                            completionHandler: @escaping (_ result: HCClientResponse?) -> ()) {
        
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
        
        performRequest(request: request) { (requestResult) in
            if let requestResult = requestResult {
                completionHandler(requestResult)
            } else {
                completionHandler(HCClientResponse.failure("Unknown failure in performRequest function"))
            }
        }
    }
    
    private func performRequest(request: URLRequest,
                                completionHandler: @escaping (_ result: HCClientResponse?) -> ()) {
        
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
            
            if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300{
                guard let dataObj = data else {
                    completionHandler(HCClientResponse.badInput("Data object is empty"))
                    return
                }
                
                completionHandler(HCClientResponse.success(httpResponse.statusCode, dataObj))
            } else {
                completionHandler(HCClientResponse.httpFailure(httpResponse.statusCode))
            }
            
            return
        }
        
        task.resume()
    }
}

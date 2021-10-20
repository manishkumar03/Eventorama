//
//  NetworkingClient.swift
//  EventoramaSDK
//
//  Created by Manish Kumar on 2021-10-20.
//

import Foundation

protocol NetworkingClientProtocol {
    
}

public class NetworkingClient: NetworkingClientProtocol {
    lazy var urlSession: URLSessionProtocol = URLSession.shared
    
    public func postEvents(params: [[String: Any]], onSuccess: @escaping (Bool) -> Void, onError: @escaping (Bool) -> Void) {
        let baseURL = URL(string: "http://httpbin.org")!
        let remotePath = "post"
        let erEventUrl = baseURL.appendingPathComponent(remotePath)
        
        var request = URLRequest(url: erEventUrl)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        //build our request body
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let postMediaDataTask = urlSession.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let _ = data else {
                return onError(false)
            }
            
            let httpUrlResponse = response as? HTTPURLResponse
            if let httpStatusCode = httpUrlResponse?.statusCode, httpStatusCode >= 400 {
                return onError(false)
            } else {
                return onSuccess(true)
            }
        })
        
        postMediaDataTask.resume()
    }
}

protocol URLSessionProtocol: AnyObject {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}



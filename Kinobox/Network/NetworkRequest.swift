//
//  NetworkRequest.swift
//  Kinobox
//
//  Created by Елена Горбунова on 02.08.2023.
//

import UIKit

class NetworkRequest {
    
    static let shared = NetworkRequest()
    private init() {}
    
    func requestDataFetch(urlString: String, completion: @escaping (Result<Data, Error>) -> ()) {
        
        guard let urlEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        guard let url = URL(string: urlEncoded) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                
                completion(.success(data))
            }
        }
        .resume()
    }
}

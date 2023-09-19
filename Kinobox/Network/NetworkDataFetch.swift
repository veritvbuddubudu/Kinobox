//
//  NetworkDataFetch.swift
//  Kinobox
//
//  Created by Елена Горбунова on 03.08.2023.
//

import UIKit

class NetworkDataFetch {
    
    static let shared = NetworkDataFetch()
    private init() {}
    
    func fetchMovieSearch(urlString: String, responce: @escaping (MovieCellModel?, Error?) -> ()) {
        
        NetworkRequest.shared.requestDataFetch(urlString: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let json = try JSONDecoder().decode(MovieCellModel.self, from: data)
                    responce (json, nil)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                }
            case .failure(let error):
                print("Error received requesting data \(error.localizedDescription)")
                responce(nil, error)
            }
        }
    }
    
    func fetchMovie(urlString: String, responce: @escaping (Movie?, Error?) -> ()) {

        NetworkRequest.shared.requestDataFetch(urlString: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let json = try JSONDecoder().decode(Movie.self, from: data)
                    responce (json, nil)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                }
            case .failure(let error):
                print("Error received requesting data \(error.localizedDescription)")
                responce(nil, error)
            }
        }
    }
}

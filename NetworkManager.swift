//
//  File.swift
//  NetworkSDK
//
//  Created by Apple on 16/05/24.
//

import Foundation

public class NetworkManager {
    private let apiKey = "909594533c98883408adef5d56143539"
    private let baseURL = "https://api.themoviedb.org/3"
    
    public init() {}
    
    public func fetchMovies(category: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(baseURL)/movie/\(category)?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

public struct Movie: Decodable {
    public let id: Int
    public let title: String
    public let overview: String
    public let posterPath: String
}

public struct MovieResponse: Decodable {
    public let results: [Movie]
}

public enum NetworkError: Error {
    case invalidURL
    case noData
}

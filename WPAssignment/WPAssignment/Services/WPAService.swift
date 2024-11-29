//
//  WPAService.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 30/11/24.
//

import Foundation

class WPAService {
    func fetchData<T: Decodable>(from urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(APIError.decodingError))
            }
        }.resume()
    }
}

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
}

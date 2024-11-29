//
//  CreditCardService.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 29/11/24.
//

import Foundation

class CreditCardService {
    static let shared = CreditCardService()
    
    func fetchCards(completion: @escaping (Result<[CreditCard], Error>) -> Void) {
        guard let url = URL(string: "https://random-data-api.com/api/v2/credit_cards?size=100") else {
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
                let cards = try JSONDecoder().decode([CreditCard].self, from: data)
                completion(.success(cards))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
}

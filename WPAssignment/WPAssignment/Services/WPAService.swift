//
//  WPAService.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 30/11/24.
//

import Foundation
import Combine

protocol NetworkSession {
    func dataTask(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

protocol APIServiceProtocol {
    func fetchData<T: Decodable>(from urlString: String) -> Future<T, Error>
}

extension URLSession: NetworkSession {}

class WPAService: APIServiceProtocol {
    private let session: NetworkSession
    
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchData<T: Decodable>(from urlString: String) -> Future<T, Error> {
        return Future { promise in
            guard let url = URL(string: urlString) else {
                promise(.failure(APIError.invalidURL))
                return
            }
            
            self.session.dataTask(with: url) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let data = data else {
                    promise(.failure(APIError.noData))
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    promise(.success(decodedData))
                } catch {
                    promise(.failure(APIError.decodingError))
                }
            }.resume()
        }
    }
}

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
}

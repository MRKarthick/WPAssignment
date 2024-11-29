//
//  CreditCardService.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 29/11/24.
//

import Foundation

class WPACreditCardService {
    static let kRandomAPIV2URL: String = "\(WPAURLConstants.kRandomAPIV2URL)/credit_cards"

    static let shared = WPACreditCardService()
    private let apiService = WPAService()
    
    func fetchCards(completion: @escaping (Result<[WPACreditCard], Error>) -> Void) {
        let urlString = "\(WPACreditCardService.kRandomAPIV2URL)?size=100"
        print("urlString is \(urlString)")
        apiService.fetchData(from: urlString, completion: completion)
    }
}




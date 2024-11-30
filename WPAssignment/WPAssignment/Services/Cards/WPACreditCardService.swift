//
//  CreditCardService.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 29/11/24.
//

import Foundation
import SwiftData

class WPACreditCardService {
    static let kRandomAPIV2URL: String = "\(WPAURLConstants.kRandomAPIV2URL)/credit_cards"
    
    static let shared = WPACreditCardService()
    private let apiService = WPAService()
    
    func fetchCards(completion: @escaping (Result<[WPACreditCardDTO], Error>) -> Void) {
        let urlString = "\(WPACreditCardService.kRandomAPIV2URL)?size=100"
        apiService.fetchData(from: urlString) { (result: Result<[WPACreditCardModel], Error>) in
            switch result {
            case .success(let models):
                let modelDTO = models.map { model in
                    return WPACreditCardDTO.getDTOfrom(model)
                }
                Task { @MainActor in
                    self.persistRetrieveAndPrint(models)
                }
                completion(.success(modelDTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    @MainActor func persistRetrieveAndPrint(_ models: [WPACreditCardModel]) {
        for model in models {
            let entity = WPACreditCardEntity.getDTOfrom(model)
            WPACreditCardPersistence.shared.saveCard(entity)
        }
    }
}




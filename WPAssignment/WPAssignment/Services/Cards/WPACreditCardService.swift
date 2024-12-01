//
//  CreditCardService.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 29/11/24.
//

import Foundation
import SwiftData

class WPACreditCardService {
    static let kCreditCardsURL: String = "\(WPAURLConstants.kRandomAPIV2URL)/credit_cards"
    
    static let shared = WPACreditCardService()
    private let apiService = WPAService()
    
    // Currently there is no API to persist bookmark in Backend. So the service layer here just persists in SQLite DB
    func bookmarkCreditCard(ccUid: String) {
        Task { @MainActor in
            WPACreditCardPersistence.shared.bookmarkCreditCard(with: ccUid)
        }
    }
    
    // Currently there is no API to fetch bookmark from Backend. So the service layer here just retrieves it from SQLite DB
    func fetchBookmarkedCards(completion: @escaping (Result<[WPACreditCardDTO], Error>) -> Void) {
        Task { @MainActor in
            let creditCards: [WPACreditCardEntity] = WPACreditCardPersistence.shared.fetchBookmarkedCreditCards()
            let modelDTOs = creditCards.map { model in
                return WPACreditCardDTO.getDTOfrom(model)
            }
            completion(.success(modelDTOs))
        }
    }

    func fetchCards(completion: @escaping (Result<[WPACreditCardDTO], Error>) -> Void, isForceFetch: Bool = false) {
        guard isForceFetch else {
            Task { @MainActor in
                let creditCards: [WPACreditCardEntity] = WPACreditCardPersistence.shared.fetchCreditCards()
                let modelDTOs = creditCards.map { model in
                    return WPACreditCardDTO.getDTOfrom(model)
                }
                
                if modelDTOs.isEmpty {
                    fetchCards(completion: completion, isForceFetch: true)
                }
                completion(.success(modelDTOs))
            }
            return
        }
        
        let urlString = "\(WPACreditCardService.kCreditCardsURL)?size=100"
        apiService.fetchData(from: urlString) { (result: Result<[WPACreditCardModel], Error>) in
            switch result {
            case .success(let models):
                Task { @MainActor in
                    self.persistCreditCardDetails(models, deleteExistingData: isForceFetch)
                    self.fetchCards(completion: completion, isForceFetch: false)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    @MainActor func persistCreditCardDetails(_ models: [WPACreditCardModel], deleteExistingData: Bool = true) {
        if deleteExistingData {
            WPACreditCardPersistence.shared.deleteAllCreditCards()
        }
        
        for model in models {
            let entity = WPACreditCardEntity.getDTOfrom(model)
            WPACreditCardPersistence.shared.saveCard(entity)
        }
    }
}




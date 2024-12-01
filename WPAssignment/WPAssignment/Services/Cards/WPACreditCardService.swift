//
//  CreditCardService.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 29/11/24.
//

import Foundation
import Combine

protocol WPACreditCardServiceProtocol {
    func fetchCards(isForceFetch: Bool) -> AnyPublisher<[WPACreditCardDTO], Error>
    func fetchBookmarkedCards() -> AnyPublisher<[WPACreditCardDTO], Error>
    func updateBookmark(forCardWithCcUid ccUid: String, withValue isBookmarked: Bool)
}

class WPACreditCardService: WPACreditCardServiceProtocol {
    static let kCreditCardsURL: String = "\(WPAURLConstants.kRandomAPIV2URL)/credit_cards"
    
    static let shared = WPACreditCardService()
    
    private let apiService = WPAService()
    private var cancellables = Set<AnyCancellable>()
    
    func updateBookmark(forCardWithCcUid ccUid: String, withValue isBookmarked: Bool) {
        Task { @MainActor in
            let result = WPACreditCardPersistence.shared.updateBookmark(forCardWithCcUid: ccUid, withValue: isBookmarked)
            if case .failure(let error) = result {
                debugPrint("Failed to update bookmark: \(error)")
            }
        }
    }
    
    func fetchBookmarkedCards() -> AnyPublisher<[WPACreditCardDTO], Error> {
        Future { promise in
            Task { @MainActor in
                let result = WPACreditCardPersistence.shared.fetchBookmarkedCreditCards()
                switch result {
                case .success(let creditCards):
                    let modelDTOs = creditCards.map { WPACreditCardDTO.getDTOfrom($0) }
                    promise(.success(modelDTOs))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchCards(isForceFetch: Bool = false) -> AnyPublisher<[WPACreditCardDTO], Error> {
        if isForceFetch {
            let urlString = "\(WPACreditCardService.kCreditCardsURL)?size=100"
            return apiService.fetchData(from: urlString)
                .flatMap { (models: [WPACreditCardModel]) -> AnyPublisher<[WPACreditCardDTO], Error> in
                    Task { @MainActor in
                        self.persistCreditCardDetails(models, deleteExistingData: isForceFetch)
                    }
                    return self.fetchCards(isForceFetch: false)
                }
                .eraseToAnyPublisher()
        } else {
            return Future { promise in
                Task { @MainActor in
                    let result = WPACreditCardPersistence.shared.fetchCreditCards()
                    switch result {
                    case .success(let creditCards):
                        let modelDTOs = creditCards.map { WPACreditCardDTO.getDTOfrom($0) }
                        if modelDTOs.isEmpty {
                            self.fetchCards(isForceFetch: true)
                                .sink(receiveCompletion: { completion in
                                    if case .failure(let error) = completion {
                                        promise(.failure(error))
                                    }
                                }, receiveValue: { value in
                                    promise(.success(value))
                                })
                                .store(in: &self.cancellables)
                        } else {
                            promise(.success(modelDTOs))
                        }
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
            .eraseToAnyPublisher()
        }
    }
    
    @MainActor func persistCreditCardDetails(_ models: [WPACreditCardModel], deleteExistingData: Bool = true) {
        if deleteExistingData {
            let result = WPACreditCardPersistence.shared.deleteAllCreditCards()
            if case .failure(let error) = result {
                debugPrint("Failed to delete existing credit cards: \(error)")
            }
        }
        
        for model in models {
            let entity = WPACreditCardEntity.getDTOfrom(model)
            let result = WPACreditCardPersistence.shared.saveCard(entity)
            if case .failure(let error) = result {
                debugPrint("Failed to save credit card: \(error)")
            }
        }
    }
}




//
//  CreditCardService.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 29/11/24.
//

import Foundation
import Combine

class WPACreditCardService {
    static let kCreditCardsURL: String = "\(WPAURLConstants.kRandomAPIV2URL)/credit_cards"
    
    static let shared = WPACreditCardService()
    private let apiService = WPAService()
    
    // Currently there is no API to persist bookmark in Backend. So the service layer here just persists in SQLite DB
    func updateBookmark(forCardWithCcUid ccUid: String, withValue isBookmarked: Bool) {
        Task { @MainActor in
            WPACreditCardPersistence.shared.updateBookmark(forCardWithCcUid: ccUid, withValue: isBookmarked)
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
                    let creditCards: [WPACreditCardEntity] = WPACreditCardPersistence.shared.fetchCreditCards()
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
                }
            }
            .eraseToAnyPublisher()
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
    
    private var cancellables = Set<AnyCancellable>()
}




//
//  CreditCardViewModel.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 29/11/24.
//

import SwiftUI
import SwiftData
import Combine

class WPACreditCardViewModel: ObservableObject {
    static let kCardsSize: Int = 100
    
    @Published var isLoading: Bool = false
    @Published var groupedCards: [(key: String, value: [WPACreditCardDTO])] = []
    @Published var errorMessage: String? = nil
    
    var cardsDto: [WPACreditCardDTO] = []
    private var cancellables = Set<AnyCancellable>()
    private let cardService: WPACreditCardServiceProtocol
    
    // Initializer with dependency injection for card service
    init(cardService: WPACreditCardServiceProtocol = WPACreditCardService.shared) {
        self.cardService = cardService
    }
    
    // Fetches cards, optionally forcing a refresh
    func fetchCards(isForceFetch: Bool = false) {
        isLoading = true
        cardService.fetchCards(isForceFetch: isForceFetch, size: WPACreditCardViewModel.kCardsSize)
            .receive(on: DispatchQueue.main) // Ensure updates are on the main thread
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = "\(WPAErrorConstants.kFailedCreditCardsErrorTitle): \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] fetchedCards in
                // Use the static method for grouping and sorting
                self?.cardsDto = fetchedCards
                self?.groupedCards = WPACreditCardDTO.groupAndSortCreditCards(fetchedCards)
                self?.errorMessage = nil
            })
            .store(in: &cancellables)
    }
    
    // Toggles the bookmark status of a card
    func toggleBookmark(card: WPACreditCardDTO) {
        // Update the bookmark status in the service
        cardService.updateBookmark(forCardWithCcUid: card.ccUid, withValue: !card.isBookmarked)
        
        // Update the local card's bookmark status
        if let index = cardsDto.firstIndex(where: { $0.ccUid == card.ccUid }) {
            cardsDto[index].isBookmarked.toggle()
            
            // Reflect changes in groupedCards
            groupedCards = WPACreditCardDTO.groupAndSortCreditCards(cardsDto)
        }
    }
}

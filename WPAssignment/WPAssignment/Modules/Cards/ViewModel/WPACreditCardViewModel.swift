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
    @Published var groupedCards: [(key: String, value: [WPACreditCardDTO])] = []
    @Published var cardsDto: [WPACreditCardDTO] = []
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    private let cardService: WPACreditCardServiceProtocol
    
    // Initializer with dependency injection for card service
    init(cardService: WPACreditCardServiceProtocol = WPACreditCardService.shared) {
        self.cardService = cardService
    }
    
    // Fetches cards, optionally forcing a refresh
    func fetchCards(isForceFetch: Bool = false) {
        cardService.fetchCards(isForceFetch: isForceFetch)
            .receive(on: DispatchQueue.main) // Ensure updates are on the main thread
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = "Failed to fetch cards: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] fetchedCards in
                // Group fetched cards by type and sort them
                self?.groupedCards = Dictionary(grouping: fetchedCards, by: { $0.ccType }).sorted(by: { $0.key < $1.key })
            })
            .store(in: &cancellables)
    }
    
    // Toggles the bookmark status of a card
    func toggleBookmark(card: WPACreditCardDTO) {
        cardService.updateBookmark(forCardWithCcUid: card.ccUid, withValue: !card.isBookmarked)
    }
}

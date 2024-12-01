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
    
    func fetchCards(isForceFetch: Bool = false) {
        WPACreditCardService.shared.fetchCards(isForceFetch: isForceFetch)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = "Failed to fetch cards: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] fetchedCards in
                self?.groupedCards = Dictionary(grouping: fetchedCards, by: { $0.ccType }).sorted(by: { $0.key < $1.key })
            })
            .store(in: &cancellables)
    }
    
    func toggleBookmark(card: WPACreditCardDTO) {
        WPACreditCardService.shared.updateBookmark(forCardWithCcUid: card.ccUid, withValue: !card.isBookmarked)
    }
}

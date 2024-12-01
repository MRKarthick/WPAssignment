//
//  CreditCardViewModel.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 29/11/24.
//

import SwiftUI
import SwiftData

class WPACreditCardViewModel: ObservableObject {
    @Published var groupedCards: [(key: String, value: [WPACreditCardDTO])] = []
    @Published var cardsDto: [WPACreditCardDTO] = []
    @Published var errorMessage: String? = nil
    
    func fetchCards(isForceFetch: Bool = false) {
        WPACreditCardService.shared.fetchCards(completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedCards):
                    self?.groupedCards = Dictionary(grouping: fetchedCards, by: { $0.ccType }).sorted(by: { $0.key < $1.key })
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }, isForceFetch: isForceFetch)
    }
    
    func toggleBookmark(card: WPACreditCardDTO) {
        WPACreditCardService.shared.updateBookmark(forCardWithCcUid: card.ccUid, withValue: !card.isBookmarked)
    }
}

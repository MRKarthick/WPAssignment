//
//  CreditCardViewModel.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 29/11/24.
//

import SwiftUI
import SwiftData

class CreditCardViewModel: ObservableObject {
    @Published var cards: [CreditCard] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Environment(\.modelContext) var modelContext
    
    func fetchCards() {
        isLoading = true
        CreditCardService.shared.fetchCards { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let fetchedCards):
                    self?.cards = fetchedCards
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func bookmark(card: CreditCard) {
        // card.isBookmarked.toggle()
        // modelContext.saveIfNeeded()
    }
    
    func groupCards(by type: String) -> [CreditCard] {
        cards.filter { $0.credit_card_type == type }
    }
}

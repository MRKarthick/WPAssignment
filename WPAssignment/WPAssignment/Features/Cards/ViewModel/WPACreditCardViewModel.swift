//
//  CreditCardViewModel.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 29/11/24.
//

import SwiftUI
import SwiftData

class WPACreditCardViewModel: ObservableObject {
    @Published var cardsDto: [WPACreditCardDTO] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
        
    func fetchCards(isForceFetch: Bool = false) {
        isLoading = true
        
        WPACreditCardService.shared.fetchCards(completion: { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let fetchedCards):
                    self?.cardsDto = fetchedCards
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }, isForceFetch: isForceFetch)
    }
    
    func bookmark(card: WPACreditCardDTO) {
        // card.isBookmarked.toggle()
        // modelContext.saveIfNeeded()
    }
    
    func groupCards(by type: String) -> [WPACreditCardDTO] {
        return cardsDto.filter { $0.ccType == type }
    }
}

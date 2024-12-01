//
//  WPABookmarksViewModel.swift
//  WPAssignment
//
//  Created by EdgeCaseDesigns on 30/11/24.
//

import Foundation

class WPABookmarksViewModel: ObservableObject {
    @Published var groupedBookmarks: [(key: String, value: [WPACreditCardDTO])] = []
    @Published var errorMessage: String? = nil

    func fetchBookmarkedCards() {
        WPACreditCardService.shared.fetchBookmarkedCards(completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedCards):
                    self?.groupedBookmarks = Dictionary(grouping: fetchedCards, by: { $0.ccType }).sorted(by: { $0.key < $1.key })
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        })
    }
}

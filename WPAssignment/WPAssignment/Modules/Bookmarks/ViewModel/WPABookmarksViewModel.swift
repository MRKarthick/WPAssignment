//
//  WPABookmarksViewModel.swift
//  WPAssignment
//
//  Created by EdgeCaseDesigns on 30/11/24.
//

import Foundation
import Combine

class WPABookmarksViewModel: ObservableObject {
    @Published var groupedBookmarks: [(key: String, value: [WPACreditCardDTO])] = []
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchBookmarkedCards() {
        WPACreditCardService.shared.fetchBookmarkedCards()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = "Failed to fetch bookmarks: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] fetchedCards in
                self?.groupedBookmarks = self?.groupAndSortBookmarks(fetchedCards) ?? []
            })
            .store(in: &cancellables)
    }
    
    private func groupAndSortBookmarks(_ cards: [WPACreditCardDTO]) -> [(key: String, value: [WPACreditCardDTO])] {
        return Dictionary(grouping: cards, by: { $0.ccType })
            .sorted(by: { $0.key < $1.key })
    }
}

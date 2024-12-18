//
//  WPABookmarksViewModel.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 30/11/24.
//

import Foundation
import Combine

class WPABookmarksViewModel: ObservableObject {
    // Published properties to notify the view of changes
    @Published var groupedBookmarks: [(key: String, value: [WPACreditCardDTO])] = []
    @Published var errorMessage: String? = nil
    
    // Set to hold any Combine cancellables to manage memory
    private var cancellables = Set<AnyCancellable>()
    private let creditCardService: WPACreditCardServiceProtocol
    
    // Dependency injection of the credit card service
    init(creditCardService: WPACreditCardServiceProtocol = WPACreditCardService.shared) {
        self.creditCardService = creditCardService
    }
    
    func fetchBookmarkedCards() {
        creditCardService.fetchBookmarkedCards()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = "\(WPAErrorConstants.kFailedBookmarksErrorTitle): \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] fetchedCards in
                // Use the static method for grouping and sorting
                self?.groupedBookmarks = WPACreditCardDTO.groupAndSortCreditCards(fetchedCards)
                self?.errorMessage = nil
            })
            // Store the cancellable to manage the subscription's lifecycle
            .store(in: &cancellables)
    }
}

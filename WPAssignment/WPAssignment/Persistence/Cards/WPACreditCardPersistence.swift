//
//  WPACreditCardPersistence.swift
//  WPAssignment
//
//  Created by EdgeCaseDesigns on 30/11/24.
//

import Foundation
import SwiftData
import SwiftUICore
import _SwiftData_SwiftUI

class WPACreditCardPersistence {
    private let modelContainer: ModelContainer
    
    static let shared = WPACreditCardPersistence()
    
    init() {
        do {
            self.modelContainer = try ModelContainer(for: WPACreditCardEntity.self)
        } catch {
            fatalError("Failed to initialize WPACreditCardPersistence ModelContainer: \(error)")
        }
    }
    
    // Initializer for testing and preview purposes
    init(container: ModelContainer) {
        self.modelContainer = container
    }
    
    @MainActor func saveCard(_ creditCard: WPACreditCardEntity) {
        let context = modelContainer.mainContext
        context.insert(creditCard)
        
        do {
            try context.save()
        } catch {
            debugPrint("WPACreditCardPersistence: Failed to save credit card: \(error)")
        }
    }
    
    @MainActor func fetchCreditCards() -> [WPACreditCardEntity] {
        let context = modelContainer.mainContext
        let fetchRequest = FetchDescriptor<WPACreditCardEntity>()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            debugPrint("WPACreditCardPersistence: Failed to fetch credit cards: \(error)")
            return []
        }
    }
    
    @MainActor func deleteAllCreditCards(excludingBookmarks: Bool = true) {
        let context = modelContainer.mainContext
        
        // Update the fetch request to exclude bookmarked credit cards
        let fetchRequest: FetchDescriptor<WPACreditCardEntity>
        if excludingBookmarks {
            fetchRequest = FetchDescriptor<WPACreditCardEntity>(predicate: #Predicate { !$0.isBookmarked })
        } else {
            fetchRequest = FetchDescriptor<WPACreditCardEntity>()
        }
        
        do {
            let creditCards = try context.fetch(fetchRequest)
            creditCards.forEach { context.delete($0) }
            try context.save()
        } catch {
            debugPrint("WPACreditCardPersistence: Failed to delete all credit cards: \(error)")
        }
    }
    
    @MainActor func updateBookmark(forCardWithCcUid ccUid: String, withValue isBookmarked: Bool) {
        let context = modelContainer.mainContext
        let fetchRequest = FetchDescriptor<WPACreditCardEntity>(predicate: #Predicate { $0.ccUid == ccUid })
        
        do {
            if let creditCard = try context.fetch(fetchRequest).first {
                creditCard.isBookmarked = isBookmarked
                try context.save()
            } else {
                debugPrint("WPACreditCardPersistence: No credit card found with ccUid: \(ccUid)")
            }
        } catch {
            debugPrint("WPACreditCardPersistence: Failed to bookmark credit card: \(error)")
        }
    }
    
    @MainActor func fetchBookmarkedCreditCards() -> [WPACreditCardEntity] {
        let context = modelContainer.mainContext
        let fetchRequest = FetchDescriptor<WPACreditCardEntity>(predicate: #Predicate { $0.isBookmarked })
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            debugPrint("WPACreditCardPersistence: Failed to fetch Bookmarked credit cards: \(error)")
            return []
        }
    }
}

extension ModelContainer {
    // Creates a temporary in-memory ModelContainer for testing and preview use
    @MainActor static func temporary(entities: any PersistentModel.Type, withMockData mockData: [any PersistentModel] = []) -> ModelContainer {
        do {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: entities, configurations: configuration)
            let context = container.mainContext

            mockData.forEach { context.insert($0) }
            try context.save()
            return container
        } catch {
            fatalError("Failed to initialize temporary ModelContainer: \(error)")
        }
    }
}

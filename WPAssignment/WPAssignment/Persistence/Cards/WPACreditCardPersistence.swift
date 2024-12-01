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

enum CreditCardPersistenceError: Error {
    case initializationFailed(String)
    case saveFailed(Error)
    case fetchFailed(Error)
    case deleteFailed(Error)
    case cardNotFound(String)
    
    var localizedDescription: String {
        switch self {
        case .initializationFailed(let message):
            return "Initialization failed: \(message)"
        case .saveFailed(let error):
            return "Save failed: \(error.localizedDescription)"
        case .fetchFailed(let error):
            return "Fetch failed: \(error.localizedDescription)"
        case .deleteFailed(let error):
            return "Delete failed: \(error.localizedDescription)"
        case .cardNotFound(let ccUid):
            return "No credit card found with ccUid: \(ccUid)"
        }
    }
}

class WPACreditCardPersistence {
    private let modelContainer: ModelContainer
    
    static let shared = WPACreditCardPersistence()
    
    init() {
        do {
            self.modelContainer = try ModelContainer(for: WPACreditCardEntity.self)
        } catch {
            fatalError(CreditCardPersistenceError.initializationFailed("\(error)").localizedDescription)
        }
    }
    
    // Initializer for testing and preview purposes
    init(container: ModelContainer) {
        self.modelContainer = container
    }
    
    @MainActor func saveCard(_ creditCard: WPACreditCardEntity) -> Result<Void, CreditCardPersistenceError> {
        let context = modelContainer.mainContext
        context.insert(creditCard)
        
        do {
            try context.save()
            return .success(())
        } catch {
            debugPrint("WPACreditCardPersistence: Failed to save credit card: \(error)")
            return .failure(.saveFailed(error))
        }
    }
    
    @MainActor func fetchCreditCards() -> Result<[WPACreditCardEntity], CreditCardPersistenceError> {
        let context = modelContainer.mainContext
        let fetchRequest = FetchDescriptor<WPACreditCardEntity>()
        
        do {
            let cards = try context.fetch(fetchRequest)
            return .success(cards)
        } catch {
            debugPrint("WPACreditCardPersistence: Failed to fetch credit cards: \(error)")
            return .failure(.fetchFailed(error))
        }
    }
    
    @MainActor func deleteAllCreditCards(excludingBookmarks: Bool = true) -> Result<Void, CreditCardPersistenceError> {
        let context = modelContainer.mainContext
        let fetchRequest = createFetchRequest(excludingBookmarks: excludingBookmarks)
        
        do {
            let creditCards = try context.fetch(fetchRequest)
            creditCards.forEach { context.delete($0) }
            try context.save()
            return .success(())
        } catch {
            debugPrint("WPACreditCardPersistence: Failed to delete all credit cards: \(error)")
            return .failure(.deleteFailed(error))
        }
    }
    
    @MainActor func updateBookmark(forCardWithCcUid ccUid: String, withValue isBookmarked: Bool) -> Result<Void, CreditCardPersistenceError> {
        let context = modelContainer.mainContext
        let fetchRequest = FetchDescriptor<WPACreditCardEntity>(predicate: #Predicate { $0.ccUid == ccUid })
        
        do {
            if let creditCard = try context.fetch(fetchRequest).first {
                creditCard.isBookmarked = isBookmarked
                try context.save()
                return .success(())
            } else {
                debugPrint("WPACreditCardPersistence: No credit card found with ccUid: \(ccUid)")
                return .failure(.cardNotFound(ccUid))
            }
        } catch {
            debugPrint("WPACreditCardPersistence: Failed to bookmark credit card: \(error)")
            return .failure(.saveFailed(error))
        }
    }
    
    @MainActor func fetchBookmarkedCreditCards() -> Result<[WPACreditCardEntity], CreditCardPersistenceError> {
        let context = modelContainer.mainContext
        let fetchRequest = FetchDescriptor<WPACreditCardEntity>(predicate: #Predicate { $0.isBookmarked })
        
        do {
            let cards = try context.fetch(fetchRequest)
            return .success(cards)
        } catch {
            debugPrint("WPACreditCardPersistence: Failed to fetch Bookmarked credit cards: \(error)")
            return .failure(.fetchFailed(error))
        }
    }
    
    private func createFetchRequest(excludingBookmarks: Bool) -> FetchDescriptor<WPACreditCardEntity> {
        if excludingBookmarks {
            return FetchDescriptor<WPACreditCardEntity>(predicate: #Predicate { !$0.isBookmarked })
        } else {
            return FetchDescriptor<WPACreditCardEntity>()
        }
    }
}

extension ModelContainer {
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

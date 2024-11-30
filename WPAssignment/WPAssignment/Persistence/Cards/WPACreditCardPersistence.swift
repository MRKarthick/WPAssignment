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
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    @MainActor func saveCard(_ creditCard: WPACreditCardEntity) {
        let context = modelContainer.mainContext
        context.insert(creditCard)
        
        do {
            try context.save()
        } catch {
            debugPrint("Failed to save credit card: \(error)")
        }
    }
    
    @MainActor func fetchCreditCards() -> [WPACreditCardEntity] {
        let context = modelContainer.mainContext
        
        let fetchRequest = FetchDescriptor<WPACreditCardEntity>()
        
        do {
            let creditCards = try context.fetch(fetchRequest)
            return creditCards
        } catch {
            debugPrint("Failed to fetch credit cards: \(error)")
            return []
        }
    }
    
    @MainActor func deleteAllCreditCards() {
        let context = modelContainer.mainContext
        
        let fetchRequest = FetchDescriptor<WPACreditCardEntity>()
        
        do {
            let creditCards = try context.fetch(fetchRequest)
            creditCards.forEach { context.delete($0) }
            try context.save()
        } catch {
            debugPrint("Failed to delete all credit cards: \(error)")
        }
    }
}
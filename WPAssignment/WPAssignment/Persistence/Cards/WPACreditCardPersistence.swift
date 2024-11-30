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

    @Query private var creditCards: [WPACreditCardEntity]
    
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
    
    func retrieveCreditCards() -> [WPACreditCardEntity] {
        return creditCards
    }
}

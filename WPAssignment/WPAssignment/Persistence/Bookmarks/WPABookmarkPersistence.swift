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

class WPABookmarkPersistence {
    private let modelContainer: ModelContainer
    
    static let shared = WPABookmarkPersistence()
    
    init() {
        do {
            self.modelContainer = try ModelContainer(for: WPABookmarkEntity.self)
        } catch {
            fatalError("Failed to initialize WPABookmarkPersistence ModelContainer: \(error)")
        }
    }
    
    @MainActor func saveBookmark(_ bookmark: WPABookmarkEntity) {
        let context = modelContainer.mainContext
        context.insert(bookmark)
        
        do {
            try context.save()
        } catch {
            debugPrint("WPABookmarkPersistence: Failed to save Bookmark: \(error)")
        }
    }
    
    @MainActor func fetchBookmarks(byContentType contentType: String) -> [WPABookmarkEntity] {
        let context = modelContainer.mainContext
        
        let fetchRequest = FetchDescriptor<WPABookmarkEntity>(predicate: #Predicate { $0.contentType == contentType })
        
        do {
            let bookmarks = try context.fetch(fetchRequest)
            return bookmarks
        } catch {
            debugPrint("WPABookmarkPersistence: Failed to fetch Bookmarks with \(contentType): \(error)")
            return []
        }
    }
}

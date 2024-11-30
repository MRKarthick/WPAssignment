//
//  WPABookmarkEntity.swift
//  WPAssignment
//
//  Created by EdgeCaseDesigns on 01/12/24.
//

import Foundation
import SwiftData

@Model
final class WPABookmarkEntity {
    var id: UInt64
    var contentId: String
    var contentType: String
    
    init(id: UInt64, contentId: String, contentType: String) {
        self.id = id
        self.contentId = contentId
        self.contentType = contentType
    }
}

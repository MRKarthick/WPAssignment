//
//  WPAError.swift
//  WPAssignment
//
//  Created by EdgeCaseDesigns on 01/12/24.
//

import Foundation
import os

// Define a custom error type
enum WPAError: LocalizedError {
    case networkError(Error)
    case persistenceError(Error)
    case unknownError

    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .persistenceError(let error):
            return "Persistence error: \(error.localizedDescription)"
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}

// Centralized error handler
class WPAErrorHandler {
    static func handle(_ error: WPAError, context: String) {
        // Log the error
        os_log("Error in %{public}@: %{public}@", log: .default, type: .error, context, error.localizedDescription)
        
        // uncomment
        // showAlert(with: error.localizedDescription)
    }
}

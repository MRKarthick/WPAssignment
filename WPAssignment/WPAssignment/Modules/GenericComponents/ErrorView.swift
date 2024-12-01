//
//  ErrorView.swift
//  WPAssignment
//
//  Created by EdgeCaseDesigns on 01/12/24.
//

import Foundation
import SwiftUI

struct ErrorView: View {
    let errorMessage: String

    var body: some View {
        Text("\(WPAErrorConstants.kGenericErrorTitle): \(errorMessage)")
            .multilineTextAlignment(.center)
            .padding()
    }
}

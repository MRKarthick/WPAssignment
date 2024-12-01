//
//  ErrorView.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 01/12/24.
//

import Foundation
import SwiftUI

struct WPAErrorView: View {
    let errorMessage: String

    var body: some View {
        Text("\(WPAErrorConstants.kGenericErrorTitle): \(errorMessage)")
            .multilineTextAlignment(.center)
            .padding()
    }
}

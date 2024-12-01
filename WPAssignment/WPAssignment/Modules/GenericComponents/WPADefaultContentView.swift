//
//  WPADefaultContentView.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 01/12/24.
//

import Foundation
import SwiftUI

struct WPADefaultContentView: View {
    let content: String

    var body: some View {
        Text("\(content)")
            .multilineTextAlignment(.center)
            .padding()
    }
}

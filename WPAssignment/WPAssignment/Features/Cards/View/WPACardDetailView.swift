//
//  CardDetailView.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 29/11/24.
//
import SwiftUI

struct WPACardDetailView: View {
    let creditCard: WPACreditCardDTO

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Credit Card Number: \(creditCard.ccNumber)")
                .font(.headline)
            Text("Expiry Date: \(creditCard.ccExpiryDate)")
                .font(.subheadline)
            Text("Card Type: \(creditCard.ccType)")
                .font(.subheadline)
        }
        .padding()
        .navigationTitle("Card Details")
    }
}

// Sample Preview
struct WPACardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WPACardDetailView(creditCard: WPACreditCardDTO(
            ccId: 1, ccUid: "12345", ccNumber: "1234 5678 9012 3456", ccExpiryDate: "12/24", ccType: "Visa"
        ))
    }
}

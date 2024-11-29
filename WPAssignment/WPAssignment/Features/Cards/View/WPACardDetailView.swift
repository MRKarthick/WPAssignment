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
            Text("Credit Card Number: \(creditCard.credit_card_number)")
                .font(.headline)
            Text("Expiry Date: \(creditCard.credit_card_expiry_date)")
                .font(.subheadline)
            Text("Card Type: \(creditCard.credit_card_type)")
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
            id: 1,
            uid: "12345",
            credit_card_number: "1234 5678 9012 3456",
            credit_card_expiry_date: "12/24",
            credit_card_type: "Visa"
        ))
    }
}

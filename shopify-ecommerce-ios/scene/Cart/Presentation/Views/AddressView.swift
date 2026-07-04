//
//  AddressView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 18/01/1448 AH.
//

import SwiftUI

struct AddressView: View {
    let address: String
    let contact: String
    let editAction: () -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack{
                Text("Address:")
                    .font(.system(size: 14, weight: .medium))
                Spacer()
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 14))
                    .onTapGesture {
                        editAction()
                    }
            }
            Text(address)
                .font(.system(size: 14, weight: .light))
            Text("Contact: \(contact)")
                .font(.system(size: 14, weight: .light))
        }
        .padding(12)
        .frame(width: .infinity, height: 80)
        .background(.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 0)
    }
}

#Preview {
    AddressView(address: "216 St Paul's Rd, London N1 2LL, UK", contact: "+44-784232", editAction: {})
}

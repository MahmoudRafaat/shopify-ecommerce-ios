//
//  CartScreenView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 18/01/1448 AH.
//

import SwiftUI

struct CartScreenView: View {
    
    let viewModel: CartViewModel
    
    var body: some View {
        ScrollView{
            VStack (alignment: .leading){
                // Delivery Section
                HStack(spacing: 8){
                    Image(systemName: "mappin.and.ellipse")
                    Text("Delivery Address")
                }
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal, 16)
                HStack(spacing: 12){
                    AddressView(address: "216 St Paul's Rd, London N1 2LL, UK", contact: "+44-784232", editAction: {})
                    AddButtonView(action: {})
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                // Shoping List
                Text("Shopping List")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top, 24)
                    .padding(.horizontal, 16)
                
                ForEach( 0 ..< viewModel.cartProducts.count, id: \.self ) { index in
                    ProductCartView(productCardState: viewModel.cartProducts[index]) { productCart in
                        // we will navigate to Product Details
                    }
                }.padding(14)
            }
        }
    }
}

#Preview {
    CartScreenView(viewModel: CartViewModel())
}

//
//  DealCard.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 13/01/1448 AH.
//

import SwiftUI

struct DealCard: View {
    let dealName: String
    let dealDescription: String
    let isToday: Bool
    var action: () -> Void = {}
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8){
                Text(dealName)
                    .foregroundStyle(AppColor.backgroundPrimary)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                
                HStack{
                    Image(systemName: "clock")
                        .foregroundStyle(AppColor.backgroundPrimary)
                    
                    Text(dealDescription)
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundStyle(AppColor.backgroundPrimary)
                }
            }
            Spacer()
            TrailingIconOutlinedButton(title: "View all", action: action)
        }
        .padding(16)
        .background(isToday ? .appBlue : .appPink)
        .cornerRadius(8)
        .padding(16)
    }
}

#Preview {
    DealCard(dealName: "Deal of the Day", dealDescription: "22h 55m 20s remaining ", isToday: true) {}
    DealCard(dealName: "Deal of the Day", dealDescription: "22h 55m 20s remaining ", isToday: false) {}
}

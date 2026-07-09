//
//  SignupHeader.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 27/06/2026.
//

import SwiftUI

struct SignupHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Create an\n account")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(AppColor.textPrimary)
                .lineSpacing(4)
        }
        .padding(.top, 40)
    }
}

#Preview {
    SignupHeader()
}

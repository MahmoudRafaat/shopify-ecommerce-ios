//
//  SignupFooter.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 27/06/2026.
//

import SwiftUI

struct SignupFooter: View {
    var body: some View {
        HStack {
            Text("I Already Have an Account")
                .foregroundColor(AppColor.textSecondary)
            NavigationLink(
                destination: LoginView(viewmodel: AuthFactory.makeLoginViewModel())
                    .navigationBarBackButtonHidden(true)
            ) {
                Text("Login")
                    .fontWeight(.bold)
                    .foregroundColor(Color(AppColor.dangerDefault))
                    .underline()
            }
        }
        .font(.system(size: 14))
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.bottom, 20)
    }
}

#Preview {
    SignupFooter()
}

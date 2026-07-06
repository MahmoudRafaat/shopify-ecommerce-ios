//
//  CartScreenView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 18/01/1448 AH.
//

import SwiftUI

struct PaymentScreenView: View {
    
    let viewModel: PaymentViewModel
    @State var selectedIndex: Int = 0
    
    var body: some View {
        ScrollView{
            VStack (alignment: .leading, spacing: 28){
                VStack(spacing: 18){
                    titleWithPrice(title: "Order Total", price: "\(viewModel.totalPrice)", color: .gray)
                    titleWithPrice(title: "Shipping", price: "00.00", color: .gray)
                    titleWithPrice(title: "Order Total", price: "\(viewModel.totalPrice)", color: .primary)
                }
                Divider()
                Text("Payment Method")
                    .font(Font.system(size: 18, weight: .bold))
                ForEach(0..<3, id: \.self) { paymentIndex in
                    paymentButton(title: viewModel.paymentMethods[paymentIndex].numbers,
                                  icon: viewModel.paymentMethods[paymentIndex].icon,
                                  index: paymentIndex)
                }
            }
            .padding(24)
        }
        .task {
            await viewModel.getTotalPrice()
        }
        Spacer()
        CustomButton(text: "Checkout") {
            Task {
                await viewModel.completeOrder(selectedIndex: selectedIndex)
            }
        }
        .padding(24)
    }
    
    func titleWithPrice(title: String, price: String, color: Color) -> some View {
        return HStack {
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(color)
            Spacer()
            Text("$\(price)")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(color)
        }
    }
    
    func paymentButton(title: String, icon: String, index: Int) -> some View {
        HStack {
            Image(icon)
            Spacer()
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.gray)
        }
        .frame(height: 50)
        .padding(20)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    selectedIndex == index ? Color.appPrimary : Color.clear,
                    lineWidth: 1
                )
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appGray)
        )
        .onTapGesture {
            selectedIndex = index
        }
    }
}

#Preview {
    let service : PaymentService = PaymentService()
    let repository : PaymentRepo = PaymentRepoImpl(service: service)
    let getPriceUseCase : GetTotalPriceUseCase = GetTotalPriceUseCaseImp(repository: repository)
    let completeOrderUseCase : CompleteOrderUseCase = CompleteOrderUseCaseImp(repository: repository)
    let viewModel : PaymentViewModel = PaymentViewModel(getTotalPriceUseCase: getPriceUseCase, completeOrderUseCase: completeOrderUseCase)
    PaymentScreenView(viewModel: viewModel)
}

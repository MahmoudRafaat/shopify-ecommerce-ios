//
//  SearchRootView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 21/01/1448 AH.
//

import SwiftUI

struct SearchRootView: View {
    @State private var coordinator = SearchCoordinator()
    
    var body: some View {
        @Bindable var bindableCoordinator = coordinator
        
        NavigationStack(path: $bindableCoordinator.navigationPath) {
            SearchView()
                .navigationDestination(for: SearchCoordinator.Destination.self) { destination in
                switch destination {
                case .productDetail(productId: let productId):
                    ProductDetailsScreen(id: productId)
                }
            }
        }
        .environment(coordinator)
        .alert("No Internet Connection", isPresented: Binding(
            get: { coordinator.showNetworkAlert },
            set: { coordinator.showNetworkAlert = $0 }
        )) {
            Button("Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please check your internet connection before continuing.")
        }
    }
}

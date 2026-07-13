//
//  SettingsView.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//

import SwiftUI

struct SettingsView: View {
    @Binding var selectedTab: Tab
    @State private var viewModel = SettingsViewModel()
    @State private var showLoginScreen = false
    @State private var navigateToCurrencyPicker = false
    @Environment(CurrencyService.self) private var currencyService
    @AppStorage("isDarkMode") private var isDarkMode = false
    let brandRed = AppColor.dangerDefault

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    guestBanner
                    profileHeader
                    settingsSections
                    Spacer(minLength: 40)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        selectedTab = .home
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .medium))
                            Text("Home")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundStyle(.appPrimary)
                    }
                }
            }
            .showLoading(if: viewModel.uiState.isLoading)
            .onChange(of: viewModel.uiState.errorMessage) { _, msg in
                if let msg = msg {
                    AlertManager.shared.showAlert(title: "Error", message: msg)
                    viewModel.uiState.errorMessage = nil
                }
            }
            .onChange(of: viewModel.uiState.showLogoutConfirmation) { _, show in
                if show {
                    AlertManager.shared.showAlert(
                        title: "Logout",
                        message: "Are you sure you want to logout?",
                        primaryButtonText: "Cancel",
                        primaryButtonRole: .cancel,
                        primaryAction: { viewModel.uiState.showLogoutConfirmation = false },
                        secondaryButtonText: "Logout",
                        secondaryButtonRole: .destructive,
                        secondaryAction: {
                            viewModel.uiState.showLogoutConfirmation = false
                            viewModel.confirmLogout()
                        }
                    )
                }
            }
            .onChange(of: viewModel.uiState.showHelpAlert) { _, show in
                if show {
                    AlertManager.shared.showAlert(
                        title: "Help Center",
                        message: viewModel.uiState.helpText,
                        primaryButtonText: "OK",
                        primaryButtonRole: .cancel,
                        primaryAction: { viewModel.uiState.showHelpAlert = false }
                    )
                }
            }
            .onAppear {
                viewModel.loadUserData()
            }
            .navigationDestination(isPresented: $viewModel.navigateToOrders) {
                OrdersListView()
            }
            .navigationDestination(isPresented: $navigateToCurrencyPicker) {
                CurrencyPickerView()
            }
            .navigationDestination(isPresented: $viewModel.navigateToProfileScreen) {
                ProfileDetailsView(viewModel: ProfileViewModel())
            }
        }
        .fullScreenCover(isPresented: $showLoginScreen) {
            LoginView(viewmodel: AuthFactory.makeLoginViewModel())
        }
        .onChange(of: showLoginScreen) { _, newValue in
            if !newValue {
                viewModel.loadUserData()
            }
        }
    }

    @ViewBuilder
    private var guestBanner: some View {
        if viewModel.uiState.isGuestMode {
            SettingsGuestModeBanner(
                brandColor: brandRed,
                onSignIn: { showLoginScreen = true }
            )
            .padding(.horizontal, 20)
        }
    }

    private var profileHeader: some View {
        Button {
            viewModel.navigateToProfile()
        } label: {
            SettingsProfileHeader(
                email: viewModel.uiState.userEmail,
                isLoggedIn: viewModel.uiState.isLoggedIn
            )
            .padding(.horizontal, 20)
            .padding(.top, viewModel.uiState.isGuestMode ? 0 : 10)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(viewModel.uiState.isGuestMode)
    }

    private var settingsSections: some View {
        VStack(spacing: 16) {
            accountGroup
            preferencesGroup
            supportGroup
            logoutGroup
        }
        .padding(.horizontal, 20)
    }

    private var accountGroup: some View {
        SettingsGroup {
            SettingsRowView(
                icon: "person.fill",
                title: "Profile",
                action: viewModel.navigateToProfile
            )

            Divider().padding(.leading, 60)

            SettingsRowView(
                icon: "map.fill",
                title: "Shipping Addresses",
                action: viewModel.navigateToProfile
            )

            Divider().padding(.leading, 60)

            SettingsRowView(
                icon: "creditcard.fill",
                title: "Payment Methods",
                action: viewModel.navigateToProfile
            )

            Divider().padding(.leading, 60)

            SettingsRowView(
                icon: "bag.fill",
                title: "My Orders",
                action: viewModel.navigateToMyOrders
            )
        }
        .opacity(viewModel.uiState.isGuestMode ? 0.5 : 1.0)
        .disabled(viewModel.uiState.isGuestMode)
    }

    private var preferencesGroup: some View {
        SettingsGroup {
            SettingsRowView(
                icon: "dollarsign.circle.fill",
                title: "Currency (\(currencyService.selectedCurrency))",
                style: .navigation,
                action: { navigateToCurrencyPicker = true }
            )
            
            Divider().padding(.leading, 60)
            
            SettingsRowView(
                icon: "bell.fill",
                title: "Notifications",
                style: .toggle($viewModel.uiState.pushNotificationsEnabled)
            )

            Divider().padding(.leading, 60)

            SettingsRowView(
                icon: "moon.fill",
                title: "Dark Theme",
                style: .toggle($isDarkMode)
            )
        }
    }

    private var supportGroup: some View {
        SettingsGroup {
            SettingsRowView(
                icon: "lock.fill",
                title: "Change Password",
                action: viewModel.navigateToProfile
            )
            .opacity(viewModel.uiState.isGuestMode ? 0.5 : 1.0)
            .disabled(viewModel.uiState.isGuestMode)

            Divider().padding(.leading, 60)

            SettingsRowView(
                icon: "questionmark.circle.fill",
                title: "Help Center",
                action: viewModel.showHelp
            )
        }
    }

    @ViewBuilder
    private var logoutGroup: some View {
        if viewModel.uiState.isLoggedIn {
            SettingsGroup {
                Button {
                    viewModel.handleLogout()
                } label: {
                    SettingsRowView(
                        icon: "rectangle.portrait.and.arrow.right",
                        title: "Log Out",
                        style: .destructive
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

}

struct SettingsGroup<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background(AppColor.backgroundPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.02), radius: 8, x: 0, y: 4)
    }
}

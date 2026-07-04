//
//  SettingsView.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//

import SwiftUI

struct SettingsView: View {
    @State private var viewModel = SettingsViewModel()
    @State private var showLoginScreen = false

    let brandRed = Color(red: 0.95, green: 0.25, blue: 0.40)

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
            .background(Color(white: 0.98).ignoresSafeArea())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .showLoading(if: viewModel.uiState.isLoading)
            .showCustomAlert(title: "Error", errorMessage: $viewModel.uiState.errorMessage)
            .alert("Logout", isPresented: $viewModel.uiState.showLogoutConfirmation) {
                logoutAlertButtons
            } message: {
                Text("Are you sure you want to logout?")
            }
            .alert("Help Center", isPresented: $viewModel.uiState.showHelpAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.uiState.helpText)
            }
            .onAppear {
                viewModel.loadUserData()
            }
        }
        .fullScreenCover(isPresented: $showLoginScreen) {
            LoginView(viewmodel: LoginViewModel())
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
                name: viewModel.uiState.userName,
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
                icon: "bell.fill",
                title: "Notifications",
                style: .toggle($viewModel.uiState.pushNotificationsEnabled)
            )

            Divider().padding(.leading, 60)

            SettingsRowView(
                icon: "moon.fill",
                title: "Dark Theme",
                style: .toggle($viewModel.uiState.darkThemeEnabled)
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


    @ViewBuilder
    private var logoutAlertButtons: some View {
        Button("Cancel", role: .cancel) { }
        Button("Logout", role: .destructive) {
            viewModel.confirmLogout()
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
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.02), radius: 8, x: 0, y: 4)
    }
}

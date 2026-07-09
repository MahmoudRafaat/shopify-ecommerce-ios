//
//  AlertManager.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 24/01/1448 AH.
//

import SwiftUI
import Observation

struct AppAlert: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let primaryButtonText: String
    let primaryButtonRole: ButtonRole?
    let primaryAction: (() -> Void)?
    
    let secondaryButtonText: String?
    let secondaryButtonRole: ButtonRole?
    let secondaryAction: (() -> Void)?
    
    init(
        title: String,
        message: String,
        primaryButtonText: String = "OK",
        primaryButtonRole: ButtonRole? = nil,
        primaryAction: (() -> Void)? = nil,
        secondaryButtonText: String? = nil,
        secondaryButtonRole: ButtonRole? = nil,
        secondaryAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.primaryButtonText = primaryButtonText
        self.primaryButtonRole = primaryButtonRole
        self.primaryAction = primaryAction
        self.secondaryButtonText = secondaryButtonText
        self.secondaryButtonRole = secondaryButtonRole
        self.secondaryAction = secondaryAction
    }
}

@Observable
final class AlertManager {
    static let shared = AlertManager()
    
    var alert: AppAlert?
    
    func showAlert(
        title: String,
        message: String,
        primaryButtonText: String = "OK",
        primaryButtonRole: ButtonRole? = nil,
        primaryAction: (() -> Void)? = nil,
        secondaryButtonText: String? = nil,
        secondaryButtonRole: ButtonRole? = nil,
        secondaryAction: (() -> Void)? = nil
    ) {
        self.alert = AppAlert(
            title: title,
            message: message,
            primaryButtonText: primaryButtonText,
            primaryButtonRole: primaryButtonRole,
            primaryAction: primaryAction,
            secondaryButtonText: secondaryButtonText,
            secondaryButtonRole: secondaryButtonRole,
            secondaryAction: secondaryAction
        )
    }
    
    func showError(_ error: AppError) {
        showAlert(title: error.title, message: error.message)
    }
}

struct GlobalAlertModifier: ViewModifier {
    @Bindable var alertManager = AlertManager.shared
    
    func body(content: Content) -> some View {
        content
            .alert(
                alertManager.alert?.title ?? "",
                isPresented: Binding(
                    get: { alertManager.alert != nil },
                    set: { if !$0 { alertManager.alert = nil } }
                ),
                presenting: alertManager.alert
            ) { appAlert in
                if let secondaryText = appAlert.secondaryButtonText {
                    Button(secondaryText, role: appAlert.secondaryButtonRole) {
                        appAlert.secondaryAction?()
                    }
                }
                Button(appAlert.primaryButtonText, role: appAlert.primaryButtonRole) {
                    appAlert.primaryAction?()
                }
            } message: { appAlert in
                Text(appAlert.message)
            }
    }
}

extension View {
    func withGlobalAlerts() -> some View {
        modifier(GlobalAlertModifier())
    }
}

//
//  SettingsRepositoryProtocol.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//


protocol SettingsRepositoryProtocol {
    func getCurrentUser() -> User?
    func logout() throws
    func isLoggedIn() -> Bool
}
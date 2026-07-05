//
//  GetUserProfileUseCaseProtocol.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//

import Foundation
import FirebaseAuth

protocol GetUserProfileUseCaseProtocol {
    func execute() -> User?
}

protocol LogoutUseCaseProtocol {
    func execute() throws
}

protocol CheckLoginStatusUseCaseProtocol {
    func execute() -> Bool
}

class SettingsUseCase: GetUserProfileUseCaseProtocol, LogoutUseCaseProtocol, CheckLoginStatusUseCaseProtocol {
    
    private let repository: SettingsRepositoryProtocol
    
    init(repository: SettingsRepositoryProtocol = SettingsRepository()) {
        self.repository = repository
    }
    
    func execute() -> User? {
        return repository.getCurrentUser()
    }
    
    func execute() throws {
        try repository.logout()
    }
    
    func execute() -> Bool {
        return repository.isLoggedIn()
    }
}

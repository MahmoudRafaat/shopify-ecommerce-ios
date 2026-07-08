//
//  AuthFactory.swift
//  shopify-ecommerce-ios
//
//  Created by Albaraa Alsayed on 08/07/2026.
//

import Foundation

final class AuthFactory {
    
    // MARK: - Core Services
    static func makeAuthService() -> AuthServiceProtocol {
        return FirebaseAuthService()
    }
    
    static func makeShopifyAuthService() -> ShopifyAuthServiceProtocol {
        return ShopifyAuthService()
    }
    
    // MARK: - Repositories
    static func makeAuthRepository() -> AuthRepoProtocol {
        return AuthRepoImp(
            authService: makeAuthService(),
            shopifyService: makeShopifyAuthService()
        )
    }
    
    // MARK: - Use Cases
    static func makeLoginUseCase() -> LoginUseCase {
        return LoginUseCase(repository: makeAuthRepository())
    }
    
    static func makeSignupUseCase() -> SignupUseCase {
        return SignupUseCase(repository: makeAuthRepository())
    }
    
    static func makeGoogleAuthUseCase() -> GoogleAuthUseCase {
        return GoogleAuthUseCase(repository: makeAuthRepository())
    }
    
    // MARK: - ViewModels
    @MainActor
    static func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(
            loginUseCase: makeLoginUseCase(),
            googleAuthUseCase: makeGoogleAuthUseCase()
        )
    }
    
    @MainActor
    static func makeSignupViewModel() -> SignupViewModel {
        return SignupViewModel(
            signupUseCase: makeSignupUseCase(),
            googleAuthUseCase: makeGoogleAuthUseCase()
        )
    }
}

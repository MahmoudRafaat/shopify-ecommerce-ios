protocol SettingsRepositoryProtocol {
    func getCurrentUser() -> User?
    func logout() throws
    func isLoggedIn() -> Bool
}
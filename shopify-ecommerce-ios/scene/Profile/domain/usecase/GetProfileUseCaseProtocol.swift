protocol GetProfileUseCaseProtocol {
    func execute(customerId: Int) async throws -> ProfileDisplayModel
}

protocol UpdateProfileUseCaseProtocol {
    func updateName(customerId: Int, firstName: String, lastName: String) async throws
    func updateEmail(customerId: Int, email: String) async throws
    func updateAddress(customerId: Int, address: ShopifyAddress) async throws -> ShopifyAddress
    func updatePaymentDetails(customerId: Int, paymentDetails: PaymentDetails) async throws
}
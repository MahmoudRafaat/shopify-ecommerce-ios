
struct ProfileDisplayModel {
    let email: String
    var firstName: String
    var lastName: String
    var address: ProfileAddress?
    var paymentDetails: PaymentDetails?
    
    var hasDefaultAddress: Bool { address != nil }
    var hasPaymentDetails: Bool { paymentDetails != nil }
}

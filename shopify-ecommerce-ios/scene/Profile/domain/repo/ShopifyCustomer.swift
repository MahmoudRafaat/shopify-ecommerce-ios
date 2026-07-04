struct ShopifyCustomer {
    let id: Int
    let email: String?
    let firstName: String?
    let lastName: String?
    let addresses: [ShopifyAddress]?
    let defaultAddress: ShopifyAddress?
}
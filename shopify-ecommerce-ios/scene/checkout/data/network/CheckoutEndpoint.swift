import Foundation
import Alamofire

enum CheckoutEndpoint: ApiEndpoint {

    case createDraftOrder(request: DraftOrderRequestWrapper)
    case updateDraftOrder(id: Int, request: DraftOrderRequestWrapper)
    case completeDraftOrder(id: Int)
    case deleteDraftOrder(id: Int)
    case getDraftOrder(id: Int)
    case removeDiscount(id: Int)
    case getPriceRules
    case getDiscountCodes(priceRuleId: Int)
    
    case getCustomerMetafields(customerId: Int)
    case createCustomerMetafield(customerId: Int, request: MetafieldRequestWrapper)
    case updateCustomerMetafield(customerId: Int, metafieldId: Int, request: MetafieldRequestWrapper)
    
    var path: String {
        switch self {
        case .createDraftOrder:
            return "draft_orders.json"
        case .updateDraftOrder(let id, _):
            return "draft_orders/\(id).json"
        case .completeDraftOrder(let id):
            return "draft_orders/\(id)/complete.json"
        case .deleteDraftOrder(let id), .getDraftOrder(let id):
            return "draft_orders/\(id).json"
        case .removeDiscount(let id):
            return "draft_orders/\(id).json"
        case .getPriceRules:
            return "price_rules.json"
        case .getDiscountCodes(let priceRuleId):
            return "price_rules/\(priceRuleId)/discount_codes.json"
        case .getCustomerMetafields(let customerId):
            return "customers/\(customerId)/metafields.json"
        case .createCustomerMetafield(let customerId, _):
            return "customers/\(customerId)/metafields.json"
        case .updateCustomerMetafield(let customerId, let metafieldId, _):
            return "customers/\(customerId)/metafields/\(metafieldId).json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createDraftOrder, .createCustomerMetafield:
            return .post
        case .updateDraftOrder, .completeDraftOrder, .removeDiscount, .updateCustomerMetafield:
            return .put
        case .deleteDraftOrder:
            return .delete
        case .getPriceRules, .getDiscountCodes, .getDraftOrder, .getCustomerMetafields:
            return .get
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        switch self {
        case .createDraftOrder(let request):
            return try? encoder.encode(request)
        case .updateDraftOrder(_, let request):
            return try? encoder.encode(request)
        case .removeDiscount:
            let parameters: [String: Any] = [
                "draft_order": [
                    "applied_discount": NSNull()
                ]
            ]
            return try? JSONSerialization.data(withJSONObject: parameters)
        case .createCustomerMetafield(_, let request), .updateCustomerMetafield(_, _, let request):
            return try? encoder.encode(request)
        case .completeDraftOrder, .deleteDraftOrder, .getPriceRules, .getDiscountCodes, .getDraftOrder, .getCustomerMetafields:
            return nil
        }
    }
}

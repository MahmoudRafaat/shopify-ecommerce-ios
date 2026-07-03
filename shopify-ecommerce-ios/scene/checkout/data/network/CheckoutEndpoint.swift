import Foundation
import Alamofire

enum CheckoutEndpoint: ApiEndpoint {
    case createDraftOrder
    case updateDraftOrder(id: Int)
    case completeDraftOrder(id: Int)
    
    var path: String {
        switch self {
        case .createDraftOrder:
            return "draft_orders.json"
        case .updateDraftOrder(let id):
            return "draft_orders/\(id).json"
        case .completeDraftOrder(let id):
            return "draft_orders/\(id)/complete.json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createDraftOrder:
            return .post
        case .updateDraftOrder, .completeDraftOrder:
            return .put
        }
    }
}

import Foundation
import Alamofire

enum CheckoutEndpoint: ApiEndpoint {

    case createDraftOrder(request: DraftOrderRequestWrapper)
    case updateDraftOrder(id: Int, request: DraftOrderRequestWrapper)
    case completeDraftOrder(id: Int)
    
    var path: String {
        switch self {
        case .createDraftOrder:
            return "draft_orders.json"
        case .updateDraftOrder(let id, _):
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
    
    var body: Data? {
        let encoder = JSONEncoder()
        switch self {
        case .createDraftOrder(let request):
            return try? encoder.encode(request)
        case .updateDraftOrder(_, let request):
            return try? encoder.encode(request)
        case .completeDraftOrder:
            return nil
        }
    }
}

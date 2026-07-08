# Architecture Layers

The project follows **Clean Architecture** with three layers per feature: **Data**, **Domain**, and **Presentation**. Dependencies always point inward — Presentation depends on Domain, Data depends on Domain, and Domain depends on nothing.

---

## Layer Overview

```
┌─────────────────────────────────────────┐
│            Presentation Layer           │
│   Views  ←  ViewModel  ←  UseCase      │
├─────────────────────────────────────────┤
│               Domain Layer              │
│   Entities · Repository Protocol ·      │
│   UseCase Protocol + Implementation     │
├─────────────────────────────────────────┤
│               Data Layer                │
│   Repository Impl · Remote DataSource · │
│   DTOs · Mappers · Endpoints            │
└─────────────────────────────────────────┘
              ↓ (network)
         Shopify Admin API
```

---

## 1. Domain Layer

The innermost layer. Contains pure Swift — no imports of UIKit, Alamofire, or Firebase.

### Entities
Plain Swift structs that represent the core business objects the app works with.

| Entity | Feature | Key Properties |
|---|---|---|
| `Product` | Home | `id`, `name`, `price`, `vendor`, `isAvailable`, `productType` |
| `Category` | Home | `id`, `title`, `imageName` |
| `ProductDetails` | ProductDetails | `id`, `title`, `images`, `variants`, `sizes`, `tags` |
| `SearchProduct` | Search | `id`, `title`, `vendor`, `price`, `imageUrl` |
| `ProfileDisplayModel` | Profile | `firstName`, `lastName`, `email`, `addresses` |
| `ProfileAddress` | Profile | `address1`, `city`, `country`, `zip` |

### Repository Protocols
Define what data operations are possible. The Domain layer owns these protocols; the Data layer provides the concrete implementations.

```
HomeRepo               → getProducts(), getCategories()
CollectionRepo         → getCollectionProducts(id:)
ProductDetailsRepository → getProductDetails(id:)
SearchProductRepo      → searchProducts(query:)
AuthRepoProtocol       → login(), signup()
ProfileRepositoryProtocol → getProfile(), updateProfile()
CheckoutRepository     → createDraftOrder(), getDraftOrder(), ...
SettingsRepositoryProtocol → getUserProfile(), logout()
```

### Use Cases
Each use case has a protocol and a concrete implementation. They take repository protocols as dependencies.

**Pattern:**
```swift
protocol GetProductsUseCaseProtocol {
    func execute() async throws -> [Product]
}

class GetProductsUseCase: GetProductsUseCaseProtocol {
    private let repository: HomeRepo
    func execute() async throws -> [Product] {
        return try await repository.getProducts()
    }
}
```

Use cases enforce the single-responsibility principle: one business action per class.

---

## 2. Data Layer

Implements the repository protocols defined in the Domain layer. Handles all network communication, DTO decoding, and data mapping.

### Remote Data Sources / Services
Concrete classes that call `NetworkService` with feature-specific endpoints.

| Service | Feature | Endpoint file |
|---|---|---|
| `HomeRemoteDataSource` | Home | `HomeEndPoint` |
| `CollectionService` | Collection | `CollectionEndPoints` |
| `ProductDetailsRemoteDataSource` | ProductDetails | `ProductDetailsEndPoint` |
| `SearchRemoteDataSource` | Search | `SearchEndpoint` |
| `CheckoutNetworkService` | Checkout | `CheckoutEndpoint` |
| `ProfileDataSource` | Profile | `ProfileEndpoint` |
| `ShopifyAuthService` | Auth | `AuthEndpoints` |

All services route through the shared `NetworkService.request<T>(endpoint:)` generic, which uses Alamofire under the hood.

### Endpoints
Each feature defines an enum conforming to `ApiEndpoint`:

```swift
protocol ApiEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryParameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
    var body: Data? { get }
}
```

The base URL is constructed at runtime from `SecretConstants` (loaded from `Secrets.xcconfig`):
```
https://{apiKey}:{password}@{hostname}/admin/api/2026-01/
```

### DTOs (Data Transfer Objects)
Codable structs that mirror the Shopify API JSON response. They exist only in the Data layer and are never passed to the Presentation layer.

Examples: `ProductDTO`, `CategoryDTO`, `ProductResponse`, `DraftOrderResponse`, `MetafieldResponse`

### Repository Implementations
Map DTOs to Domain entities and delegate network calls to the service.

**Example — HomeRepoImpl:**
```swift
func getProducts() async throws -> [Product] {
    let dtos = try await service.loadProducts()
    return dtos.map { dto in
        Product(
            id: dto.id,
            name: dto.title,
            price: Float(dto.variants.first?.price ?? "0") ?? 0,
            ...
        )
    }
}
```

### Mappers
Some features (e.g., ProductDetails) extract mapping logic into a dedicated `*Mapper` class to keep repository implementations clean.

---

## 3. Presentation Layer

Contains SwiftUI Views and `@Observable` ViewModels. Views are passive — they only read state from the ViewModel and call its intention methods.

### ViewModels
- Annotated with `@Observable` (Swift 5.9+ Observation framework).
- Hold published state that drives the UI.
- Call use cases on `Task {}` or `async let`, always update UI state on `@MainActor`.
- Never import Alamofire, Firebase, or any networking library directly.

### Views
- Declare their ViewModel as a `let` or `@State` parameter.
- Read state directly (no `@Published` needed with `@Observable`).
- Call ViewModel intentions (e.g., `.task { await viewModel.fetchData() }`).
- Broken into small sub-views in a `components/` subfolder.

### UI State Enums
Some features (Collection, ProductDetails, Search) use an explicit state enum:

```swift
enum ProductUIState {
    case loading
    case success([Product])
    case error(String)
}
```

This makes impossible states unrepresentable in the view switch.

### Factories
Each feature has a `*Factory` that wires the dependency graph:

```
Factory → ViewModel ← UseCase ← Repository ← Service
```

The view calls the factory once (usually as a default parameter or in `TabBarView`), so no view ever constructs its own dependencies.

---

## 4. Core / Shared Layer

Utilities and shared components used across all features.

| File | Purpose |
|---|---|
| `NetworkService` | Generic Alamofire wrapper used by all data sources |
| `NetworkMonitor` | NWPathMonitor wrapper; injected into SwiftUI environment |
| `NetworkError` | Typed error enum for all network failures |
| `SecretConstants` | Reads credentials from `Secrets.xcconfig` at runtime |
| `AppConstants` | UserDefaults and AppStorage key strings |
| `CachedImageLoader` | Async image loading with in-memory cache |
| `ProductCardView` | Reusable product card used in Home, Collection, Search |
| `CustomTextField` | Styled text field with validation support |
| `HeaderView` | Shared navigation header component |
| `CustomAlertModifier` | SwiftUI view modifier for consistent alert presentation |
| `LoadingModifier` | SwiftUI view modifier for full-screen loading overlay |

---

## Feature Folder Structure

Each feature follows this consistent folder layout:

```
scene/<Feature>/
├── Data/
│   ├── DTOs/
│   ├── DataSources/      (or DataSourse/)
│   ├── Mappers/
│   └── Repositories/     (or Repository/)
├── Domain/
│   ├── Entities/
│   ├── Repositories/     (protocol)
│   └── UseCases/
├── Presentation/
│   ├── ViewModels/
│   ├── Views/
│   │   └── components/
│   └── UIStates/
└── Factory/
```

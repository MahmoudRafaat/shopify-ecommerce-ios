# Agents — ViewModels & Use Cases

This document describes the "agents" in the app: the ViewModels that drive each screen and the Use Cases that encapsulate business logic. Each ViewModel owns a set of Use Cases; it never talks to a repository directly.

---

## HomeViewModel

**File:** `scene/Home/Presentation/ViewModels/HomeViewModel.swift`  
**Created by:** `HomeFactory`

| Responsibility | Detail |
|---|---|
| Fetch products | Groups all products by `productType`, picks 2 random groups to display |
| Fetch categories | Loads smart collections for the category chips |
| Concurrent loading | Uses `async let` to fetch both in parallel |
| Guard against re-fetch | `hasFetchedData` flag prevents duplicate API calls on view re-appearance |

**Use Cases injected:**
- `GetProductsUseCaseProtocol`
- `GetCategoriesUseCaseProtocol`

**Published state:** `categories`, `categorySections`, `isCategoriesLoading`, `isProductsLoading`, `errorMessage`

---

## CollectionViewModel

**File:** `scene/Collection/Presentation/ViewModel/CollectionViewModel.swift`  
**Created by:** `CollectionFactory`

Fetches all products for a given smart collection ID. Exposes a `ProductUIState` enum (`loading`, `success`, `error`) consumed by `CollectionScreenView`.

**Use Cases injected:**
- `GetCollectionProductsUseCase`

---

## ProductDetailsViewModel

**File:** `scene/ProductDetails/Presentation/ViewModels/ProductDetailsViewModel.swift`  
**Created by:** `ProductDetailsCoordinator`

Fetches full product details (images, variants, sizes, tags) for a product ID. Maps the raw DTO to a `ProductDetailsUIState` via `ProductDetailsUIStateMapper`.

**Use Cases injected:**
- `GetProductDetailsUseCase`

---

## SearchViewModel

**File:** `scene/Search/Presentation/ViewModels/SearchViewModel.swift`  
**Created by:** `SearchFactory`

Drives real-time search. Debounces text input, applies vendor/category/sort filters, and exposes a `SearchViewState` enum.

**Use Cases injected:**
- `SearchProductsUseCase`

---

## CheckoutViewModel

**File:** `scene/checkout/presentation/viewmodel/CheckoutViewModel.swift`

The most complex ViewModel. Manages the entire cart lifecycle via Shopify Draft Orders.

| Intention | What it does |
|---|---|
| `loadOrCreateCart` | Reads cart metafield; resumes existing draft order or creates a new one |
| `updateQuantity` | Replaces line items with updated quantity and refreshes totals |
| `applyDiscount` | Applies a selected price rule/coupon code to the draft order |
| `removeDiscount` | Strips the applied discount from the draft order |
| `updateAddress` | Sets the shipping address on the draft order |
| `removeLineItem` | Removes one item; deletes the entire draft order if cart becomes empty |
| `proceedToPayment` | Completes the draft order, converting it to a real Shopify order |

**Use Cases injected (via `CheckoutUseCases` struct):**
- `CreateDraftOrderUseCase`
- `GetDraftOrderUseCase`
- `GetCustomerCartMetafieldUseCase`
- `SetCustomerCartMetafieldUseCase`
- `UpdateDraftOrderLineItemsUseCase`
- `ApplyDiscountUseCase`
- `CompleteDraftOrderUseCase`
- `UpdateDraftOrderAddressUseCase`
- `RemoveLineItemUseCase`
- `DeleteDraftOrderUseCase`
- `FetchActiveDiscountCodesUseCase`
- `RemoveDiscountUseCase`

---

## ProfileViewModel

**File:** `scene/Profile/presentation/viewModel/ProfileViewModel.swift`

Fetches the Shopify customer record and metafields (addresses, payment details). Maps them to `ProfileDisplayModel` for the UI.

---

## SettingsViewModel

**File:** `scene/Settings/presentation/viewModel/SettingsViewModel.swift`

Handles logout and loads the current user's display name/avatar for the settings header.

---

## LoginViewModel

**File:** `scene/Authentication/presentation/login/viewModel/LoginViewModel.swift`

Validates input and delegates to `LoginUseCase`. On success, sets `isLoggedIn = true` in `AppStorage`.

**Use Cases injected:**
- `LoginUsecase`

---

## SignupViewModel

**File:** `scene/Authentication/presentation/Signup/viewModel/SignupViewModel.swift`

Validates form fields and delegates to `SignupUseCase`. Creates both a Firebase user and a Shopify customer in sequence.

**Use Cases injected:**
- `SignupUsecase`

---

## Shared Infrastructure

| Agent | File | Role |
|---|---|---|
| `NetworkMonitor` | `Core/Networking/NetworkMonitor.swift` | Observes NWPathMonitor; injected into SwiftUI environment at root |
| `NetworkService` | `Core/Networking/NetworkService.swift` | Static generic Alamofire wrapper; all feature services call this |
| `FirebaseAuthService` | `scene/Authentication/data/FirebaseService/FirebaseAuthService.swift` | Wraps Firebase Auth register/login |

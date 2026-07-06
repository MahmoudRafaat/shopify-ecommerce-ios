# Shopify E-Commerce iOS — Design Document

## Overview

A native iOS e-commerce application built with SwiftUI that integrates with the Shopify Admin REST API. The app supports browsing products, searching, managing a cart via Shopify Draft Orders, and completing purchases. Authentication is dual-layered: Firebase handles identity, while a matching Shopify customer account is created for each user.

---

## Tech Stack

| Concern | Technology |
|---|---|
| UI Framework | SwiftUI |
| State Management | `@Observable` (Swift Observation framework) |
| Networking | Alamofire |
| Authentication | Firebase Auth + Shopify Customer API |
| Local Persistence | SwiftData, UserDefaults, AppStorage |
| Connectivity | NWPathMonitor (Network framework) |
| Image Loading | Custom `CachedImageLoader` |
| Backend | Shopify Admin REST API 2026-01 |

---

## App Navigation Flow

```
Launch
  │
  ├── First launch → OnboardingScreen
  │
  ├── Not logged in → SignupView / LoginView
  │
  └── Logged in → TabBarView
        ├── Home (products & categories)
        ├── Wishlist
        ├── Cart → CheckoutView
        ├── Search
        └── Profile / Settings
```

Navigation is driven by two `@AppStorage` flags: `hasSeenOnboarding` and `isLoggedIn`, evaluated in the root `shopify_ecommerce_iosApp`.

---

## Screens

### Onboarding
- Three-page swipeable introduction shown only once.
- Sets `hasSeenOnboarding = true` on completion.

### Authentication
- **Signup**: email/password registration via Firebase, then creates a matching Shopify customer.
- **Login**: Firebase sign-in, looks up the Shopify customer by email.
- Social login buttons (Google, Apple) are present in the UI (wired via `SocialLoginView`).

### Home
- Loads smart collection categories and products in parallel using `async let`.
- Displays an ads/deals carousel at the top, category chips, and product grids grouped by type.
- Tapping a category navigates to `CollectionScreenView`.
- Tapping a product navigates to `ProductDetailsScreen`.

### Collection
- Shows all products for a selected smart collection.
- Supports filtering and sorting via `FilterSheetView`.

### Product Details
- Full product info: image carousel, title, vendor, price, size chips, tags, rating, delivery banner.
- Add to Cart triggers draft order creation or update.

### Search
- Real-time product search with vendor/category filters.
- Results displayed in a two-column grid.

### Checkout / Cart
- Backed by Shopify Draft Orders.
- Supports: quantity adjustment, line item removal, coupon/discount code application, address entry, and order completion.
- Cart state is persisted via a Shopify customer metafield (stores the draft order ID).

### Profile
- Displays personal details, saved addresses, and payment info fetched from Shopify.
- Supports photo edit and guest mode banner.

### Settings
- User profile header with app-level settings rows.
- Handles logout, clearing `isLoggedIn` flag.

---

## Key Design Decisions

- **Draft Orders as Cart**: The cart is a Shopify Draft Order. Its ID is stored in a customer metafield so it persists across sessions and devices.
- **Dual Auth**: Firebase manages passwords and sessions; Shopify stores the customer record for order association.
- **Factory Pattern**: Each feature creates its dependency graph through a `*Factory` class (e.g., `HomeFactory`), keeping views free of construction logic.
- **Protocol-driven dependencies**: Use cases and repositories are always injected via protocols, enabling testability.
- **Network connectivity**: `NetworkMonitor` is injected into the environment at the root level so any view can react to connectivity changes.
- **Secrets management**: API keys and credentials are loaded at runtime from `Secrets.xcconfig` via `SecretConstants`, never hardcoded.

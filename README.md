# Shopify E-Commerce iOS

A native shopping application built with SwiftUI and backed by the Shopify Admin REST API. The app covers the complete customer journey—from onboarding and authentication to product discovery, a persistent cart, payment, and order history.

## Features

- Three-page onboarding flow with authenticated and guest experiences
- Email/password and Google authentication with Firebase
- Matching Shopify customer creation and lookup
- Product browsing by category and collection
- Real-time search with vendor, category, and sorting filters
- Product details with images, variants, sizes, tags, and availability
- Local wishlist persistence with SwiftData
- Persistent cart implemented with Shopify Draft Orders and customer metafields
- Quantity updates, item removal, delivery addresses, and discount codes
- Paymob checkout and Shopify order completion
- Customer profile, saved addresses, settings, and order history
- Multi-currency prices with remotely refreshed exchange rates
- Gemini-powered shopping assistant with text and photo input
- Network connectivity monitoring and light/dark appearance support

## Tech Stack

| Area | Technology |
|---|---|
| UI | SwiftUI |
| State | Observation (`@Observable`), AppStorage, UserDefaults |
| Architecture | Clean Architecture, MVVM, Use Cases, Repository and Factory patterns |
| Networking | Alamofire, async/await |
| Backend | Shopify Admin REST API `2026-01` |
| Authentication | Firebase Authentication, Google Sign-In |
| Persistence | SwiftData |
| Images | Kingfisher and a shared cached image loader |
| Payments | Paymob iOS SDK |
| AI assistant | Google Generative AI (Gemini) |
| Connectivity | Network framework (`NWPathMonitor`) |
| Testing | Swift Testing and XCTest |

## Requirements

- macOS with Xcode 16 or later
- iOS 18.1 or later
- A Shopify store with Admin API credentials
- A Firebase iOS application with Authentication configured
- A Paymob account and card integration
- A Gemini API key

## Getting Started

1. Clone the repository and open the Xcode project:

   ```bash
   git clone <repository-url>
   cd "Shopify App"
   open shopify-ecommerce-ios.xcodeproj
   ```

2. Allow Xcode to resolve the Swift Package Manager dependencies.

3. Add your Firebase configuration:

   - Download `GoogleService-Info.plist` from the Firebase console.
   - Replace the file at `shopify-ecommerce-ios/GoogleService-Info.plist`.
   - Ensure it belongs to the `shopify-ecommerce-ios` target.
   - Add the reversed client ID as a URL scheme in the target's **Info** settings for Google Sign-In.

4. Create `shopify-ecommerce-ios/Core/Networking/SecretConstants.swift`. This file is ignored by Git and should contain:

   ```swift
   import Foundation

   struct SecretConstants {
       static let apiKey = "YOUR_SHOPIFY_API_KEY"
       static let hostname = "YOUR_STORE.myshopify.com"
       static let password = "YOUR_SHOPIFY_ADMIN_ACCESS_TOKEN"

       static let paymobPublicKey = "YOUR_PAYMOB_PUBLIC_KEY"
       static let paymobSecretKey = "YOUR_PAYMOB_SECRET_KEY"
       static let paymobCardIntegrationID = 0

       static let geminiApiKey = "YOUR_GEMINI_API_KEY"
   }
   ```

5. Select the `shopify-ecommerce-ios` scheme, choose an iOS 18.1+ simulator or device, and run the app.

> [!CAUTION]
> Never commit API keys, tokens, `SecretConstants.swift`, or private Firebase configuration. Shopify Admin credentials are highly privileged and should be moved behind a server-side API before distributing a production build.

## Firebase Setup

Enable the authentication providers used by the application in the Firebase console:

- Email/Password
- Google

The app uses Firebase for identity and creates or retrieves a corresponding Shopify customer. A successful sign-in stores the Shopify customer ID locally so cart, profile, and order requests can be associated with that customer.

## Shopify Setup

The configured Shopify Admin API application needs access to the resources used by the app, including:

- Products and smart collections
- Customers and customer metafields
- Draft orders
- Orders
- Price rules and discount codes

The cart is represented by a Shopify Draft Order. Its ID is saved in a customer metafield, allowing the cart to be restored across app sessions.

## Architecture

Each feature follows Clean Architecture and keeps dependencies pointed toward the domain layer:

```text
SwiftUI View
    ↓
ViewModel
    ↓
Use Case
    ↓
Repository Protocol (Domain)
    ↑
Repository Implementation (Data)
    ↓
Remote/Local Data Source
```

ViewModels call use cases rather than repositories directly. Feature factories assemble the dependency graph, while DTOs and API-specific code remain in the data layer.

### Project Structure

```text
shopify-ecommerce-ios/
├── Core/
│   ├── Currency/          # Exchange rates and currency selection
│   ├── Local/             # Shared SwiftData container
│   ├── Networking/        # Endpoints, networking, errors, and connectivity
│   └── helper/            # Constants, themes, extensions, and shared views
├── scene/
│   ├── Authentication/
│   ├── ChatBot/
│   ├── Collection/
│   ├── Favorites/
│   ├── Home/
│   ├── Orders/
│   ├── Payment/
│   ├── ProductDetails/
│   ├── Profile/
│   ├── Search/
│   ├── Settings/
│   └── cart/
├── Assets.xcassets/
├── AppDelegate.swift
└── shopify_ecommerce_iosApp.swift
```

Most feature folders are divided into `Data`, `Domain`, and `Presentation`, with a factory or coordinator responsible for dependency injection and navigation.

## App Flow

```text
Launch
├── First run → Onboarding
├── Signed out → Sign up / Log in / Guest mode
└── Signed in or Guest → Main tab bar
    ├── Home
    ├── Wishlist
    ├── Cart
    ├── Search
    └── Settings / Profile
```

## Dependencies

Direct dependencies are managed by Swift Package Manager unless otherwise noted:

- Alamofire `5.12.0`
- Firebase iOS SDK `11.2.0`
- Google Sign-In `9.2.0`
- Google Generative AI `0.5.6`
- Kingfisher `8.10.0`
- Paymob SDK, included as `PaymobSDK.xcframework`

Pinned transitive versions are recorded in `Package.resolved`.

## Testing

The project contains unit and UI test targets:

- `shopify-ecommerce-iosTests` uses Swift Testing.
- `shopify-ecommerce-iosUITests` uses XCTest.

Run them from Xcode with **Product → Test** (`⌘U`) or from the command line with an installed simulator:

```bash
xcodebuild test \
  -project shopify-ecommerce-ios.xcodeproj \
  -scheme shopify-ecommerce-ios \
  -destination 'platform=iOS Simulator,name=<simulator-name>'
```

## Additional Documentation

- [`Design.md`](Design.md) describes the screens, navigation, and major design decisions.
- [`Layers/Agent.md`](Layers/Agent.md) explains the Clean Architecture layers and feature organization.
- [`Agents.md`](Agents.md) documents the ViewModels and their use cases.

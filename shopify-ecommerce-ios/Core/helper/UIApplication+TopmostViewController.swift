//
//  UIApplication+TopmostViewController.swift
//  shopify-ecommerce-ios
//

import UIKit

extension UIApplication {

    /// Returns the currently visible (topmost presented) `UIViewController`.
    ///
    /// Walks the presentation chain from the root view controller of the
    /// first connected key window. Returns `nil` if no scene or window is active.
    ///
    /// Used by `PaymobService` to resolve a presentation anchor without
    /// requiring callers to pass a `UIViewController` through the call stack.
    @MainActor
    func topmostViewController() -> UIViewController? {
        guard
            let windowScene = connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }),
            let rootVC = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController
        else { return nil }

        return rootVC.topmostPresentedViewController()
    }
}

// MARK: - UIViewController helper

private extension UIViewController {
    /// Recursively follows the presentation chain to find the topmost controller.
    func topmostPresentedViewController() -> UIViewController {
        if let presented = presentedViewController {
            return presented.topmostPresentedViewController()
        }
        if let navController = self as? UINavigationController,
           let visible = navController.visibleViewController {
            return visible.topmostPresentedViewController()
        }
        if let tabController = self as? UITabBarController,
           let selected = tabController.selectedViewController {
            return selected.topmostPresentedViewController()
        }
        return self
    }
}

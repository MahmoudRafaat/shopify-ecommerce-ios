import UIKit

extension UIApplication {
    var rootViewController: UIViewController? {
        // Find the active window
        guard let windowScene = connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return nil }
        return window.rootViewController
    }
}

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let tabBarController = UITabBarController()

        let galleryVC = GalleryViewController()
        let galleryNav = UINavigationController(rootViewController: galleryVC)
        galleryNav.tabBarItem = UITabBarItem(
            title: "Gallery",
            image: UIImage(systemName: "photo.circle"),
            selectedImage: UIImage(systemName: "photo.circle.fill")
        )

        let favoritesVC = FavoritePhotosViewController()
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        favoritesNav.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart.circle"),
            selectedImage: UIImage(systemName: "heart.circle.fill")
        )

        tabBarController.viewControllers = [galleryNav, favoritesNav]

        tabBarController.tabBar.barTintColor = UIColor(named: "midnight")
        tabBarController.tabBar.tintColor = UIColor(named: "vanilla")
        tabBarController.tabBar.unselectedItemTintColor = .gray
        tabBarController.tabBar.isTranslucent = false

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}

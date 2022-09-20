//
//  SceneDelegate.swift
//  GhibliAPP
//
//  Created by Stephane Girão Linhares on 08/09/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let safeWindow = UIWindow(windowScene: windowScene)
        safeWindow.frame = UIScreen.main.bounds
        safeWindow.makeKeyAndVisible()
        safeWindow.rootViewController = UINavigationController(
            rootViewController: OnboardingViewController()
        )
        
        self.window = safeWindow
    }

}

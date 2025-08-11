//
//  SceneDelegate.swift
//  JoyBloom
//
//  Created by Eilyn Fabiana Tudares Granadillo on 8/5/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        // Ensure we have a valid windowScene
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Create a new window with the windowScene
        let window = UIWindow(windowScene: windowScene)

        // Load the Main storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        // Instantiate the initial view controller (e.g., Tab Bar Controller)
        let initialViewController = storyboard.instantiateInitialViewController()

        // Set it as root and make visible
        window.rootViewController = initialViewController
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called when the scene is being released.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Restart any tasks paused (or not yet started).
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Sent when the scene will move to an inactive state.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions to the foreground.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions to the background.
    }
}


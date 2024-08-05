//
//  SceneDelegate.swift
//  ToDoListTest
//
//  Created by Константин Евсюков on 03.08.2024.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        self.setupWindow(with: scene)
        self.checkAuthentication()
    }
    
    private func setupWindow(with scene: UIScene) {
        if let windowScene = scene as? UIWindowScene {
            window = UIWindow(windowScene: windowScene)
            self.window?.backgroundColor = .white
            self.window?.makeKeyAndVisible()
        }
    }
    
    public func checkAuthentication() {
        if Auth.auth().currentUser == nil {
            let mainController = SignInViewController()
            let navigationController = UINavigationController(rootViewController: mainController)
            self.window?.rootViewController = navigationController
        } else {
            let mainController = HomeViewController()
            let navigationController = UINavigationController(rootViewController: mainController)
            self.window?.rootViewController = navigationController
        }
    }
}


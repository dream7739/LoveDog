//
//  SceneManager.swift
//  LoveDog
//
//  Created by 홍정민 on 8/15/24.
//

import UIKit

struct SceneManager {
    private init(){ }
    
    static func transitionScene<T: UIViewController>(_ viewController: T){
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = viewController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}

//
//  AppDelegate.swift
//  ToyList
//
//  Created by Jonas Rodrigues de Oliveira on 15/10/22.
//  Copyright © 2022 FIAP. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		FirebaseApp.configure()

        return true
    }
}


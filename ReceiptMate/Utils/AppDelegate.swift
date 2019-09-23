//
//  AppDelegate.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 7/14/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit
import LazyUI
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Mark: - Firebase set up
        FirebaseApp.configure()
        
        // Mark: - LazyUI set up
        
        let receiptMateTheme = LUIColor(theme: UIColor(hexString: "#B76E79"), border: UIColor(hexString: "#A499B3"), shadow: UIColor.black.withAlphaComponent(0.6), darkBackground: UIColor(hexString: "#643C42"), lightBackground: UIColor.white, intermediateBackground: UIColor(hexString: "#A18388"), darkText: UIColor(hexString: "#43282C"), lightText: UIColor.white, intermediateText: UIColor(hexString: "#A18388"), affirmation: UIColor(hexString: "78BC61"), negation: UIColor.red)
        LUIThemeManager.shared.setUniversalTheme(with: receiptMateTheme)
        
        let fontSizes = LUIFontSize(title: 34.0, large: 24.0, regular: 16.0, small: 12.0)
        LUIFontManager.shared.setUniversalFont(named: "Didot", for: fontSizes)
        
        let paddingSizes = LUIPadding(large: 32.0, regular: 16.0, small: 8.0)
        LUIPaddingManager.shared.setUniversalPadding(for: paddingSizes)
        
        let animationTimes = LUIAnimationSpeed(slow: 1.0, regular: 0.5, fast: 0.2, minimum: 0.08)
        LUIAnimationSpeedManager.shared.setUniversalAnimationSpeed(with: animationTimes)
        
        // Mark: - root view controller
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = LUINavigationViewController(rootVC: LoginViewController(nibName: nil, bundle: nil))
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


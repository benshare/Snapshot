//
//  AppDelegate.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/2/21.
//

import UIKit
import Amplify

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        initializeAmplify()
        setInitialViewController()
        additionalOnLaunch()
        
        ACTIVE_USER_GROUP.wait()
        return true
    }
    
    // MARK: Setup
    private func setInitialViewController() {
        let initialViewController: UIViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        window = UIWindow()

        let username = getLoggedInUser()
        if username != nil {
            loadActiveUser(username: username!)
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "mainMenu")
            initialViewController = mainViewController
        } else {
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginPage")
            initialViewController = loginViewController
        }
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }

    func additionalOnLaunch() {
//        generateNewLayout(name: "ConfirmAccount", elements: [
//            ("navigationBar", "NavigationBarView"),
//            ("codeField", "UITextField"),
//            ("resendButton", "UIButton"),
//            ("confirmButton", "UIButton"),
//         ])
    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
    
    // MARK: Application Transitions
    func applicationWillTerminate(_ application: UIApplication) {
        print("Will terminate")
        runOnExit()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Entered background")
        runOnExit()
    }
    
    func runOnExit() {
    }
}

    


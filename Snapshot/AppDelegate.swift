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

    


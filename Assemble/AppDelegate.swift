//
//  AppDelegate.swift
//  Assemble
//
//  Created by Will Olson on 9/17/21.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuthUI
import FirebaseEmailAuthUI
import FirebaseGoogleAuthUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate, FUIAuthDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        configureAuth()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            self.handleIncomingDynamicLink(dynamicLink)
            return true
        }
        
        return false
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication ?? "") ?? false {
            return true
        }
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            self.handleIncomingDynamicLink(dynamicLink)
            return true
        }
        
        return false
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let incomingURL = userActivity.webpageURL {
            print("Incoming URL is \(incomingURL)")
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { dynamicLink, error in
                guard error == nil else {
                    print("Found an error! \(error!.localizedDescription)")
                    return
                }
                if let dynamicLink = dynamicLink {
                    self.handleIncomingDynamicLink(dynamicLink)
                }
            }
            
            return linkHandled
        }
        
        return false
    }
    
    func handleIncomingDynamicLink(_ dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url else {
            print("That's weird. My dynamic link object has no url.")
            return
        }
        
        // IMPORTANT: For now, we are only going to process event invite links
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else { return }
        
        let path = components.path
        guard path == "/events/accept-invitation",
              let eventUid = queryItems.filter({$0.name == "eventUid"}).first?.value,
              let inviteCode = queryItems.filter({$0.name == "inviteCode"}).first?.value else { return }
        
        let firebaseService = FirebaseService()
        firebaseService.getEvent(eventUid) { event, error in
            guard error == nil, let event = event else { return }
            
//            firebaseService.addUserToGuestList(<#T##user: User##User#>, event: <#T##Event#>, inviteCode: <#T##String#>)
        }
    }
    
    // MARK: - Authentication
    
    func configureAuth() {
        let authUI = FUIAuth.defaultAuthUI()!
        authUI.delegate = self
        
        let providers: [FUIAuthProvider] = [
            FUIEmailAuth(),
            FUIGoogleAuth(authUI: authUI)
        ]
        authUI.providers = providers
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Assemble")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


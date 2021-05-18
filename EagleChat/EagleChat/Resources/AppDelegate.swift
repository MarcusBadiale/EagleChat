//
//  AppDelegate.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 11/05/21.
//

import UIKit
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            if let error = error {
                print("Failed to sign in with google: ", error)
            }
            return
        }
        
        guard let email = user.profile.email,
              let firstName = user.profile.givenName,
              let lastName = user.profile.familyName else {
            return
        }
        
        let chatUser = ChatAppUser(firstName: firstName, lastName: lastName, email: email)
        
        DatabaseManager.shared.userExists(with: email) { exists in
            if !exists {
                UserDefaults.standard.set(email, forKey: "email")
                // Insert to database
                DatabaseManager.shared.insertUser(
                    with: chatUser
                ) { success in
                    if success {
                        // upload image
                        if user.profile.hasImage {
                            guard let url = user.profile.imageURL(withDimension: 100) else {
                                return
                            }
                            
                            let fileName = chatUser.profilePictureFileName
                            
                            URLSession.shared.dataTask(with: url) { data, _, _ in
                                guard let data = data else {
                                    return
                                }
                                StorageManager.shared.uploadProfilePicture(
                                    with: data,
                                    filename: fileName
                                ) { result in
                                    switch result {
                                    case let .success(urlString):
                                        UserDefaults.standard.set(urlString, forKey: "profile_picture_url")
                                        print(urlString)
                                        
                                    case let .failure(error):
                                        print(error)
                                    }
                                }
                            }.resume()
                        }
                    }
                }
            }
        }
        
        guard let authentication = user.authentication else {
            print("Missing auth object of google user")
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        FirebaseAuth.Auth.auth().signIn(with: credential) { authResult, error in
            guard authResult != nil,
                  error == nil else {
                print("Failed to log in with google credential")
                return
            }
            
            print("Sucessfully to sign in with google credential")
            
            NotificationCenter.default.post(name: .googleLogInNotification, object: nil)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Google user was disconnected")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
}

//
//  RKGoogleManager.swift
//  RKSocialLogin
//
//  Created by RakeshPC on 17/02/20.
//  Copyright © 2020 RakeshPC. All rights reserved.
//

import UIKit
import GoogleSignIn

class RKGoogleManager: NSObject, GIDSignInDelegate {

    static let loginManager : RKGoogleManager = RKGoogleManager()
    
    var completionHandler : SJSocialCompletionHandler!
    static let CancelErrorMsg = "Google login cancelled."
    static let NoTokenErrorMsg = "Google token not found."
    static let LoginSuccessMsg = "Google login success."
    
    static func login(controller : UIViewController, completionHandler : @escaping SJSocialCompletionHandler){
        
        GIDSignIn.sharedInstance().signOut()
        RKGoogleManager.loginManager.completionHandler = completionHandler
        GIDSignIn.sharedInstance().clientID = "787906768706-ju12rf9p98vdbpv4gd7hnq2qguhn4vlk.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = RKGoogleManager.loginManager
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
            completionHandler(false, error.localizedDescription, nil)
        } else {
            // Perform any operations on signed in user here.
            let userInfo = RKSocialUser()
            userInfo.socialType = SocialType.GOOGLE
            
            userInfo.fullName = user.profile.name
            userInfo.fName = user.profile.givenName
            userInfo.lName = user.profile.familyName
            userInfo.emailId = user.profile.email
            userInfo.socialId = user.userID
            userInfo.socialIdToken = user.authentication.idToken
            
            if self.completionHandler != nil {
                self.completionHandler(true, RKGoogleManager.LoginSuccessMsg, userInfo)
            }
            // ...
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}

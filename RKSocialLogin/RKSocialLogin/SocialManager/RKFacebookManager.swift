//
//  RKFacebookManager.swift
//  RKSocialLogin
//
//  Created by RakeshPC on 17/02/20.
//  Copyright © 2020 RakeshPC. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

typealias SJSocialCompletionHandler = (_ isSuccess: Bool, _ msg: String?, _ userObject: RKSocialUser?)->Void

class RKFacebookManager: NSObject {

    static let CancelErrorMsg = "Facebook login cancelled."
    static let NoTokenErrorMsg = "Facebook token not found."
    static let LoginSuccessMsg = "Facebook login success."
    
    #if DEBUG
    
    #endif
    
    static func login(controller : UIViewController, completionHandler : @escaping SJSocialCompletionHandler){
        
        let loginManager : LoginManager = LoginManager()
        loginManager .logOut()
        AccessToken.current = nil
        Profile.current = nil
      
        loginManager .logIn(permissions: ["public_profile", "email", "user_friends"], from: controller) { (result, error) in
            
            if error != nil {
                completionHandler(false, error?.localizedDescription, nil)
            }else if result?.isCancelled == true {
                completionHandler(false, RKFacebookManager.CancelErrorMsg, nil)
            }else{
                if AccessToken.current != nil {
                    // Use <userData> or create new one?
                    var params = NSMutableDictionary() as NSDictionary? as? [AnyHashable: Any] ?? [:]
                    
                    // Set base properties
                    params["fields"] = "first_name, last_name, picture.type(large), email, name, id, gender"
                    let request : GraphRequest = GraphRequest(graphPath: "me", parameters:params as! [String : Any])
                    request.start(completionHandler: { (requestConnection, graphResult, graphError) in
                        
                        if result != nil {
                            loginManager .logOut()
                            let user = RKSocialUser.createUserWithFacebook(data: graphResult as! NSDictionary)
                            completionHandler(true, RKFacebookManager.LoginSuccessMsg, user)
                        }else{
                            completionHandler(false, graphError?.localizedDescription, nil)
                        }
                    })
                    
                }else{
                    completionHandler(false, RKFacebookManager.NoTokenErrorMsg, nil)
                }
            }
        }
    }
}

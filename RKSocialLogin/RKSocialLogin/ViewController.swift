//
//  ViewController.swift
//  RKSocialLogin
//
//  Created by RakeshPC on 17/02/20.
//  Copyright © 2020 RakeshPC. All rights reserved.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
//MARK: FaceBook login
    
    @IBAction func touch_fb_signin(_ sender: Any) {
        RKFacebookManager.login(controller: self) { (isSuccess, msg, user) in
            debugPrint(msg!)
            if user != nil {
                print(user?.fullName)
                print(user?.emailId)
                print(user?.imageURL)
            }
        }
    }
    
    @IBAction func touch_google_signin(_ sender: Any) {
        GIDSignIn.sharedInstance().uiDelegate = self
        RKGoogleManager.login(controller: self) { (isSuccess, msg, user) in
            debugPrint(msg!)
            if user != nil {
                debugPrint("User Name : ", user?.fName! ?? "Not Found")
            }
        }
    }

}


//
//  Alert.swift
//  Frashly
//
//

import Foundation
import UIKit

struct Alert {
    
    private static func showBasicAlert(on vc: UIViewController, with title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
        
    }
    
    
    
    
    static func showSearchNotFoundAlert( on vc: UIViewController){
        showBasicAlert(on: vc, with: "Search Result" , message: "No Product Found")
    }
    static func showLogoutAlert( on vc: UIViewController){
        showBasicAlert(on: vc, with: "SUCCESS" , message: "loggedout successfully")
    }
    
    static func showSignupSuccessAlert( on vc: UIViewController){
        showBasicAlert(on: vc, with: "SUCCESS" , message: "Your account has been successfully created")
    }
    static func showSignupUnSuccessAlert( on vc: UIViewController){
        showBasicAlert(on: vc, with: "Result" , message: "Please enter Valid credentials")
    }
    static func showLoginSuccessAlert( on vc: UIViewController){
        showBasicAlert(on: vc, with: "SUCCESS" , message: "logged in successfully")
    }
    static func sessionTimedOutAlert( on vc: UIViewController){
        showBasicAlert(on: vc, with: "Result" , message: "Your Session has expired Please login again")
    }
    static func LoginAlert( on vc: UIViewController){
        showBasicAlert(on: vc, with: "Result" , message: "Please Login First")
    }
    static func DeletionSuccessAlert( on vc: UIViewController){
        showBasicAlert(on: vc, with: "Result" , message: "Deletion Successfull")
    }
    static func OrderSuccessfullAlert( on vc: UIViewController){
        showBasicAlert(on: vc, with: "SUCCESS" , message: "Your Order is placed successfully")
    }
    static func PasswordResetAlert( on vc: UIViewController){
        showBasicAlert(on: vc, with: "Alert" , message: "Since you have opted for password reset now please log in again")
    }
    static func addressChangeAlert( on vc: UIViewController){
        showBasicAlert(on: vc, with: "SUCCESS" , message: "Your Address is changed successfully")
    }
        
   
    
}

extension UIAlertController {
    
    func presentInOwnWindow(animated: Bool, completion: (() -> Void)?) {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(self, animated: animated, completion: completion)
    }
    
}


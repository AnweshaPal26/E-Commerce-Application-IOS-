//
//  MyAccountVC.swift
//  Frashly
//
//

import UIKit


class MyAccountVC: UIViewController {
    
   

    @IBOutlet weak var lbl_name: UILabel!
    
    @IBOutlet weak var lbl_phone: UILabel!
    
    @IBOutlet weak var lbl_email: UILabel!
    
    
    @IBOutlet weak var vw_loginBgView: UIView!
    
    @IBOutlet weak var vw_loginContainerView: UIView!
    
    @IBOutlet weak var txt_email: UITextField!
    
    @IBOutlet weak var txt_pass: UITextField!
    
    var userLoginResponse:UserLoginResponse!
    
    var passReset: PassResetResponse!
    
    var token = UserDefaults.standard.value(forKey: "token") as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        

        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if token == nil
        {
            print("else part")
            self.vw_loginBgView.isHidden = false
            self.vw_loginContainerView.isHidden = false
        }
        else {
            if counter == true
            {
                lbl_email.text = UserDefaults.standard.value(forKey: "email") as? String
                self.vw_loginBgView.isHidden = true
                self.vw_loginContainerView.isHidden = true
            }
            else{
                self.vw_loginBgView.isHidden = false
                self.vw_loginContainerView.isHidden = false
                Alert.sessionTimedOutAlert(on: self)
            }
        }
        
    }
    
    @IBAction func btn_edit(_ sender: Any) {
    }
    
    @IBAction func act_myOrders(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyOrdersVC") as? MyOrdersVC
        hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc!, animated: true)
        hidesBottomBarWhenPushed = false
    }
    

    
    @IBAction func act_changePass(_ sender: Any) {
        let alert = UIAlertController(title: "Alert", message: "Do you really want to change your password? (Note: if you choose Ok , then you have to login again)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
        var passUrl = URLRequest(url: URL(string: "https://warm-woodland-35878.herokuapp.com/auth/reset")!)
            let mydict = NetworkManager().decode(self.token!)
        let temp  = mydict?["user_id"]
            passUrl.setValue("Bearer "+self.token!, forHTTPHeaderField: "Authorization")
        let request = ResetPassword(email: (UserDefaults.standard.value(forKey: "email") as? String)!, uid: temp as! String )
        do {
            
            let encodedRequest = try JSONEncoder().encode(request)
            NetworkManager().postResetPassword(requestUrl: passUrl, requestBody: encodedRequest, resultType: PassResetResponse.self) { (passResponse) in
                self.passReset = passResponse
                DispatchQueue.main.async{
                    if let link = URL(string: self.passReset.passwordResetLink) {
                        UIApplication.shared.open(link)
                    }
                    UserDefaults.standard.removeObject(forKey: "email")
                    UserDefaults.standard.removeObject(forKey: "token")
                    UserDefaults.standard.synchronize()
                    wishlists.removeAll()
                    self.navigationController!.popToViewController(self, animated: true)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as? UITabBarController
                    self.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc!, animated: true)
                    self.hidesBottomBarWhenPushed = true
                    Alert.PasswordResetAlert(on: self)
                    
                    
                    
                    
                }
            }
            
        } catch let error {
            
            debugPrint("error = \(error.localizedDescription)")
        }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func act_legal(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LegalVC") as? LegalVC
        hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc!, animated: true)
        hidesBottomBarWhenPushed = false
        
    }
    
    
    @IBAction func act_logout(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to log out?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "token")
            UserDefaults.standard.synchronize()
            wishlists.removeAll()
            self.navigationController!.popToViewController(self, animated: true)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as? UITabBarController
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc!, animated: true)
            self.hidesBottomBarWhenPushed = true
            Alert.showLogoutAlert(on: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        }
        
    
    
    @IBAction func act_forgotPass(_ sender: Any) {
    }
    
    @IBAction func act_login(_ sender: Any) {
        
        let registrationUrl = URL(string: "https://warm-woodland-35878.herokuapp.com/auth/signin")
        let request = UserLoginRequest(email: txt_email.text!, password: txt_pass.text!)
        
        do {
            
            let encodedRequest = try JSONEncoder().encode(request)
            NetworkManager().postLogin(requestUrl: registrationUrl!, requestBody: encodedRequest, resultType: UserLoginResponse.self) { (userLoginResponse) in
                self.userLoginResponse = userLoginResponse
                DispatchQueue.main.async{
                    UserDefaults.standard.setValue(self.userLoginResponse.email, forKey: "email")
                    UserDefaults.standard.setValue(self.userLoginResponse.idToken, forKey: "token")
                    print("successfully logged in")
                    counter = true
                    self.navigationController!.popToViewController(self, animated: true)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as? UITabBarController
                    self.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc!, animated: true)
                    self.hidesBottomBarWhenPushed = true
                    Alert.showLoginSuccessAlert(on: self)
                    
                    
                }
            }
            
        } catch let error {
            
            debugPrint("error = \(error.localizedDescription)")
        }
        
            
        }
        
        
    
    
    @IBAction func act_moveToRegisterPg(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupVC") as? SignupVC
        hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc!, animated: true)
        hidesBottomBarWhenPushed = true
    }
    
}
extension MyAccountVC: UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txt_email.resignFirstResponder()
        self.txt_pass.resignFirstResponder()
        return true
    }
}



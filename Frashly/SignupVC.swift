//
//  SignupVC.swift
//  Frashly
//
//

import UIKit


class SignupVC: UIViewController {

    @IBOutlet weak var txt_name: UITextField!
    
    @IBOutlet weak var txt_email: UITextField!
    
    @IBOutlet weak var txt_mobile: UITextField!
    
    @IBOutlet weak var txt_pass: UITextField!
    
    @IBOutlet weak var txt_address: UITextField!
    
     var status = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btn_register(_ sender: Any) {
        ValidationCode()
    }
    
    func register(){
        let registrationUrl = URL(string: "https://warm-woodland-35878.herokuapp.com/auth/signup")
        let request = UserSignupRequest(email: txt_email.text!, password: txt_pass.text!, address:txt_address.text! , name:txt_name.text!, mobile:txt_mobile.text!)
        do{
            let encodedRequest = try JSONEncoder().encode(request)
            NetworkManager().postSignup(requestUrl: registrationUrl!, requestBody: encodedRequest)
            DispatchQueue.main.async{
                self.navigationController!.popToViewController(self, animated: true)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as? UITabBarController
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc!, animated: true)
                self.hidesBottomBarWhenPushed = true
            }
            
        }
        catch{
            debugPrint("error = \(error.localizedDescription)")
        }
    }
    

    @IBAction func act_moveToLoginPg(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension SignupVC: UITextFieldDelegate{


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txt_name.resignFirstResponder()
        self.txt_email.resignFirstResponder()
        self.txt_pass.resignFirstResponder()
        self.txt_mobile.resignFirstResponder()
        self.txt_address.resignFirstResponder()
        return true
    }
}

extension SignupVC{
    fileprivate func ValidationCode() {
        if let email = txt_email.text, let password = txt_pass.text,let phone = txt_mobile.text,let name = txt_name.text, let address = txt_address.text{
            if email == ""{
                openAlert(title: "Alert", message: "Please add email.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                    print("Okay clicked!")
                    }])
            }
            else if !email.validateEmailId(){
                openAlert(title: "Alert", message: "Please enter valid email", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                    print("Okay clicked!")
                    }])
            }
            else if password == ""{
                openAlert(title: "Alert", message: "Please add password.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                    print("Okay clicked!")
                    }])
            }
            else if !password.validatePassword(){
                openAlert(title: "Alert", message: "Please enter valid password", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                    print("Okay clicked!")
                    }])
            }
            else if phone == ""{
                openAlert(title: "Alert", message: "Please add phone number.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                    print("Okay clicked!")
                    }])
            }
            else if !phone.isValidPhone(phone: phone){
                openAlert(title: "Alert", message: "Please enter valid phone number", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                    print("Okay clicked!")
                    }])
            }
            else if name == ""{
                openAlert(title: "Alert", message: "Please add name.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                    print("Okay clicked!")
                    }])
            }
            else if address == ""{
                openAlert(title: "Alert", message: "Please add address.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                    print("Okay clicked!")
                    }])
            }
            else{
               register()
            }
        }else{
            openAlert(title: "Alert", message: "Please add detail.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                print("Okay clicked!")
                }])
        }
    }
}




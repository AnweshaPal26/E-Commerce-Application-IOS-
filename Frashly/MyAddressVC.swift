//
//  MyAddressVC.swift
//  Frashly
//
//

import UIKit

class MyAddressVC: UIViewController {

    @IBOutlet weak var lbl_currentAddress: UILabel!
    
    @IBOutlet weak var txt_newAddress: UITextField!
    var token = UserDefaults.standard.value(forKey: "token") as? String
     var myAddress = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_currentAddress.text = myAddress
       
    }
    
    @IBAction func act_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func act_updateAddress(_ sender: Any) {
        if token != nil && counter == false{
            self.navigationController!.popToViewController(self, animated: true)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as? UITabBarController
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc!, animated: true)
            self.hidesBottomBarWhenPushed = true
            Alert.sessionTimedOutAlert(on: self)
        }
        else{
            let mydict = NetworkManager().decode(token!)
            let temp  = mydict?["user_id"]
            var changeAddApi = URLRequest(url: URL(string: "https://warm-woodland-35878.herokuapp.com/customers/updateaddress")!)
            let request = ChangeAdress(uid: temp as! String, address: txt_newAddress.text!)
            do {
                
                let encodedRequest = try JSONEncoder().encode(request)
                changeAddApi.setValue("Bearer "+token!, forHTTPHeaderField: "Authorization")
                NetworkManager().addRequest(requestUrl: changeAddApi, requestBody: encodedRequest)
                DispatchQueue.main.async{
                    self.navigationController!.popToViewController(self, animated: true)
                    Alert.addressChangeAlert(on: self)
                    self.lbl_currentAddress.text = self.txt_newAddress.text!
                    self.txt_newAddress.text = ""
                }
                
            }
            catch let error {
                
                debugPrint("error = \(error.localizedDescription)")
            }
        }

        
    }
    
}
extension MyAddressVC: UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txt_newAddress.resignFirstResponder()
        return true
    }
}

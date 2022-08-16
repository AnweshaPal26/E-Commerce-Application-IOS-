//
//  CheckoutVC.swift
//  Frashly
//
//

import UIKit
import Razorpay

class CheckoutVC: UIViewController, RazorpayPaymentCompletionProtocol {
    

    @IBOutlet weak var lbl_name: UILabel!
    
    @IBOutlet weak var lbl_mobile: UILabel!
    
    @IBOutlet weak var lbl_address: UILabel!
    
     var token = UserDefaults.standard.value(forKey: "token") as? String
    var customer:Customer!
    
    var paymenyMethod = "COD"
    var ischeckCod = true
    var ischeckOnline = false
    var ammount: Float!
    
    
    @IBOutlet weak var btn_cod: UIButton!
    
    @IBOutlet weak var btn_online: UIButton!
    
     var razorpay: Razorpay!
    override func viewDidLoad() {
        super.viewDidLoad()
        razorpay = Razorpay.initWithKey("rzp_test_0rYPArYidDZINR", andDelegate: self)      
    }
    internal func showPaymentForm(){
        let options: [String:Any] = [
            "amount": (ammount! * 100),
            "currency": "INR",
            "description": "",
            "name": "Frashly",
            "prefill": [
                "contact": customer.mobile,
                "email": customer.email
            ],
            "theme": [
                "color": "#F37254"
            ]
        ]
        razorpay.open(options, displayController: self)
    }
     override func viewWillAppear(_ animated: Bool) {
        let mydict = NetworkManager().decode(token!)
        let temp  = mydict?["user_id"]
        var custApi = URLRequest(url: URL(string: "https://warm-woodland-35878.herokuapp.com/customers/\(temp!)")!)
        custApi.setValue("Bearer "+token!, forHTTPHeaderField: "Authorization")
        NetworkManager().getApiData(requestUrl: custApi, resultType: Customer.self)
        { (customer) in
            self.customer = customer
            DispatchQueue.main.async{
                self.lbl_name.text = customer.name
                self.lbl_mobile.text = customer.mobile
                self.lbl_address.text = customer.address
            }
        }
    }
    

    @IBAction func act_back(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    
  
    @IBAction func btn_changeAddress(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyAddressVC") as? MyAddressVC
        self.hidesBottomBarWhenPushed = true
        vc?.myAddress = customer.address
        self.navigationController?.pushViewController(vc!, animated: true)
        self.hidesBottomBarWhenPushed = true
    }
    
    @IBAction func act_cod(_ sender: Any) {
        if ischeckCod == true{
            print(paymenyMethod)
        }
        else{
            ischeckCod = true
            paymenyMethod = "COD"
            ischeckOnline = false
            btn_cod.setImage(UIImage(named: "check.png"), for: .normal)
            btn_online.setImage(UIImage(named: "boxuncheck.png"), for: .normal)
            print(paymenyMethod)
        }
    }
    
    @IBAction func act_online(_ sender: Any) {
        if ischeckOnline == true{
            print(paymenyMethod)
        }
        else{
           ischeckOnline = true
            paymenyMethod = "Online"
            ischeckCod = false
            btn_cod.setImage(UIImage(named: "boxuncheck.png"), for: .normal)
            btn_online.setImage(UIImage(named: "check.png"), for: .normal)
            print(paymenyMethod)
        }
    }
    
    
    @IBAction func act_placeOrder(_ sender: Any) {
        
        if paymenyMethod == "COD"{
        
        let mydict = NetworkManager().decode(token!)
        let temp  = mydict?["user_id"]
        var orderApi = URLRequest(url: URL(string: "https://warm-woodland-35878.herokuapp.com/orders")!)
        orderApi.setValue("Bearer "+token!, forHTTPHeaderField: "Authorization")
        let request = PlaceOrder(uid: temp as! String, deliveryAddress: "\(customer.address)")
        do {
            
            let encodedRequest = try JSONEncoder().encode(request)
            NetworkManager().addRequest(requestUrl: orderApi, requestBody: encodedRequest)
            DispatchQueue.main.async{
                print("order successfull")       
                self.navigationController!.popToViewController(self, animated: true)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as? UITabBarController
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc!, animated: true)
                self.hidesBottomBarWhenPushed = true
                Alert.OrderSuccessfullAlert(on: self)

                
            }
            
        }
        catch let error {
            
            debugPrint("error = \(error.localizedDescription)")
        }
        }
        else
        {
             self.showPaymentForm()
        }
        
        
    }
    func onPaymentError(_ code: Int32, description str: String) {
        let alertController = UIAlertController(title: "Failure", message: str, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.view.window?.rootViewController?.present(alertController,animated: true,completion: nil)
    }
    func onPaymentSuccess(_ payment_id: String) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as? UITabBarController
        hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc!, animated: true)
        hidesBottomBarWhenPushed = true
        let mydict = NetworkManager().decode(token!)
        let temp  = mydict?["user_id"]
        var orderApi = URLRequest(url: URL(string: "https://warm-woodland-35878.herokuapp.com/orders")!)
        orderApi.setValue("Bearer "+token!, forHTTPHeaderField: "Authorization")
        let request = PlaceOrder(uid: temp as! String, deliveryAddress: "\(customer.address)")
        do {
            
            let encodedRequest = try JSONEncoder().encode(request)
            NetworkManager().addRequest(requestUrl: orderApi, requestBody: encodedRequest)
            DispatchQueue.main.async{
                print("order successfull")
                Alert.OrderSuccessfullAlert(on: self)
            }
            
        }
        catch let error {
            
            debugPrint("error = \(error.localizedDescription)")
        }
    }
    
}

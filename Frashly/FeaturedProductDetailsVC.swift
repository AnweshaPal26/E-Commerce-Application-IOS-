//
//  FeaturedProductDetails.swift
//  Frashly
//
//

import UIKit

class FeaturedProductDetailsVC: UIViewController {

    @IBOutlet weak var img_product: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_descript: UILabel!
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var lbl_qty: UILabel!
    
     var ImageCacheData = NSCache<NSString,UIImage>()
     var token = UserDefaults.standard.value(forKey: "token") as? String
    var qty = 1
    
    var image = ""
    var name = ""
    var price = ""
    var descript = ""
    var product_id = ""
    
    override func viewWillAppear(_ animated: Bool) {
        
        if token == nil && counter ==  true{
            self.bg_view.isHidden = true
        }
        else if wishlists.isEmpty == true{
            self.bg_view.isHidden = true
        }
        else{
            for wish in wishlists{
                if wish == product_id
                {
                    self.bg_view.isHidden = false
                    break
                }
            }
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_name.text = name
        lbl_price.text = price
        lbl_descript.text = descript
        let url = URL(string: image)
        img_product.downloadingImage(from: url!,imgCacheData: ImageCacheData,counter: name)
        img_product.contentMode = .scaleToFill
        lbl_qty.text = String(qty)
        

    }
    
    @IBAction func act_increase(_ sender: Any) {
        qty = qty + 1
        lbl_qty.text = String(qty)
    }
    
    @IBAction func act_decrease(_ sender: Any) {
        if qty > 1{
            qty = qty - 1
            lbl_qty.text = String(qty)
        }
    }
    
    @IBAction func act_back(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func act_gotoCart(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CartVC") as? CartVC
        hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc!, animated: true)
        hidesBottomBarWhenPushed = true
        
    }
    
    @IBAction func act_addToCart(_ sender: Any) {
        if token == nil && counter ==  true
        {
            Alert.LoginAlert(on: self)
        }
        else if token != nil && counter == false{
            Alert.sessionTimedOutAlert(on: self)
        }
        else{
            let mydict = NetworkManager().decode(token!)
            let temp  = mydict?["user_id"]
            var cartApi = URLRequest(url: URL(string: "https://warm-woodland-35878.herokuapp.com/customers/\(temp!)/cart")!)
            let intprice = Int(Float(price)!)
            let request = CartAddRequest(pid: product_id, qty: qty, price: intprice)
            do {

                let encodedRequest = try JSONEncoder().encode(request)
                cartApi.setValue("Bearer "+token!, forHTTPHeaderField: "Authorization")
                NetworkManager().addRequest(requestUrl: cartApi, requestBody: encodedRequest)
                DispatchQueue.main.async{
                    print("adding successfull")
                }

            }
            catch let error {

                debugPrint("error = \(error.localizedDescription)")
            }
        }



    }
    

    @IBAction func act_addToWish(_ sender: Any) {
        if token == nil && counter ==  true
        {
            Alert.LoginAlert(on: self)
        }
        else if token != nil && counter == false{
            Alert.sessionTimedOutAlert(on: self)
        }
        else{
            let mydict = NetworkManager().decode(token!)
            let temp  = mydict?["user_id"]
            var wishApi = URLRequest(url: URL(string: "https://warm-woodland-35878.herokuapp.com/customers/\(temp!)/wishlist/\(product_id)")!)
            let request = WishListRequest(cid: temp as! String, pid: product_id)
            do {
                
                let encodedRequest = try JSONEncoder().encode(request)
                wishApi.setValue("Bearer "+token!, forHTTPHeaderField: "Authorization")
                NetworkManager().addRequest(requestUrl: wishApi, requestBody: encodedRequest)
                DispatchQueue.main.async{
                    print("adding successfull")
                    wishlists.append(self.product_id)
                    self.bg_view.isHidden = false
                }
            }
            catch let error {
                
                debugPrint("error = \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func act_removeFromWish(_ sender: Any) {
        let mydict = NetworkManager().decode(token!)
        let temp  = mydict?["user_id"]
        var wishApi = URLRequest(url: URL(string: "https://warm-woodland-35878.herokuapp.com/customers/\(temp!)/wishlist/\(product_id)")!)
        let request = WishListRequest(cid: temp as! String, pid: product_id)
        do {
            
            let encodedRequest = try JSONEncoder().encode(request)



            wishApi.setValue("Bearer "+token!, forHTTPHeaderField: "Authorization")
            NetworkManager().deleteRequest(requestUrl: wishApi, requestBody: encodedRequest)
            DispatchQueue.main.async{
                print("delete successfull")
                if let firstIndex = wishlists.index(of: self.product_id) {
                    wishlists.remove(at: firstIndex)
                    print (wishlists)
                }
                self.bg_view.isHidden = true
            }
        }
        catch let error {
            
            debugPrint("error = \(error.localizedDescription)")
        }
    }
}

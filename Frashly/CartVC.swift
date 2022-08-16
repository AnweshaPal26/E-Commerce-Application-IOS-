//
//  CartVC.swift
//  Frashly
//
//

import UIKit

class CartVC: UIViewController {
    
    @IBOutlet weak var cart_tblView: UITableView!
    
    @IBOutlet weak var lbl_totalPrice: UILabel!
    
    @IBOutlet weak var bg_view1: UIView!
    var totAmmount: Float!
    
    var productsList = [Products]()
    var cartList = [Carts]()

    var carts = [Cartproducts]()
    var ImageCacheData = NSCache<NSString,UIImage>()
    var token = UserDefaults.standard.value(forKey: "token") as? String
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if token == nil && counter ==  true{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyAccountVC") as? MyAccountVC
            hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc!, animated: true)
            hidesBottomBarWhenPushed = false
        }
        else if token != nil
        {
            if counter == true{
            let mydict = NetworkManager().decode(token!)
            let temp  = mydict?["user_id"]
            var cartApi = URLRequest(url: URL(string: "https://warm-woodland-35878.herokuapp.com/customers/\(temp!)/cart")!)
            cartApi.addValue("application/json", forHTTPHeaderField: "Content-Type")
            cartApi.setValue("Bearer "+token!, forHTTPHeaderField: "Authorization")
            NetworkManager().getApiData(requestUrl: cartApi, resultType: [Carts].self)
            { (carts) in
                self.cartList = carts
                DispatchQueue.main.async{
                    print(self.cartList)
                    if counter == false{
                        print("please login again")
                        UserDefaults.standard.removeObject(forKey: "email")
                        UserDefaults.standard.removeObject(forKey: "token")
                        UserDefaults.standard.synchronize()
                        wishlists.removeAll()
                        self.navigationController!.popToViewController(self, animated: true)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyAccountVC") as? MyAccountVC
                        self.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc!, animated: true)
                        self.hidesBottomBarWhenPushed = true
                        Alert.sessionTimedOutAlert(on: self)
                    }
                    else{
                        if self.cartList.isEmpty == true
                        {
                            self.bg_view1.isHidden = false
                        }
                        else{
                            self.cart_tblView.showActivityIndicator()
                            NetworkManager().getApiData(requestUrl: URLRequest(url: URL(string: "https://warm-woodland-35878.herokuapp.com/products")!), resultType: [Products].self)
                            { (products) in
                                self.productsList = products
                                DispatchQueue.main.async{
                                    for cart in self.cartList{
                                        for pro in self.productsList
                                        {
                                            if cart.pid == pro.pid
                                            {
                                                let cartitem = Cartproducts(pid: pro.pid, img: pro.img, name: pro.name, qty: cart.qty, bundlePrice: cart.bundlePrice, price: pro.price )
                                                var check = false
                                                self.carts = self.carts.map{
                                                    let cartBook = $0
                                                    if $0.pid == cartitem.pid {
                                                        cartBook.qty += cartitem.qty
                                                        cartBook.bundlePrice += cartitem.bundlePrice
                                                        check = true
                                                    }
                                                    return cartBook
                                                }
                                                if check == false{
                                                    self.carts.append(cartitem)
                                                }
                                            }
                                                
                                        }
                                    }
                                    print(self.carts)
                                    self.cart_tblView.reloadData()
                                    self.cart_tblView.hideActivityIndicator()
                                    var tot_price = 0
                                    for c in carts {
                                        tot_price += c.bundlePrice
                                    }
                                    self.lbl_totalPrice.text = "₹"+String(Float(tot_price))
                                    self.totAmmount = Float(tot_price)
                                }
                                    

                            }
                                
                        }
                    }
                    }
                    
                }
            }
            
            else{
                print("please login again")
                UserDefaults.standard.removeObject(forKey: "email")
                UserDefaults.standard.removeObject(forKey: "token")
                UserDefaults.standard.synchronize()
                wishlists.removeAll()
                self.navigationController!.popToViewController(self, animated: true)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyAccountVC") as? MyAccountVC
                hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc!, animated: true)
                hidesBottomBarWhenPushed = true
                Alert.sessionTimedOutAlert(on: self)
            }
        }

   }


       
    
    

    @IBAction func act_back(_ sender: Any) {
          self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_checkout(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckoutVC") as? CheckoutVC
        hidesBottomBarWhenPushed = true
        vc?.ammount = totAmmount
        self.navigationController?.pushViewController(vc!, animated: true)
       hidesBottomBarWhenPushed = true
    }
    
}
extension CartVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.cart_tblView.dequeueReusableCell(withIdentifier: "cart_cell", for: indexPath) as! CartTblCell
        cell.lbl_name.text = carts[indexPath.row].name
        cell.lbl_price.text = "₹"+String(carts[indexPath.row].price)
        cell.lbl_qty.text = "Quantity : "+String(carts[indexPath.row].qty)
        let url = URL(string: carts[indexPath.row].img)
        cell.img_cart.downloadingImage(from: url!, imgCacheData: ImageCacheData, counter: carts[indexPath.row].name)
        cell.img_cart.contentMode = .scaleToFill
        cell.img_cart.layer.cornerRadius = cell.frame.size.height/7.0
        cell.img_cart.layer.borderWidth = 0.5
        cell.img_cart.layer.borderColor = UIColor.lightGray.cgColor
        cell.cart_delete.tag = indexPath.row
        cell.cart_delete.addTarget(self, action: #selector(addtoButton), for: .touchUpInside)
        return cell
    }
    @objc func addtoButton(sender:UIButton) {
        let indexpath1 = IndexPath(row: sender.tag, section: 0)
        print(carts[indexpath1.row].pid)
        let mydict = NetworkManager().decode(token!)
        let temp  = mydict?["user_id"]
        var cartApi = URLRequest(url: URL(string: "https://warm-woodland-35878.herokuapp.com/customers/\(temp!)/cart")!)
        let index = cartList.index(where: {$0.pid == carts[indexpath1.row].pid})!
        let request = CartDeleteRequest(index: String(index))
        let ind = carts.index(where: {$0.pid == carts[indexpath1.row].pid})!
        
        do {
            
            let encodedRequest = try JSONEncoder().encode(request)
            cartApi.setValue("Bearer "+token!, forHTTPHeaderField: "Authorization")
            NetworkManager().deleteRequest(requestUrl: cartApi, requestBody: encodedRequest)
            DispatchQueue.main.async{
                print("delete successfull")
                self.carts.remove(at: ind)
                self.cart_tblView.showActivityIndicator()
                self.cart_tblView.reloadData()
                self.cart_tblView.hideActivityIndicator()
                var tot_price = 0
                for c in self.carts {
                    tot_price += c.bundlePrice
                }
                self.lbl_totalPrice.text = "₹"+String(Float(tot_price))
                Alert.DeletionSuccessAlert(on: self)
                if self.carts.isEmpty == true
                {
                    self.bg_view1.isHidden = false
                }
            }
            
        }
        catch let error {
            
            debugPrint("error = \(error.localizedDescription)")
        }
        
        
    }
    
}

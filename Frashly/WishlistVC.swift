//
//  WishlistVC.swift
//  Frashly
//
//

import UIKit

class WishlistVC: UIViewController {

    @IBOutlet weak var wish_tblView: UITableView!
    var productsList = [Products]()
    var pList = [Products]()
    
    @IBOutlet weak var bg_view: UIView!
    
    var ImageCacheData = NSCache<NSString,UIImage>()
    var token = UserDefaults.standard.value(forKey: "token") as? String
    
    override func viewWillAppear(_ animated: Bool) {
        
        if token == nil && counter ==  true{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyAccountVC") as? MyAccountVC
            hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc!, animated: true)
            hidesBottomBarWhenPushed = false
        }
        else if token != nil && wishlists.isEmpty == true && counter == true{
            bg_view.isHidden = false
        }
        else
        {
            bg_view.isHidden = true
            if counter == false{
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
            else{
                print(wishlists)
                        self.pList.removeAll()
                        for wish in wishlists{
                            for pro in self.productsList{
                                if wish == pro.pid
                                {
                                    self.pList.append(pro)
                                }
                            }
                        }
                        self.wish_tblView.reloadData()
                    }
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if counter == false{
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
        else{
            print(wishlists)
            self.wish_tblView.showActivityIndicator()
            NetworkManager().getApiData(requestUrl: URLRequest(url: URL(string: "https://warm-woodland-35878.herokuapp.com/products")!), resultType: [Products].self)
            { (products) in
                self.productsList = products
                DispatchQueue.main.async{
                    for wish in wishlists{
                        for pro in self.productsList{
                            if wish == pro.pid
                            {
                                self.pList.append(pro)
                            }
                        }
                    }
                    self.wish_tblView.reloadData()
                    self.wish_tblView.hideActivityIndicator()
                }
            }
        }
       
    }
    
    @IBAction func act_gotoCart(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CartVC") as? CartVC
        hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc!, animated: true)
        hidesBottomBarWhenPushed = false
    }
    
    

}
extension WishlistVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pList.count
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.wish_tblView.dequeueReusableCell(withIdentifier: "wish_cell", for: indexPath) as! WishlistTblCell
        cell.wish_name.text = pList[indexPath.row].name
        cell.wish_price.text = "₹"+String(pList[indexPath.row].price)
        let url = URL(string: pList[indexPath.row].img)
        cell.wish_img.downloadingImage(from: url!, imgCacheData: ImageCacheData, counter: pList[indexPath.row].name)
        cell.wish_delete.tag = indexPath.row
        cell.wish_delete.addTarget(self, action: #selector(addtoButton), for: .touchUpInside)
        return cell
    }
    @objc func addtoButton(sender:UIButton) {
        let indexpath1 = IndexPath(row: sender.tag, section: 0)
        print(pList[indexpath1.row].pid)
        let mydict = NetworkManager().decode(token!)
        let temp  = mydict?["user_id"]
        var wishApi = URLRequest(url: URL(string: "https://warm-woodland-35878.herokuapp.com/customers/\(temp!)/wishlist/\(pList[indexpath1.row].pid)")!)
        let request = WishListRequest(cid: temp as! String, pid: pList[indexpath1.row].pid)
        do {
            
            let encodedRequest = try JSONEncoder().encode(request)
            wishApi.setValue("Bearer "+token!, forHTTPHeaderField: "Authorization")
            NetworkManager().deleteRequest(requestUrl: wishApi, requestBody: encodedRequest)
            DispatchQueue.main.async{
                print("delete successfull")
                if let firstIndex = wishlists.index(of: self.pList[indexpath1.row].pid) {
                    wishlists.remove(at: firstIndex)
                    print (wishlists)
                }
                self.pList.removeAll()
                for wish in wishlists{
                    for pro in self.productsList{
                        if wish == pro.pid
                        {
                            self.pList.append(pro)
                        }
                    }
                }
                self.wish_tblView.showActivityIndicator()
                self.wish_tblView.reloadData()
                self.wish_tblView.hideActivityIndicator()
                Alert.DeletionSuccessAlert(on: self)
                if wishlists.isEmpty == true
                {
                  self.bg_view.isHidden = false
                }
            }

        }
        catch let error {
            
            debugPrint("error = \(error.localizedDescription)")
        }
       
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FeaturedProductDetailsVC") as? FeaturedProductDetailsVC
        hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc!, animated: true)
        hidesBottomBarWhenPushed = true
        vc?.name =  pList[indexPath.row].name
        vc?.price =  String(pList[indexPath.row].price)
        vc?.descript =  pList[indexPath.row].description
        vc?.image = pList[indexPath.row].img
        vc?.product_id = pList[indexPath.row].pid
    }
    
    
    
}



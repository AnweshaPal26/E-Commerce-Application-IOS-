//
//  MyOrdersVC.swift
//  Frashly
//
//

import UIKit

class MyOrdersVC: UIViewController {

    @IBOutlet weak var bg_view: UIView!
    
    @IBOutlet weak var myOrderTblView: UITableView!
    
    var orders = [Order]()
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
                var orderApi = URLRequest(url: URL(string: "https://warm-woodland-35878.herokuapp.com/orders/\(temp!)")!)
                orderApi.setValue("Bearer "+token!, forHTTPHeaderField: "Authorization")
                NetworkManager().getApiData(requestUrl: orderApi,  resultType: [Order].self)
                { (orders) in
                    self.orders = orders
                    DispatchQueue.main.async{
                        print(self.orders)
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
                            if self.orders.isEmpty == true
                            {
                                self.bg_view.isHidden = false
                            }
                            else{
                                self.myOrderTblView.showActivityIndicator()
                                self.myOrderTblView.reloadData()
                                self.myOrderTblView.hideActivityIndicator()
                                
                                
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
    
    

}

extension MyOrdersVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.myOrderTblView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! MyOrdersTblCell
        cell.lbl_orderDate.text = String(orders[indexPath.row].orderedAt [..<orders[indexPath.row].orderedAt .index(of: " ")!])
        cell.lbl_orderid.text = orders[indexPath.row].id
        cell.viewDetailsBtn.tag = indexPath.row
        cell.viewDetailsBtn.addTarget(self, action: #selector(addtoButton), for: .touchUpInside)
        return cell
    }
    @objc func addtoButton(sender:UIButton) {
        let indexpath1 = IndexPath(row: sender.tag, section: 0)
        let vc = storyboard?.instantiateViewController(withIdentifier: "MyOrderDetailsVC") as? MyOrderDetailsVC
        hidesBottomBarWhenPushed = true
        vc?.orderDate =  orders[indexpath1.row].orderedAt
        vc?.totPrice =  String(Float(orders[indexpath1.row].total))
        vc?.items = orders[indexpath1.row].items
        vc?.orderId = orders[indexpath1.row].id
        vc?.address = orders[indexpath1.row].deliveryAddress
        self.navigationController?.pushViewController(vc!, animated: true)
        hidesBottomBarWhenPushed = true
        
    }
    
}


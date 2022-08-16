//
//  NotificationVC.swift
//  Frashly
//
//

import UIKit

class NotificationVC: UIViewController {

    
    @IBOutlet weak var notificationTblView: UITableView!
    
    @IBOutlet weak var bg_view: UIView!
    
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
                                self.notificationTblView.showActivityIndicator()
                                self.notificationTblView.reloadData()
                                self.notificationTblView.hideActivityIndicator()


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
        

    @IBAction func act_gotoCart(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CartVC") as? CartVC
        hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc!, animated: true)
        hidesBottomBarWhenPushed = false
    }
    

}
extension NotificationVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.notificationTblView.dequeueReusableCell(withIdentifier: "notification_cell", for: indexPath) as! NotificationCell
        cell.lbl_time.text = orders[indexPath.row].orderedAt
        cell.lbl_orderid.text = orders[indexPath.row].id
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MyOrderDetailsVC") as? MyOrderDetailsVC
        vc?.orderDate =  orders[indexPath.row].orderedAt
        vc?.totPrice =  String(Float(orders[indexPath.row].total))
        vc?.items = orders[indexPath.row].items
        vc?.orderId = orders[indexPath.row].id
        vc?.address = orders[indexPath.row].deliveryAddress
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc!, animated: true)
        self.hidesBottomBarWhenPushed = false
        

    }


}

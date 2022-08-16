//
//  MyOrderDetailsVC.swift
//  Frashly
//
//

import UIKit

class MyOrderDetailsVC: UIViewController {
    
    @IBOutlet weak var lbl_orderid: UILabel!
    
    @IBOutlet weak var lbl_orderDate: UILabel!
    
    @IBOutlet weak var lbl_payment_mode: UILabel!
    
    @IBOutlet weak var lbl_address: UILabel!
    
    @IBOutlet weak var lbl_name: UILabel!
    
    @IBOutlet weak var lbl_deliverDate: UILabel!
    
    @IBOutlet weak var lbl_totPrice: UILabel!
    
    
    @IBOutlet weak var ordertblView: UITableView!
    
    var token = UserDefaults.standard.value(forKey: "token") as? String
    var customer:Customer!
     var orderDate = ""
    var totPrice = ""
    var orderId = ""
    var address = ""
    var items = [Item]()
    var products = [Products]()
    var orderItems = [OrderItems]()
     var ImageCacheData = NSCache<NSString,UIImage>()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let mydict = NetworkManager().decode(token!)
        let temp  = mydict?["user_id"]
        var custApi = URLRequest(url: URL(string: "https://warm-woodland-35878.herokuapp.com/customers/\(temp!)")!)
        custApi.setValue("Bearer "+token!, forHTTPHeaderField: "Authorization")
        NetworkManager().getApiData(requestUrl: custApi, resultType: Customer.self)
        { (customer) in
            self.customer = customer
            DispatchQueue.main.async{
                self.lbl_name.text = customer.name
                self.lbl_orderid.text = self.orderId
                self.lbl_payment_mode.text = "Cash On Delivery"
                self.lbl_address.text = self.address
                self.lbl_deliverDate.text = "23-09-2022"
                self.lbl_orderid.text = self.orderId
                self.lbl_totPrice.text = "₹"+self.totPrice
                self.lbl_orderDate.text =  String(self.orderDate[..<self.orderDate.index(of: " ")!])
                
            }
        }
        NetworkManager().getApiData(requestUrl: URLRequest(url: URL(string:"https://warm-woodland-35878.herokuapp.com/products")!), resultType: [Products].self)
        { (products) in
            self.products = products
            DispatchQueue.main.async{
                self.ordertblView.showActivityIndicator()
                for item in self.items{
                    for pro in self.products
                    {
                        if item.pid == pro.pid
                        {
                            let orderitem = OrderItems(name: pro.name, img: pro.img, qty: item.qty, price: item.price)
                            self.orderItems.append(orderitem)
                        }
                    }
                }
                
               self.ordertblView.reloadData()
                self.ordertblView.hideActivityIndicator()
            }
        }
        
        
    }
    
    @IBAction func act_back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
   
}
extension MyOrderDetailsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.ordertblView.dequeueReusableCell(withIdentifier: "order_cell", for: indexPath) as! OrdertblViewCell
        cell.lbl_name.text = orderItems[indexPath.row].name
        cell.lbl_price.text = "₹"+String(orderItems[indexPath.row].price)
        cell.lbl_qty.text = "Quantity: "+String(orderItems[indexPath.row].qty)
        let url = URL(string: orderItems[indexPath.row].img)
        cell.img_order.downloadingImage(from: url!, imgCacheData: ImageCacheData, counter: orderItems[indexPath.row].name)
        cell.img_order.contentMode = .scaleToFill
        cell.img_order.layer.cornerRadius = cell.frame.size.height/7.0
        cell.img_order.layer.borderWidth = 0.5
        cell.img_order.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
    
}




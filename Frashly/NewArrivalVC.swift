//
//  NewArrivalVC.swift
//  Frashly
//
//

import UIKit

class NewArrivalVC: UIViewController {
    
    var productsList = [Products]()
    
    var pList  = [Products]()
    
     var ImageCacheData = NSCache<NSString,UIImage>()
    
    

    @IBOutlet weak var newArrivalTblView: UITableView!
    
    @IBOutlet weak var lbl_totItem: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.newArrivalTblView.showActivityIndicator()
        
        
        NetworkManager().getApiData(requestUrl: URLRequest(url: URL(string: "https://warm-woodland-35878.herokuapp.com/products?type=new")!), resultType: [Products].self){ (products) in
           self.pList = products
            
            DispatchQueue.main.async{
                self.newArrivalTblView.reloadData()
                self.lbl_totItem.text = "\(self.pList.count) Items"
                self.newArrivalTblView.hideActivityIndicator()
            }
        }
    }
   
    @IBAction func act_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension NewArrivalVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.newArrivalTblView.dequeueReusableCell(withIdentifier: "newArrivalTblCell", for: indexPath) as! NewArrivalTblCell
        cell.lbl_newName.text = pList[indexPath.row].name
        cell.lbl_newPrice.text = "₹"+String(pList[indexPath.row].price)
        let url = URL(string: pList[indexPath.row].img)
        cell.img_new.downloadingImage(from: url!, imgCacheData: ImageCacheData, counter: pList[indexPath.row].name)
        cell.img_new.contentMode = .scaleToFill
        cell.img_new.layer.cornerRadius = cell.frame.size.height/7.0
        cell.img_new.layer.borderWidth = 0.5
        cell.img_new.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FeaturedProductDetailsVC") as? FeaturedProductDetailsVC
        vc?.name =  pList[indexPath.row].name
        hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc!, animated: true)
        hidesBottomBarWhenPushed = true
        vc?.descript = pList[indexPath.row].description
        vc?.price = String(pList[indexPath.row].price)
        vc?.image = pList[indexPath.row].img
        vc?.product_id = pList[indexPath.row].pid
    }
}


extension UITableView{
    func showActivityIndicator(){
        let activityView = UIActivityIndicatorView(style: .gray)
        self.backgroundView = activityView
        activityView.transform = CGAffineTransform(scaleX: 4, y: 4)
        activityView.startAnimating()
        isUserInteractionEnabled = false
    }
    func hideActivityIndicator() {
        self.backgroundView = nil
        isUserInteractionEnabled = true
    }
}

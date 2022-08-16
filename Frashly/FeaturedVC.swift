//
//  FeaturedVC.swift
//  Frashly
//

//

import UIKit

class FeaturedVC: UIViewController {
    
    var pList  = [Products]()
    var ImageCacheData = NSCache<NSString,UIImage>()
    
    @IBOutlet weak var featuredView: UITableView!
    
    @IBOutlet weak var lbl_totItem: UILabel!
    
    
 
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.featuredView.showActivityIndicator()
        
        NetworkManager().getApiData(requestUrl: URLRequest(url: URL(string: "https://warm-woodland-35878.herokuapp.com/products?type=featured")!), resultType: [Products].self){ (products) in
            self.pList = products
            DispatchQueue.main.async{
                self.featuredView.reloadData()
                self.lbl_totItem.text = "\(self.pList.count) Items"
                self.featuredView.hideActivityIndicator()
            }
        }
    }

    @IBAction func act_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
    
    
}

extension FeaturedVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return pList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.featuredView.dequeueReusableCell(withIdentifier: "featuredTblCell", for: indexPath) as! FeaturedTblCell
        cell.featured_lblName.text = pList[indexPath.row].name
        cell.featured_lblPrice.text = "₹"+String(pList[indexPath.row].price)
        let url = URL(string: pList[indexPath.row].img)
        cell.featured_img.downloadingImage(from: url!, imgCacheData: ImageCacheData, counter: pList[indexPath.row].name)
        cell.featured_img.contentMode = .scaleToFill
        cell.featured_img.layer.cornerRadius = cell.frame.size.height/7.0
        cell.featured_img.layer.borderWidth = 0.5
        cell.featured_img.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FeaturedProductDetailsVC") as? FeaturedProductDetailsVC
        vc?.name =  pList[indexPath.row].name
        vc?.descript = pList[indexPath.row].description
        vc?.price = String(pList[indexPath.row].price)
        vc?.image = pList[indexPath.row].img
        vc?.product_id = pList[indexPath.row].pid
        hidesBottomBarWhenPushed = true
       self.navigationController?.pushViewController(vc!, animated: true)
        hidesBottomBarWhenPushed = true
    }

    
}


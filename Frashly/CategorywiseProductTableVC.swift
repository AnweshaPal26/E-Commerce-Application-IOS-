//
//  CategorywiseProductTableVC.swift
//  Frashly
//
//

import UIKit

class CategorywiseProductTableVC: UIViewController {

    @IBOutlet weak var category_name: UILabel!
    @IBOutlet weak var tot_item: UILabel!
    @IBOutlet weak var categoryProductTblView: UITableView!
    var pList  = [Products]()
    var ImageCacheData = NSCache<NSString,UIImage>()
    
     var name_category = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        category_name.text = name_category
         self.categoryProductTblView.showActivityIndicator()
        let aString = "https://warm-woodland-35878.herokuapp.com/products?category=\(name_category)"
        let newString = aString.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        let newnewString = newString.replacingOccurrences(of: "&", with: "%26", options: .literal, range: nil)
        NetworkManager().getApiData(requestUrl: URLRequest(url: URL(string: newnewString)!), resultType: [Products].self){ (products) in
            self.pList = products
            DispatchQueue.main.async{
                self.categoryProductTblView.reloadData()
                self.tot_item.text = "\(self.pList.count) Items"
                self.categoryProductTblView.hideActivityIndicator()
            }
        }

       
    }
    
    @IBAction func act_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    

}
extension CategorywiseProductTableVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.categoryProductTblView.dequeueReusableCell(withIdentifier: "categoryWiswProductTblCell", for: indexPath) as! CategoryWiswProductTblCell
        cell.lbl_productName.text = pList[indexPath.row].name
        cell.lbl_productPrice.text = "₹"+String(pList[indexPath.row].price)
        let url = URL(string: pList[indexPath.row].img)
        cell.img_product.downloadingImage(from: url!, imgCacheData: ImageCacheData, counter: pList[indexPath.row].name)
        cell.img_product.contentMode = .scaleToFill
        cell.img_product.layer.cornerRadius = cell.frame.size.height/7.0
        cell.img_product.layer.borderWidth = 0.5
        cell.img_product.layer.borderColor = UIColor.lightGray.cgColor
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


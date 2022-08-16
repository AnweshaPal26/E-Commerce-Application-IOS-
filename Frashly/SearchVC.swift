//
//  SearchVC.swift
//  Frashly
//
//

import UIKit

class SearchVC: UIViewController {

     var pList = [Products]()
    
     var ImageCacheData = NSCache<NSString,UIImage>()
    
    
    @IBOutlet weak var search_tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }
    
    @IBAction func act_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension SearchVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.search_tblView.dequeueReusableCell(withIdentifier: "search_cell", for: indexPath) as! SearchTblCell
        cell.lbl_searchName.text = pList[indexPath.row].name
        cell.lbl_searchPrice.text = "₹"+String(pList[indexPath.row].price)
        let url = URL(string: pList[indexPath.row].img)
        cell.img_search.downloadingImage(from: url!, imgCacheData: ImageCacheData, counter: pList[indexPath.row].name)
        cell.img_search.contentMode = .scaleToFill
        cell.img_search.layer.cornerRadius = cell.frame.size.height/7.0
        cell.img_search.layer.borderWidth = 0.5
        cell.img_search.layer.borderColor = UIColor.lightGray.cgColor
        
        
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


//
//  CategoriesVC.swift
//  Frashly
//
//

import UIKit

class CategoriesVC: UIViewController {

    @IBOutlet weak var category_tblView: UITableView!
    
     var categoriesList = [Categories]()
    
    var ImageCacheData = NSCache<NSString,UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.category_tblView.showActivityIndicator()
        getData()
    }
    func getData(){
        NetworkManager().getApiData(requestUrl: URLRequest(url: URL(string: "https://warm-woodland-35878.herokuapp.com/categories")!), resultType: [Categories].self)
        { (categories) in
            self.categoriesList = categories
            DispatchQueue.main.async{
                self.category_tblView.reloadData()
                self.category_tblView.hideActivityIndicator()
            }
        }
    }
    

}
extension CategoriesVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.category_tblView.dequeueReusableCell(withIdentifier: "category_cell", for: indexPath) as! CategoryTableViewCell
        let url = URL(string: categoriesList[indexPath.row].img_url)
        cell.Category_img.downloadingImage(from: url!, imgCacheData: ImageCacheData, counter: categoriesList[indexPath.row].name)
        cell.Category_img.contentMode = .scaleToFill
        cell.category_lbl.text = categoriesList[indexPath.row].name
        cell.Category_img.layer.cornerRadius = cell.frame.size.height/7.0
        cell.Category_img.layer.borderWidth = 1.5
        cell.Category_img.layer.borderColor = UIColor.white.cgColor
        return cell
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CategorywiseProductTableVC") as? CategorywiseProductTableVC
        vc?.name_category =  categoriesList[indexPath.row].name
        hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc!, animated: true)
        hidesBottomBarWhenPushed = false
        
        
    }
    
}

//
//  HomeVC.swift
//  Frashly
//
//

import UIKit

var wishlists = [String]()
var counter = true


class HomeVC: UIViewController {
    
    var token = UserDefaults.standard.value(forKey: "token") as? String
    
    var categoriesList = [Categories]()
    var productsList = [Products]()
    var newPList  = [Products]()
    var fPList  = [Products]()
    
     var ImageCacheData = NSCache<NSString,UIImage>()
    

    var poster = ["poster2", "poster1"]
    var currentcellIndex = 0
    var timer: Timer?
    @IBOutlet weak var categoryCollectionVC: UICollectionView!
    
    @IBOutlet weak var posterCollectionView: UICollectionView!
    
    @IBOutlet weak var pgControl: UIPageControl!
    

    @IBOutlet weak var featuredCollectionView: UICollectionView!
    
    @IBOutlet weak var newArrivalCollectionView: UICollectionView!
    
    @IBOutlet weak var featuredCollBgViewConstHgt: NSLayoutConstraint!
    @IBOutlet weak var posterCollBgConsHgt: NSLayoutConstraint!
    
    @IBOutlet weak var txt_search: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        
        if token != nil{
            let mydict = NetworkManager().decode(token!)
            let temp  = mydict?["user_id"]
            var wishApi = URLRequest(url: URL(string: "https://warm-woodland-35878.herokuapp.com/customers/\(temp!)/wishlist")!)
            wishApi.addValue("application/json", forHTTPHeaderField: "Content-Type")
            wishApi.setValue("Bearer "+token!, forHTTPHeaderField: "Authorization")
            NetworkManager().getApiData(requestUrl: wishApi, resultType: [String].self)
            { (wishes) in
               wishlists = wishes
                DispatchQueue.main.async{
                    print(wishlists)
                }
            }

        }

        self.featuredCollectionView.showActivityIndicator()
        self.categoryCollectionVC.showActivityIndicator()
        self.newArrivalCollectionView.showActivityIndicator()
        
        NetworkManager().getApiData(requestUrl: URLRequest(url: URL(string: "https://warm-woodland-35878.herokuapp.com/categories")!), resultType: [Categories].self)
        { (categories) in
            self.categoriesList = categories
            DispatchQueue.main.async{
                self.categoryCollectionVC.reloadData()
                self.categoryCollectionVC.hideActivityIndicator()
            }
        }

        NetworkManager().getApiData(requestUrl: URLRequest(url: URL(string: "https://warm-woodland-35878.herokuapp.com/products?type=featured&limit=6")!), resultType: [Products].self){ (products) in
            self.fPList = products
            DispatchQueue.main.async{
                self.featuredCollectionView.reloadData()
                self.featuredCollectionView.hideActivityIndicator()
            }
        }
        
        NetworkManager().getApiData(requestUrl: URLRequest(url: URL(string: "https://warm-woodland-35878.herokuapp.com/products?type=new&limit=6")!), resultType: [Products].self){ (products) in
            self.newPList = products
            DispatchQueue.main.async{
                self.newArrivalCollectionView.reloadData()
                self.newArrivalCollectionView.hideActivityIndicator()
            }
        }

        
        
        let imageIcon = UIImageView()
        imageIcon.image = UIImage(named: "search")
        
        let content = UIView()
        content.addSubview(imageIcon)
        
        content.frame = CGRect(x: 0, y: 0, width: UIImage(named: "search")!.size.width, height: UIImage(named: "search")!.size.height)
        imageIcon.frame = CGRect(x: 5, y: 0, width: UIImage(named: "search")!.size.width, height: UIImage(named: "search")!.size.height)
        
        txt_search.leftView = content
        txt_search.leftViewMode = .always
        txt_search.clearButtonMode = .whileEditing
        
        let bounds = UIScreen.main.bounds
        let size: Float
        if bounds.size.width < 375{
          size = Float((bounds.size.width-10)/3) + 55.0
        }
        else if bounds.size.width >= 375 && bounds.size.width < 414
        {
            size =  Float((bounds.size.width-10)/3) + 30.0
        }
        else if bounds.size.width >= 414 && bounds.size.width < 500{
            size = Float((bounds.size.width-10)/3) + 17.0
        }
        else if bounds.size.width >= 500 && bounds.size.width <= 786{
            
            size = Float((bounds.size.width-10)/3) - 95.0
        }
        else if bounds.size.width > 768 && bounds.size.width <= 834{
            size = Float((bounds.size.width-10)/3) - 120.0
        }
        else{
           size = Float((bounds.size.width-10)/3) - 175.0
        }

        let rowNo: Float = Float(6 / 3)
        featuredCollBgViewConstHgt.constant = CGFloat(rowNo * size)

        
        
        

        
        if bounds.size.height <= 926.0
        {
            posterCollBgConsHgt.constant = 160
        }
        else if bounds.size.height > 926 && bounds.size.height <= 1024{
           posterCollBgConsHgt.constant = 285
        }
        else{
            posterCollBgConsHgt.constant = 380
        }
              
        
        categoryCollectionVC.reloadData()
        posterCollectionView.reloadData()
        featuredCollectionView.reloadData()
        newArrivalCollectionView.reloadData()
        
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.slideToNext), userInfo: nil, repeats: true)
        }
        
    }
   
   
    
    
    @IBAction func act_featuredPage(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FeaturedVC") as? FeaturedVC
        hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc!, animated: true)
        hidesBottomBarWhenPushed = false
        
    }
    
    @IBAction func act_newArrivalPage(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewArrivalVC") as? NewArrivalVC
        hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc!, animated: true)
        hidesBottomBarWhenPushed = false
    }
    
    @IBAction func act_gotoCart(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CartVC") as? CartVC
        hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc!, animated: true)
        hidesBottomBarWhenPushed = false
        
    }
    @objc func slideToNext(){
       if currentcellIndex < poster.count-1
       {
        let index = IndexPath.init(item: currentcellIndex, section: 0)
        self.posterCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        pgControl.currentPage = currentcellIndex
            currentcellIndex = currentcellIndex+1
        }
       else{
        let index = IndexPath.init(item: currentcellIndex, section: 0)
        self.posterCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
        pgControl.currentPage = currentcellIndex
        currentcellIndex = 0
        }        

    }
    
    
    
}
extension UIImageView{
    func downloadingImage(from url : URL, imgCacheData:NSCache<NSString,UIImage>, counter:String)  {
        image = UIImage(named: "default")
        if let savedImage = imgCacheData.object(forKey: NSString(string: counter))
        {
            DispatchQueue.main.async {
                self.image = savedImage
            }
        }
        else{
            contentMode = .scaleToFill
            let dataTask = URLSession.shared.dataTask(with: url,  completionHandler: {
                (data, response, error) in
                guard let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let  data = data, error == nil,
                    let image = UIImage(data: data)
                    else{
                        return
                }
                DispatchQueue.main.async {
                    self.image = image
                    imgCacheData.setObject(image, forKey: NSString(string: counter))
                }
                
            })
            dataTask.resume()
        }
    }
}


extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfRows:Int = 0
        switch collectionView {
        case categoryCollectionVC:
            numberOfRows = categoriesList.count
        case posterCollectionView:
            numberOfRows = poster.count
        case featuredCollectionView:
            numberOfRows = fPList.count
        case newArrivalCollectionView:
            numberOfRows = newPList.count
        default:
            print("invalid selection")
        }
        return numberOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        switch collectionView {
        case categoryCollectionVC:
            let cell1 = categoryCollectionVC.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! CategoryHorizonCollectionVC
            let url = URL(string: categoriesList[indexPath.row].img_url)
            cell1.img_category.downloadingImage(from: url!, imgCacheData: ImageCacheData, counter: categoriesList[indexPath.row].name)
            cell1.img_category.contentMode = .scaleToFill
            cell1.img_category.layer.cornerRadius = cell1.frame.size.height/4.0
            cell1.img_category.layer.borderWidth = 1.5
            cell1.img_category.layer.borderColor = UIColor.white.cgColor
            cell1.lbl_category.text = categoriesList[indexPath.row].name
            cell = cell1
        case posterCollectionView:
            let cell2 = posterCollectionView.dequeueReusableCell(withReuseIdentifier: "poster_cell", for: indexPath) as! PosterCollectionViewCell
            cell2.poster_img.image = UIImage(named: poster[indexPath.row])
            cell = cell2
        case featuredCollectionView:
            let cell3 = featuredCollectionView.dequeueReusableCell(withReuseIdentifier: "featuredcell", for: indexPath) as! FeaturedCollectionCell
            let url = URL(string: fPList[indexPath.row].img)
            cell3.img_featuredcell.downloadingImage(from: url!, imgCacheData: ImageCacheData, counter: fPList[indexPath.row].name)
            cell3.img_featuredcell.contentMode = .scaleToFill
            cell3.img_featuredcell.layer.cornerRadius = cell3.frame.size.height/9.0
            cell3.img_featuredcell.layer.borderWidth = 1.5
            cell3.img_featuredcell.layer.borderColor = UIColor.white.cgColor
            cell3.lbl_featuredcellName.text = fPList[indexPath.row].name
            cell3.lbl_featuredcellPrice.text = "₹"+String(fPList[indexPath.row].price)
            cell = cell3
        
        case newArrivalCollectionView:
            let cell4 = newArrivalCollectionView.dequeueReusableCell(withReuseIdentifier: "newArrival_cell", for: indexPath) as! NewArrivalCollectionCell
            let url = URL(string: newPList[indexPath.row].img)
            cell4.img_newArrival.downloadingImage(from: url!, imgCacheData: ImageCacheData, counter: newPList[indexPath.row].name)
            cell4.img_newArrival.contentMode = .scaleToFill
            cell4.img_newArrival.layer.cornerRadius = cell4.frame.size.height/8.0
            cell4.img_newArrival.layer.borderWidth = 1.5
            cell4.img_newArrival.layer.borderColor = UIColor.white.cgColor
            cell4.layer.cornerRadius = 10
            cell4.layer.borderWidth = 1
            cell4.layer.borderColor = UIColor.white.cgColor
            cell4.lbl_newArrivalName.text = newPList[indexPath.row].name
            cell4.lbl_newArrivalPrice.text = "₹"+String(newPList[indexPath.row].price)
            cell = cell4
        default:
            print("wrong selection")
        }
        
        return cell
        
        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case categoryCollectionVC:
            let vc = storyboard?.instantiateViewController(withIdentifier: "CategorywiseProductTableVC") as? CategorywiseProductTableVC
            vc?.name_category =  categoriesList[indexPath.row].name
            hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc!, animated: true)
            hidesBottomBarWhenPushed = false
        case posterCollectionView:
            print("wrong selection")
            
        case featuredCollectionView:
            let vc = storyboard?.instantiateViewController(withIdentifier: "FeaturedProductDetailsVC") as? FeaturedProductDetailsVC
            vc?.name =  fPList[indexPath.row].name
            vc?.descript = fPList[indexPath.row].description
            vc?.price = String(fPList[indexPath.row].price)
            vc?.image = fPList[indexPath.row].img
            vc?.product_id = fPList[indexPath.row].pid
            hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc!, animated: true)
            hidesBottomBarWhenPushed = false
            
        case newArrivalCollectionView:
            let vc = storyboard?.instantiateViewController(withIdentifier: "FeaturedProductDetailsVC") as? FeaturedProductDetailsVC
            vc?.name =  newPList[indexPath.row].name
            vc?.descript = newPList[indexPath.row].description
            vc?.price = String(newPList[indexPath.row].price)
            vc?.image = newPList[indexPath.row].img
            vc?.product_id = newPList[indexPath.row].pid
            hidesBottomBarWhenPushed = true
//            print(self)
            self.navigationController?.pushViewController(vc!, animated: true)
            hidesBottomBarWhenPushed = false
           
        default:
            print("wrong selection")
        }
        
        
      
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var rsize = CGSize()
        switch collectionView {
        case categoryCollectionVC:
            let csize:CGSize
            let bounds = UIScreen.main.bounds
            let size = (collectionView.frame.size.width-10)/4
            if bounds.size.width < 375{
                
                csize = CGSize(width: size+13, height: size+30)
            }
            else if bounds.size.width >= 375 && bounds.size.width < 414
            {
                
                csize = CGSize(width: size+5, height: size+20)
            }
            else if bounds.size.width >= 414 && bounds.size.width < 500
            {
                
                csize = CGSize(width: size+5, height: size+10)
            }
            else if bounds.size.width >= 500 && bounds.size.width <= 786{
                
                csize = CGSize(width: size-35, height: size-70)
            }
            else if bounds.size.width > 768 && bounds.size.width <= 834{
                csize = CGSize(width: size-55, height: size-95)
            }
            else{
                
                csize = CGSize(width: size-70, height: size-140)
            }
            rsize = csize
        case posterCollectionView:
                let csize:CGSize
                let size = collectionView.frame.size
                csize = CGSize(width: size.width, height: size.height)
                rsize = csize
        case featuredCollectionView:
            let csize:CGSize
            let bounds = UIScreen.main.bounds
            let size = (collectionView.frame.size.width-30)/3
//            csize = CGSize(width: size, height: size+55)
            if bounds.size.width < 375{
                
                csize = CGSize(width: size, height: size+55)
            }
            else if bounds.size.width >= 375 && bounds.size.width < 414
            {
                csize = CGSize(width: size, height: size+25)
            }
            else if bounds.size.width >= 414 && bounds.size.width < 500{
               
                csize = CGSize(width: size, height: size+20)
            }
            else if bounds.size.width >= 500 && bounds.size.width <= 786{
                
                csize = CGSize(width: size, height: size-100)
            }
            else if bounds.size.width > 768 && bounds.size.width <= 834{
                csize = CGSize(width: size, height: size-120)
            }
            else{
                csize = CGSize(width: size, height: size-175)
            }
            rsize = csize

        case newArrivalCollectionView:
            let csize:CGSize
            let bounds = UIScreen.main.bounds
            let size = (collectionView.frame.size.width-10)/2
            if bounds.size.width < 375{
                csize = CGSize(width: size-5, height: size+50)
            }
            else if bounds.size.width >= 375 && bounds.size.width < 414
            {
                csize = CGSize(width: size-5, height: size+25)
            }
            else if bounds.size.width >= 414 && bounds.size.width < 500{
                
                csize = CGSize(width: size-5, height: size)
            }
            else if bounds.size.width >= 500 && bounds.size.width <= 768{
                
                csize = CGSize(width: size-100, height: size-150)
            }
            else if bounds.size.width > 768 && bounds.size.width <= 834{
                
                csize = CGSize(width: size-150, height: size-175)
            }
            else{
                csize = CGSize(width: size-200, height: size-300)
            }
            rsize = csize

        default:
            print("wrong selection")
        }

        return rsize

    }

    
}
extension HomeVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txt_search.resignFirstResponder()
        let name = txt_search.text!
         let searchingUrl = "https://warm-woodland-35878.herokuapp.com/products?q=\(name)"
        NetworkManager().getApiData(requestUrl: URLRequest(url: URL(string: searchingUrl)!), resultType: [Products].self){ (products) in
            self.productsList = products
            DispatchQueue.main.async{
                if self.productsList.count == 0{
                    Alert.showSearchNotFoundAlert(on: self)
                }
                else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as? SearchVC
                    self.hidesBottomBarWhenPushed = true
                    vc?.pList = self.productsList
                    self.navigationController?.pushViewController(vc!, animated: true)
                    self.hidesBottomBarWhenPushed = true
                }
            }
        }
        return true
    }
    
        
}

extension UICollectionView{
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




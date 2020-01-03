//
//  RestaurantDetailViewController.swift
//  DatabaseSystemProject
//
//  Created by 吳尚霖 on 12/18/19.
//  Copyright © 2019 吳尚霖. All rights reserved.
//

import UIKit
import Toast
import Cosmos
import RealmSwift

class RestaurantDetailViewController : UIViewController , UITableViewDelegate , UITableViewDataSource{
    let realm = try! Realm()
    
    @IBOutlet var ratingView: UIView!
    @IBOutlet var ratingNum: UILabel!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var detailPhoto: UIImageView!
    @IBOutlet var detailPhone: UILabel!
    @IBOutlet var reviewTable: UITableView!
    @IBOutlet var favoriteBtn: UIImageView!
    @IBOutlet var loadingImage: UIImageView!
    @IBOutlet var detailRestaurantTitle: UILabel!
    @IBOutlet var detailRestaurantAddress: UILabel!
    @IBOutlet var backgroundImageView: UIImageView!
   
    var modeFromWhere = Int() //0:contentViewController 1:saveRestaurant
    var realmRes = restaurant_Content()
    var photoData = Data()
    var favoriteArr: [restaurant_LoveAddress] = []
    
    var resDetail = restaurant_Content()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        parameterInit()
        navigationBarInit()
        favoriteBtnInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(dataManagerNotification),
                                               name: Notification.Name(rawValue: "dataManager"), object: nil)
        
            reviewTable.register(UINib.init(nibName: "reviewTableViewCell", bundle: nil), forCellReuseIdentifier: "reviewTableViewCell")
        reviewTable.layer.cornerRadius = 15.0

        
        let data = realm.objects(restaurant_Content.self)
            .filter("placeID == %@",resDetail.placeID ?? "")
        favoriteBtn.isHighlighted = (data.count>0)
        print(resDetail)
        print(resDetail.copy())
        setImage()
        setDetailData()
        ratingStar(rating: resDetail.rating)
        reviewTable.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init("dataManager"), object: nil)
    }
    
    //MARK: - viewDidLoad()
    fileprivate func parameterInit() {
        backgroundView.layer.cornerRadius = 35.0
        loadingImage.layer.cornerRadius = loadingImage.bounds.width/2
        loadingImage.layer.masksToBounds = true
        
        detailPhoto.layer.masksToBounds = true
        detailPhoto.layer.cornerRadius = detailPhoto.bounds.width/2
        detailPhoto.layer.borderWidth = 2.0
        detailPhoto.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    fileprivate func navigationBarInit() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    fileprivate func favoriteBtnInit() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(favoriteBtnClick(tap:)))
        favoriteBtn.isUserInteractionEnabled = true
        favoriteBtn.addGestureRecognizer(tap)
        
        favoriteBtn.layer.cornerRadius = 10
        favoriteBtn.layer.masksToBounds = true
    }
    
    @objc fileprivate func favoriteBtnClick(tap:UITapGestureRecognizer) {
        favoriteBtn.isHighlighted = !favoriteBtn.isHighlighted
        
        if(favoriteBtn.isHighlighted){
            doGetRestaurantList(type: 4)
            try! realm.write {
                realm.add(resDetail.copy() as! Object)
            }
            self.view.makeToast("加入收藏成功")
        }
        else{
            let data = realm.objects(restaurant_Content.self).filter("placeID == %@",resDetail.placeID ?? "")
            doGetRestaurantList(type: 3)
            try! realm.write {
                realm.delete(data)
            }
            self.view.makeToast("取消收藏成功")
        }
    }
    
    @objc fileprivate func dataManagerNotification(notification:Notification) {
        let methodResponse = notification.object as! MethodResponse
        DispatchQueue.main.async {
            if(methodResponse.methodName == "getRestaurantList"){
                self.handleGetRestaurantList(res: methodResponse.object as! getRestaurantListRes)
            }
            else if(methodResponse.methodName == "getRestaurantListAdd/DelFavorite"){
                self.handleGetRestaurantAddFavorite(res: methodResponse.object as! getRestaurantListRes)
            }
        }
    }
    
    //MARK: - viewWillAppear()
    fileprivate func setImage(){
        let data = realm.objects(restaurant_Content.self).filter("placeID LIKE '\(resDetail.placeID!)'")
        let resPhoto = (modeFromWhere == 0) ? resDetail.photo : data.first?.photo
        DispatchQueue.global().async {
            if let url = URL(string: resPhoto!){
                DispatchQueue.main.async {
                    self.detailPhoto.sd_setImage(with: url, placeholderImage: UIImage(named: "loadingImage") )
                    self.backgroundImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "loadingImage") )
                }
            }
        }
    }
    
    fileprivate func setDetailData() {
        ratingNum.text = "\(resDetail.rating)"
        detailRestaurantTitle.text = resDetail.name
        detailRestaurantAddress.text = resDetail.vicinity
        detailPhone.text = resDetail.phone
    }
    
    func ratingStar(rating:Double){
        let view = CosmosView()
        view.settings.updateOnTouch = false
        view.settings.emptyColor = UIColor.lightGray
        view.settings.emptyBorderColor = UIColor.lightGray
        view.settings.fillMode = .half
        view.settings.filledImage = UIImage(named: "starIcon")
        view.settings.emptyImage = UIImage(named: "emptyStarIcon")
        view.settings.starMargin = 2
        view.rating = rating
        ratingView.addSubview(view)
    }
    
    //MARK: - Api function
    fileprivate func doGetRestaurantList(type:Int){
        
        let req = getRestaurantListReq(accountID: UIDevice.current.identifierForVendor!.uuidString,
                                       type: type,
                                       lat: resDetail.lat,
                                       lng: resDetail.lng,
                                       address: resDetail.vicinity!,
                                       placeID: resDetail.placeID!)
        
        let dataManager = DataManager()
        dataManager.getRestaurantList(req: req)
        
    }
    
    fileprivate func handleGetRestaurantList(res:getRestaurantListRes){
        if(res.status == 0 && res.results.loveList.count>0){
            for i in 0...(res.results.loveList.count)-1 {
                if(res.results.loveList[i].placeID == resDetail.placeID){
                    favoriteBtn.isHighlighted = true
                    break;
                }
                else{
                    favoriteBtn.isHighlighted = false
                }
            }
        }
    }
    
    fileprivate func handleGetRestaurantAddFavorite(res:getRestaurantListRes){
        if(res.status != 0){
            self.view.makeToast("您剛剛加入/刪除收藏的餐廳出現了問題，請稍後再試。")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.862745098, blue: 0.7921568627, alpha: 1)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 0
        }
        return 15
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = (resDetail.reviews.count>0) ? resDetail.reviews.count : 1
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewTableViewCell", for: indexPath) as! reviewTableViewCell
        
        cell.userName.text = nil
        cell.userReview.text = nil
        cell.profilePhoto.image = nil
        cell.profilePhoto.layer.masksToBounds = true
        
        if(resDetail.reviews.count>0){
            cell.setCell(res: resDetail.reviews[indexPath.section])
        }
        return cell
    }
    
}



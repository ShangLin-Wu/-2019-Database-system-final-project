//
//  saveRestaurantTableViewController.swift
//  DatabaseSystemProject
//
//  Created by 吳尚霖 on 12/22/19.
//  Copyright © 2019 吳尚霖. All rights reserved.
//

import UIKit
import Cosmos
import RealmSwift

fileprivate var realmRes = [restaurant_Content]()
fileprivate let realm = try! Realm()

class saveRestaurantTableViewController: UITableViewController {
    
    @IBOutlet var resTableView: UITableView!
    var loveList = [restaurant_LoveAddress]()
    var noData = false
    
    override func viewDidLoad() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(dataManagerNotification),
                                   name: NSNotification.Name(rawValue: "dataManager"), object: nil)
        realmRes.removeAll()
        let data = realm.objects(restaurant_Content.self)
        if (data.count>0){
            for i in 0...data.count - 1{
                realmRes.append(data[i].copy() as! restaurant_Content)
            }
        }
        print(realmRes)
        resTableView.reloadData()
        self.title = "已收藏\(realmRes.count)間餐廳"
    }
    
 //MARK: - Receive Notification
    @objc func dataManagerNotification(notification:Notification){
        let methodResponse = notification.object as! MethodResponse
        if(methodResponse.methodName == "getRestaurantList"){
            DispatchQueue.main.async{
                self.handleGetRestaurantList(res: methodResponse.object as! getRestaurantListRes)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(realmRes.count>0){
            return realmRes.count
        }else{
            noData = true
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "saveRestaurantTableViewCell",for: indexPath) as! saveRestaurantTableViewCell
        
        cell.cellPhoto.layer.cornerRadius = 3.0
        cell.cellPhoto.image = nil
        cell.cellTitleLabel.text = nil
        cell.cellPlace.text = nil
        
        if(realmRes.count>0){
            cell.setCell(resDetail:[realmRes[indexPath.row]], indexPath: indexPath)
        }else if (noData == true){
            cell.cellPlace.text = nil
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = mainStoryboard.instantiateViewController(
            withIdentifier: "RestaurantDetailViewController") as? RestaurantDetailViewController {
            vc.resDetail = realmRes[indexPath.row]
            vc.modeFromWhere = 1
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - Api function
    func doGetRestaurantList(){
        
        let req = getRestaurantListReq(accountID: UIDevice.current.identifierForVendor!.uuidString,
                                       type: 0,
                                       lat: 0.0,
                                       lng: 0.0,
                                       address: "",
                                       placeID: "")
        
        let dataManager = DataManager()
        dataManager.getRestaurantList(req: req)
        
    }
    
    fileprivate func handleGetRestaurantList(res:getRestaurantListRes){
        if(res.status == 0){
            if(res.results.loveList.count>0){
                loveList = res.results.loveList
                resTableView.reloadData()
            }
        }
    }
}

class saveRestaurantTableViewCell : UITableViewCell{
    @IBOutlet var cellRestaurantCount: UILabel!
    @IBOutlet var cellCommentNum: UILabel!
    @IBOutlet var cellRatingView: UIView!
    @IBOutlet var cellPhoto: UIImageView!
    @IBOutlet var cellTitleLabel: UILabel!
    @IBOutlet var cellPlace: UILabel!
    
    func setCell (resDetail : [restaurant_Content] , indexPath : IndexPath){
        var name = ""
        var vicinity = ""
        var photo = ""
        var rating = 0.0
        var comments = 0
        try! realm.write {
            name = realmRes[indexPath.row].name!
            vicinity = realmRes[indexPath.row].vicinity!
            photo = realmRes[indexPath.row].photo!
             rating = realmRes[indexPath.row].rating
             comments = realmRes[indexPath.row].reviewsNumber
        }
        ratingStar(rating: rating)
        self.cellRestaurantCount.text = "\(indexPath.row+1)/\(realmRes.count)"
        self.cellPlace.text = vicinity
        self.cellTitleLabel.text = name
        self.cellCommentNum.text = "( \(comments)則評論 )"
        
        DispatchQueue.global().async { 
            if let url = URL(string: photo){
                DispatchQueue.main.async {
                    self.cellPhoto.sd_setImage(with: url, placeholderImage: nil)
                }
            }
        }
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
          cellRatingView.addSubview(view)
      }
}



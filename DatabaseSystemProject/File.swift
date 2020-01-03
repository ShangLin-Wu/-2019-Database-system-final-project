////
////  ViewController.swift
////  DatabaseSystemProject
////
////  Created by 吳尚霖 on 11/28/19.
////  Copyright © 2019 吳尚霖. All rights reserved.
////
//
//import UIKit
//import CoreLocation
//import MapKit
//
//
//class ViewController: UIViewController , CLLocationManagerDelegate{
//    
//    var resA = [[restaurant_Content](),[restaurant_Content](),[restaurant_Content](),[restaurant_Content]()]
//    @IBOutlet var mapView: MKMapView!
//    @IBOutlet var collectionView : UICollectionView!
//    
//    var location : CLLocationManager!
//    var res:getRestaurantRes?
//    var resTag = false
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        mapInit()
//        locationManagerInit()
//        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        
//    }
//    
//    fileprivate func mapInit() {
//        mapView.delegate = self as? MKMapViewDelegate
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let coordinate = locations.last else {
//            return
//        }
//        if( resTag == false){
//            resTag = true
//            doGetRasturant(location: coordinate)
//        }
//    }
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        NotificationCenter.default.addObserver(self, selector: #selector(dataManagerNotification),
//                                               name: NSNotification.Name(rawValue: "dataManager"), object: nil)
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init("dataManager"), object: nil)
//    }
//    override func viewDidDisappear(_ animated: Bool) {
//        location?.stopUpdatingLocation()
//    }
//    
//    fileprivate func locationManagerInit() {
//        location = CLLocationManager()
//        location.delegate = self
//        location.desiredAccuracy = kCLLocationAccuracyBest
//        location.requestWhenInUseAuthorization()
//        location.requestLocation()
//        location.startUpdatingLocation()
//        
//    }
//    
//    @objc func dataManagerNotification(notification:Notification){
//        let methodResponse = notification.object as! MethodResponse
//        
//        if(methodResponse.methodName == "getRestaurant"){
//            DispatchQueue.main.async{
//                self.handleGetRestaurant(res: methodResponse.object as! getRestaurantRes)
//            }
//        }
//    }
//    
//    
//    //lat: 25.0422329,
//    //lng: 121.5354974,
//    func doGetRasturant(location:CLLocation){
//        let dataManager = DataManager()
//        let req = getRestaurantReq(accountID: "Null",
//                                   lastIndex: -1,
//                                   count: 15,
//                                   type: [1,2,3,7],
//                                   lat: location.coordinate.latitude,
//                                   lng: location.coordinate.longitude,
//                                   range: "1000",
//                                   money: 0,
//                                   label: "")
//        
//        dataManager.getRestaurant(req: req)
//    }
//    
//    func handleGetRestaurant(res:getRestaurantRes){
//        if(res.status == 0){
//            
//            self.res = res
//            
//            
//            for (i, content) in res.results.content.enumerated(){
//                let index = i / 15
//                resA[index].append(content)
//            }
//            self.collectionView.reloadData()
//            
//        }
//    }
//}
//
//extension ViewController : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 7
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = Int((collectionView.bounds.size.width-60-32)/3)
//        let height = Int(CGFloat(width)*1.5)
//        return CGSize(width: width, height: height)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: "CountyCollectionViewCell",
//            for: indexPath) as! CountyCollectionViewCell
//        
//        cell.featuredImageView.image = nil
//        cell.restaurantTitleLabel.text = nil
//        
//        cell.backgroundColorView.layer.cornerRadius = 15.0
//        cell.backgroundColorView.layer.masksToBounds = true
//        cell.featuredImageView.layer.cornerRadius = 15.0
//        if( res != nil && !(resA.isEmpty) ){
//            let index = (indexPath.section == 0) ? indexPath.section+3 : indexPath.row-1
//            cell.setCell(resA: resA[index][0], indexPath: indexPath)
//        }
//        
//        return cell
//    }
//    
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
//        
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        if let vc = mainStoryboard.instantiateViewController(
//            withIdentifier: "ContentViewController") as? ContentViewController
//        {
//            let row = indexPath.row
//            if(row == 0){
//                vc.resContent = resA[3]
//                vc.selectSection = 3
//            }else{
//                vc.resContent = resA[section-1]
//                vc.selectSection = section - 1
//            }
//            navigationController?.pushViewController(vc, animated: true)
//        }
//        
//    }
//}
//
//
//
//class CountyCollectionViewCell:UICollectionViewCell{
//    @IBOutlet var restaurantTitleLabel: UILabel!
//    @IBOutlet var featuredImageView: UIImageView!
//    @IBOutlet var backgroundColorView: UIView!
//    
//    
//    func setCell(resA:restaurant_Content, indexPath:IndexPath) -> Void {
//        var photoString:String
//        
//        
//        photoString = resA.photo!
//        
//        switch indexPath.section {
//        case 0:
//            self.restaurantTitleLabel.text = "附近美食"
//            break;
//        case 1:
//            self.restaurantTitleLabel.text = "北北基美食"
//            break;
//        case 2:
//            self.restaurantTitleLabel.text = "桃竹苗美食"
//            break;
//        case 3:
//            self.restaurantTitleLabel.text = "中彰投美食"
//            break;
//        default:
//            photoString = ""
//            self.restaurantTitleLabel.text = ""
//            break;
//        }
//        
//        DispatchQueue.global().async { [weak self] in
//            if let url = URL(string: photoString){
//                if let data = try? Data(contentsOf: url){
//                    DispatchQueue.main.async{
//                        self?.featuredImageView.image = UIImage(data: data)
//                    }
//                }
//            }
//        }
//    }
//}

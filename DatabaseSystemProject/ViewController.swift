//
//  ViewController.swift
//  DatabaseSystemProject
//
//  Created by 吳尚霖 on 11/28/19.
//  Copyright © 2019 吳尚霖. All rights reserved.
//

import UIKit
import MapKit
import Cosmos
import SDWebImage
import RealmSwift
import CoreLocation

fileprivate let restaurantTitleArr = ["附近\n美食", "北北基", "桃竹苗", "中彰投",
                                      "雲嘉南", "高高屏", "宜花東", "我的\n收藏"]
class ViewController: UIViewController , CLLocationManagerDelegate{
    
    var resA = [[restaurant_Content](),[restaurant_Content](),[restaurant_Content](),[restaurant_Content](),[restaurant_Content](),[restaurant_Content](),[restaurant_Content]()]

    var index = 0
    var resTag = false
    let realm = try! Realm()
    var res:getRestaurantRes?
    var location : CLLocationManager!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var myCollectionView : UICollectionView!
    @IBOutlet weak var northCollectionView : UICollectionView!
    
    @IBOutlet var loadingView: UIView!
    
    @IBAction func btnclick(_ sender: Any) {
        mapView.isHidden = !mapView.isHidden
        myCollectionView.isHidden = !myCollectionView.isHidden
        northCollectionView.isHidden = !northCollectionView.isHidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(realm.configuration.fileURL?.deletingLastPathComponent().path)
        print(UIDevice.current.identifierForVendor?.uuidString)
        mapInit()
        locationManagerInit()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        UIView.animate(withDuration: 3, delay: 1, options: .curveEaseOut, animations: {
                  self.loadingView.alpha = 0.0
              }, completion: nil)
        
    }
    
    fileprivate func mapInit() {
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "pin")
        mapView.delegate = self
    }
    
    fileprivate func locationManagerInit() {
        location = CLLocationManager()
        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyBest
        location.requestWhenInUseAuthorization()
        location.requestLocation()
        location.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last else {
            return
        }
        if( resTag == false){
            resTag = true
            doGetRasturant(location: coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(dataManagerNotification),
                                               name: NSNotification.Name(rawValue: "dataManager"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init("dataManager"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        location?.stopUpdatingLocation()
    }
    
    //MARK: - Receive Notification
    @objc func dataManagerNotification(notification:Notification){
        let methodResponse = notification.object as! MethodResponse
        if(methodResponse.methodName == "getRestaurant"){
            DispatchQueue.main.async{
                self.handleGetRestaurant(res: methodResponse.object as! getRestaurantRes)
            }
        }
    }
    
    //MARK: - Api
    func doGetRasturant(location:CLLocation){
        let dataManager = DataManager()
        let req = getRestaurantReq(accountID: UIDevice.current.identifierForVendor!.uuidString,
                                   lastIndex: -1,
                                   count: 15,
                                   type: [1,2,3,4,5,6,7],
                                   lat: location.coordinate.latitude,
                                   lng: location.coordinate.longitude,
                                   range: "1000",
                                   money: 0,
                                   label: "")
        
        dataManager.getRestaurant(req: req)
    }
    
    func handleGetRestaurant(res:getRestaurantRes){
        if(res.status == 0){
            
            self.res = res
            
            for (i, content) in res.results.content.enumerated(){
                let index = i / 15
                resA[index].append(content)
               
                let coordinate = CLLocationCoordinate2DMake((res.results.content[i].lat), (res.results.content[i].lng))
                let ann = customAnnotation(title: res.results.content[i].name, subtitle: res.results.content[i].photo, coordinate: coordinate, res: res.results.content[i])
                
                self.mapView.addAnnotation(ann)
            }
            self.myCollectionView.reloadData()
            self.northCollectionView.reloadData()
            self.mapView.showAnnotations(mapView.annotations, animated: true) //for call viewForAnnotation
        }
    }
}

//MARK: - Extension MKMapViewDelegate
extension ViewController : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation { return nil }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
        
        DispatchQueue.global().async{
            if let url = URL(string: annotation.subtitle!!){
                if let data = try? Data(contentsOf: url){
                    let imgResult = self.resizeImage(image: UIImage(data: data)!, targetSize: CGSize(width: 40, height: 40))
                    DispatchQueue.main.async {
                        
                        annotationView?.image = imgResult
                    }
                }
            }
        }
        
        annotationView?.frame.size = CGSize(width: 40, height: 40)
        annotationView?.layer.cornerRadius = 40*0.5
        annotationView?.layer.masksToBounds = true
        annotationView?.layer.borderWidth = 1.5
        annotationView?.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        return annotationView
    }
    
    //MARK : ResizeImage function
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        
        let widthRatio  = targetSize.width
        let heightRatio = targetSize.height
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: widthRatio, height: heightRatio)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        image.draw(in:rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if((view.annotation?.isKind(of: MKUserLocation.self))!){
            return
        }
        let ann = view.annotation as! customAnnotation
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = mainStoryboard.instantiateViewController(
            withIdentifier: "RestaurantDetailViewController") as? RestaurantDetailViewController {
            
            vc.resDetail = ann.result
            vc.modeFromWhere = 0
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}

//MARK: - Extension CollectionView DataSource/Delegate/DelegateFlowLayout
extension ViewController : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView.tag == 0){
            print(resA.count)
            return resA.count+1
        }
        else if(collectionView.tag == 1){
            print(resA[0].count)
            return resA[0].count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
        if(self.myCollectionView == collectionView){
            let countyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountyCollectionViewCell", for: indexPath) as! CountyCollectionViewCell

            countyCell.featuredImageView.image = UIImage(named: "loadingImage")
            countyCell.restaurantTitleLabel.text = ""
            
            countyCell.backgroundColorView.layer.cornerRadius = 15.0
            countyCell.backgroundColorView.layer.masksToBounds = true
            countyCell.featuredImageView.layer.cornerRadius = 15.0
           
            let index = (indexPath.row == 0) ? indexPath.row+6 : indexPath.row-1
            if(resA[index].count>0){
                countyCell.setCell(resA: resA[index][0], indexPath: indexPath)
            }
            
            return countyCell

        }
        else if(self.northCollectionView == collectionView){
            let northCell = collectionView.dequeueReusableCell(withReuseIdentifier: "northCollectionViewCell", for: indexPath) as! northCollectionViewCell
            print("indexPath.row:\(indexPath.row):\(northCell)")
            let index = indexPath.row
            if(resA[0].count > 0){
                northCell.setCell(resA: resA[1][index], indexPath: indexPath)
            }
            return northCell
            
        }
        
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let row = indexPath.row
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if(collectionView == myCollectionView){
            if(row == 7){
                if let vc = mainStoryboard.instantiateViewController(
                    withIdentifier: "saveRestaurantTableViewController") as? saveRestaurantTableViewController{
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
            else{
                if let vc = mainStoryboard.instantiateViewController(
                    withIdentifier: "ContentViewController") as? ContentViewController{
                    if(row == 0){
                        vc.title = "附近美食"
                        vc.resContent = resA[6]
                    }else{
                        vc.title = restaurantTitleArr[row]
                        vc.resContent = resA[row-1]
                    }
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
        }else if(collectionView == northCollectionView){
            if let vc = mainStoryboard.instantiateViewController(
                withIdentifier: "RestaurantDetailViewController") as? RestaurantDetailViewController{
                vc.resDetail = resA[1][row]
                vc.modeFromWhere = 0
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}

extension ViewController : UIScrollViewDelegate{
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.myCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        
        targetContentOffset.pointee = offset
    }
    
}

class CountyCollectionViewCell:UICollectionViewCell{
    @IBOutlet var restaurantTitleLabel: UILabel!
    @IBOutlet var featuredImageView: UIImageView!
    @IBOutlet var backgroundColorView: UIView!
    
    func setCell(resA:restaurant_Content, indexPath:IndexPath) -> Void {
        var photoString:String
        
        self.restaurantTitleLabel.text = restaurantTitleArr[indexPath.row]
        
        photoString = resA.photo!
        let url = URL(string: photoString)
        
        if(indexPath.row == 7){
            self.featuredImageView.image = UIImage(named: "saveRestaurant")
        }else{
            self.featuredImageView.sd_setImage(with: url, placeholderImage: nil)
        }
    }
}

class northCollectionViewCell:UICollectionViewCell{
    @IBOutlet var featuredImageView: UIImageView!
    @IBOutlet var ratingView: CosmosView!
    
    func setCell(resA:restaurant_Content, indexPath:IndexPath) -> Void {
        let url = URL(string: resA.photo!)
        self.featuredImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "loadingImage"))
        
        if(ratingView != nil){
            ratingView.rating = resA.rating
        }
    }
    
}

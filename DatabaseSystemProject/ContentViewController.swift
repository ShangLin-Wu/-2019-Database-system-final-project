//
//  ContentViewController.swift
//  DatabaseSystemProject
//
//  Created by 吳尚霖 on 12/15/19.
//  Copyright © 2019 吳尚霖. All rights reserved.
//

import UIKit
import Cosmos

var dataArr = [[Data.Element]]()

class ContentViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    var resContent = [restaurant_Content]()
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
}

//MARK: - Extension CollectionView
extension ContentViewController : UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resContent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewCell", for: indexPath) as! ContentCollectionViewCell
        
        cell.restaurantAddress.text = nil
        cell.restaurantTitle.text = nil
        cell.ratingNum.text = nil
        
        cell.layer.cornerRadius = 35
        cell.loadImage.layer.masksToBounds = true
        cell.loadImage.layer.cornerRadius = 35
        cell.restaurantImageView.layer.masksToBounds = true
        cell.restaurantImageView.layer.cornerRadius = 20 //cell.restaurantImageView.bounds.width/2
        
        
        cell.tag = indexPath.row
        cell.setCell(res: resContent, indexPath: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = mainStoryboard.instantiateViewController(
            withIdentifier: "RestaurantDetailViewController") as? RestaurantDetailViewController {
            vc.resDetail = resContent[indexPath.row]
            vc.modeFromWhere = 0
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        
        targetContentOffset.pointee = offset
    }
    
}

class ContentCollectionViewCell: UICollectionViewCell {
    @IBOutlet var ratingNum: UILabel!
    @IBOutlet var ratingView: UIView!
    @IBOutlet var loadImage:UIImageView!
    @IBOutlet var restaurantTitle: UILabel!
    @IBOutlet var restaurantAddress: UILabel!
    @IBOutlet var restaurantCommentNum: UILabel!
    @IBOutlet var restaurantImageView: UIImageView!

    func setCell (res : [restaurant_Content], indexPath : IndexPath){
        
        if(self.tag == indexPath.row){
            self.ratingNum.text = "\(res[indexPath.row].rating)"
            self.ratingStar(rating: res[indexPath.row].rating)
            self.restaurantTitle.text = res[indexPath.row].name
            self.restaurantAddress.text = res[indexPath.row].vicinity
            self.restaurantCommentNum.text = "已有 \(res[indexPath.row].reviewsNumber) 人評論過此餐廳"
            DispatchQueue.global().async { [weak self] in
                if let url = URL(string: res[indexPath.row].photo!){
                    DispatchQueue.main.async {
                        self?.restaurantImageView.sd_setImage(with: url, placeholderImage: nil)
                    }
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
        ratingView.addSubview(view)
    }
    
}

//
//  getRestaurantRes.swift
//  DatabaseSystemProject
//
//  Created by 吳尚霖 on 11/28/19.
//  Copyright © 2019 吳尚霖. All rights reserved.
//

import Foundation
import RealmSwift

struct getRestaurantRes:Codable {
    
    var status:Int = 0
    var errMsgs:[String] = [String]()
    var results:result_Restaurant = result_Restaurant()
    
}

struct result_Restaurant:Codable {
    
    var content:[restaurant_Content] = [restaurant_Content]()
    var loveAddress:restaurant_LoveAddress = restaurant_LoveAddress()
    var historyAddress:restaurant_HistoryAddress = restaurant_HistoryAddress()
    var count:[Int] = [Int]()
    
}

class restaurant_Content:Object, Codable ,NSCopying {
    
    @objc dynamic var placeID:String?
    @objc dynamic var type = 0
    @objc dynamic var lat = 0.0
    @objc dynamic var lng = 0.0
    @objc dynamic var name:String?
    @objc dynamic var rating = 0.0
    @objc dynamic var vicinity:String?
    @objc dynamic var photo:String?
    @objc dynamic var phone:String?
    dynamic var open = List<String>()
    @objc dynamic var priceLevel = 0
    @objc dynamic var reviewsNumber = 0
    @objc dynamic var index = 0
    var periods = List<restaurant_Content_Periods>()
    var reviews = List<restaurant_Content_Reviews>()
    
    func copy(with zone: NSZone? = nil) -> Any {
        let newRes = restaurant_Content()
        newRes.type = type
        newRes.lat = lat
        newRes.lng = lng
        newRes.name = name
        newRes.rating = rating
        newRes.vicinity = vicinity
        newRes.photo = photo
        newRes.phone = phone
        newRes.open = List<String>()
        newRes.priceLevel = priceLevel
        newRes.reviewsNumber = reviewsNumber
        newRes.placeID = placeID
        newRes.index = index
        newRes.periods = List<restaurant_Content_Periods>()
        newRes.reviews = List<restaurant_Content_Reviews>()
        
        
        for i in open {
            newRes.open.append(i)
        }
        
        for i in periods {
            var periods = restaurant_Content_Periods()
            periods = i.copy() as! restaurant_Content_Periods
            newRes.periods.append(periods)
        }
        
        for i in reviews {
            var review = restaurant_Content_Reviews()
            review = i.copy() as! restaurant_Content_Reviews
            newRes.reviews.append(review)
        }
        return newRes
    }
    
}

class restaurant_Content_Periods:Object, Codable , NSCopying {
    @objc dynamic var close:periods_Close? = nil
    @objc dynamic var open:periods_Open? = nil
    
    func copy(with zone: NSZone? = nil) -> Any {
        let periods = restaurant_Content_Periods()
        periods.close = (close?.copy() as! periods_Close)
        periods.open = (open?.copy() as! periods_Open)
        return periods
    }
    
}

class periods_Close:Object, Codable , NSCopying {
    @objc dynamic var day:Int = 0
    @objc dynamic var time:String = ""
    
    func copy(with zone: NSZone? = nil) -> Any {
        let close = periods_Close()
        close.day = day
        close.time = time
        return close
    }
}

class periods_Open:Object, Codable , NSCopying{
    @objc dynamic var day:Int = 0
    @objc dynamic var time:String = ""
    
    func copy(with zone: NSZone? = nil) -> Any {
        let open = periods_Open()
        open.day = day
        open.time = time
        return open
    }
}

class restaurant_Content_Reviews:Object, Codable , NSCopying {
    
    @objc dynamic var name:String?
    @objc dynamic var photo:String?
    @objc dynamic var rating = 0
    @objc dynamic var text:String?
    @objc dynamic var time = 0
    
    func copy(with zone: NSZone? = nil) -> Any {
        let reviews = restaurant_Content_Reviews()
        reviews.name = self.name
        reviews.photo = self.photo
        reviews.rating = self.rating
        reviews.text = self.text
        reviews.time = self.time
        return reviews
    }
}

class restaurant_LoveAddress:Object, Codable {
    dynamic var lat:Double = 0.0
    dynamic var lng:Double = 0.0
    dynamic var address:String = ""
    dynamic var placeID:String = ""
}

class restaurant_HistoryAddress:Object,Codable {
    dynamic var lat:Double = 0.0
    dynamic var lng:Double = 0.0
    dynamic var address:String = ""
    dynamic var placeID:String = ""
}



import Foundation
//import RealmSwift
//class getRestaurantRes:Object, Codable {
//
//    dynamic var status:Int = 0
//   dynamic var errMsgs:[String] = [String]()
//   dynamic var results:result_Restaurant = result_Restaurant()
//
//}
//
//class result_Restaurant:Object, Codable {
//
//   dynamic var content:[restaurant_Content] = [restaurant_Content]()
//   dynamic var loveAddress:restaurant_LoveAddress = restaurant_LoveAddress()
//   dynamic var historyAddress:restaurant_HistoryAddress = restaurant_HistoryAddress()
//   dynamic var count:[Int] = [Int]()
//
//}
//
//class restaurant_Content:Object, Codable {
//
//   dynamic var type:Int?
//   dynamic var lat:Double?
//   dynamic var lng:Double?
//   dynamic var name:String?
//   dynamic var rating:Double?
//   dynamic var vicinity:String?
//   dynamic var photo:String?
//   dynamic var phone:String?
//   dynamic var open:[String]?
//   dynamic var priceLevel:Int?
//   dynamic var reviewsNumber:Int?
//   dynamic var placeID:String?
//   dynamic var index:Int?
//   dynamic var periods:[restaurant_Content_Periods] = [restaurant_Content_Periods]()
//   dynamic var reviews:[restaurant_Content_Reviews] = [restaurant_Content_Reviews]()
//
//}
//
//class restaurant_Content_Periods:Object, Codable {
//   dynamic var close:periods_Close = periods_Close()
//   dynamic var open:periods_Open = periods_Open()
//}
//
//class periods_Close:Object, Codable {
//   dynamic var day:Int = 0
//   dynamic var time:String = ""
//}
//
//class periods_Open:Object, Codable {
//   dynamic var day:Int = 0
//    dynamic var time:String = ""
//}
//
//class restaurant_Content_Reviews:Object, Codable {
//
//   dynamic var name:String?
//   dynamic var photo:String?
//   dynamic var rating:Int?
//   dynamic var text:String?
//   dynamic var time:Int?
//
//}
//
//class restaurant_LoveAddress:Object, Codable {
//   dynamic var lat:Double = 0.0
//   dynamic var lng:Double = 0.0
//   dynamic var address:String = ""
//   dynamic var placeID:String = ""
//}
//
//class restaurant_HistoryAddress:Object,Codable {
//    dynamic var lat:Double = 0.0
//   dynamic var lng:Double = 0.0
//   dynamic var address:String = ""
//   dynamic var placeID:String = ""
//}
//

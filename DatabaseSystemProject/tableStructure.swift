//
//  tableStructure.swift
//  DatabaseSystemProject
//
//  Created by 吳尚霖 on 12/22/19.
//  Copyright © 2019 吳尚霖. All rights reserved.
//

import UIKit
import RealmSwift

class restaurantTable: Object {
    dynamic var resDetail = List<restaurantDetail>()
}

class restaurantDetail: Object {
    
    @objc dynamic var lat = 0.0
    @objc dynamic var lng = 0.0
    @objc dynamic var name = ""
    @objc dynamic var type = 0
    @objc dynamic var index = 0
    @objc dynamic var photo = ""
    @objc dynamic var phone = ""
    @objc dynamic var rating = 0.0
    @objc dynamic var placeID = ""
    @objc dynamic var vicinity = ""
    @objc dynamic var priceLevel = 0
    @objc dynamic var reviewsNumber = 0
    dynamic var open = List<String>()
    dynamic var periods = List<restaurant_Content_Periods>()
    dynamic var reviews = List<restaurant_Content_Reviews>()
}

class detailPeriods: Object{
    dynamic var close:[detailPeriods_Close] = [detailPeriods_Close]()
    dynamic var open:[detailPeriods_Open] = [detailPeriods_Open]()
}

class detailReviews: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var photo = ""
    @objc dynamic var rating = 0
    @objc dynamic var text = ""
    @objc dynamic var time = 0
    
}

class detailPeriods_Close: Object{
    @objc dynamic var day = 0
    @objc dynamic var time = ""
}

class detailPeriods_Open: Object{
    @objc dynamic var day = 0
    @objc dynamic var time = ""
}

//
//@objc dynamic var type = 0
//@objc dynamic var lat = 0.0
//@objc dynamic var lng = 0.0
//@objc dynamic var name = ""
//@objc dynamic var rating = 0.0
//@objc dynamic var vicinity = ""
//@objc dynamic var photo = ""
//@objc dynamic var phone = ""
//@objc dynamic var open = [""]
//@objc dynamic var priceLevel = 0
//@objc dynamic var reviewsNumber = 0
//@objc dynamic var placeID = ""
//@objc dynamic var index = vicinity
//@objc dynamic var periods = List<detailPeriods>()
//@objc dynamic var reviews:[restaurant_Content_Reviews] = [restaurant_Content_Reviews]()


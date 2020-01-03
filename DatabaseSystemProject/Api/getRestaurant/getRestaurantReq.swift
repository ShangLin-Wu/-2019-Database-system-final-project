//
//  getRestaurantReq.swift
//  DatabaseSystemProject
//
//  Created by 吳尚霖 on 11/28/19.
//  Copyright © 2019 吳尚霖. All rights reserved.
//

import Foundation

struct getRestaurantReq:Codable {
    
    var accountID:String
    var lastIndex:Int
    var count:Int
    var type:[Int]
    var lat:Double
    var lng:Double
    var range:String
    var money:Int
    var label:String
    
    init(accountID:String, lastIndex:Int, count:Int, type:[Int],
         lat:Double, lng:Double,range:String, money:Int, label:String){
        self.accountID = accountID
        self.lastIndex = lastIndex
        self.count = count
        self.type = type
        self.lat = lat
        self.lng = lng
        self.range = range
        self.money = money
        self.label = label
    }
    
    
}



//
//  getRestaurantListReq.swift
//  DatabaseSystemProject
//
//  Created by 吳尚霖 on 12/20/19.
//  Copyright © 2019 吳尚霖. All rights reserved.
//

import Foundation

///type
///0:取得最愛/歷史地址
///1:刪除歷史地址
///2:儲存歷史地址
///3:刪除最愛地址
///4:儲存最愛地址
class getRestaurantListReq : Codable {
    var accountID:String
    var type:Int
    var lat:Double
    var lng:Double
    var address:String
    var placeID:String

    init(accountID:String, type:Int, lat:Double, lng:Double, address:String, placeID:String){
        self.accountID = accountID
        self.type = type
        self.lat = lat
        self.lng = lng
        self.address = address
        self.placeID = placeID
    }
}



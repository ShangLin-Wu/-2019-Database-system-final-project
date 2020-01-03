//
//  getRestaurantListRes.swift
//  DatabaseSystemProject
//
//  Created by 吳尚霖 on 12/20/19.
//  Copyright © 2019 吳尚霖. All rights reserved.
//

import Foundation

class getRestaurantListRes: Codable {
    
    var status:Int = 0
    var errMsgs:[String] = [String]()
    var results:results_List = results_List()
}

class results_List: Codable {
    var loveList:[restaurant_LoveAddress] = [restaurant_LoveAddress]()
    var historyList:[restaurant_HistoryAddress]  = [restaurant_HistoryAddress]()
}

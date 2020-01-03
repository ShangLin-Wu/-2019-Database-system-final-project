//
//  DataManager.swift
//  DatabaseSystemProject
//
//  Created by 吳尚霖 on 12/12/19.
//  Copyright © 2019 吳尚霖. All rights reserved.
//

import Foundation

class DataManager :ApiAgentDelegate {
    let apiAgent = ApiAgent()
    
    func resInfo(Res: Any, name: String) {
        let methodResponse = MethodResponse();
        methodResponse.methodName = name;
        methodResponse.object = Res;
        
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "dataManager"), object: methodResponse)
        
    }
    
    func getRestaurant(req :getRestaurantReq){
        apiAgent.delegate = self
        apiAgent.getRestaurant(req: req)
    }
    
    func getRestaurantList(req :getRestaurantListReq){
        apiAgent.delegate = self
        apiAgent.getRestaurantList(req: req)
    }

}

class MethodResponse: NSObject {
    var methodName:String?;
    var object:Any?;
}


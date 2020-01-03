//
//  ApiAgent.swift
//  DatabaseSystemProject
//
//  Created by 吳尚霖 on 12/12/19.
//  Copyright © 2019 吳尚霖. All rights reserved.
//

import UIKit
let apiStr = "YourApiString"

@objc protocol ApiAgentDelegate {
    @objc func resInfo(Res:Any,name:String)
}

class ApiAgent: NSObject {
    var delegate : ApiAgentDelegate?
    
    func getRestaurant(req: getRestaurantReq) -> Void {
        let url = URL(string: apiStr + "ApiURL")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(req)
        
        sendHttpRequest(req: request) { (data:NSData?, error:NSError?) in
            
            var res:getRestaurantRes?
            
            if(error != nil){
                res?.status = 3;
                self.sendRes(res: res!,toDelegateNameIs:"getRestaurant");
            }
            else{
                do{
//                    let dictionary = try JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    
                    res = try JSONDecoder().decode(getRestaurantRes.self,from: data! as Data)
                    self.sendRes(res: res!, toDelegateNameIs:"getRestaurant")
                    
                }catch{
                    print("ERROR",error)
                }
            }
        }
    }
    
    func getRestaurantList(req: getRestaurantListReq) -> Void {
        let url = URL(string: apiStr + "lineBot/restaurant/address")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(req)
        
        sendHttpRequest(req: request) { (data, error) in
            var res:getRestaurantListRes?
            
            if(error != nil){
                
                res?.status = 3
                (req.type==0) ? self.sendRes(res: res!, toDelegateNameIs: "getRestaurantList") :
                    self.sendRes(res: res!, toDelegateNameIs: "getRestaurantListAdd/DelFavorite") //req.type == 3 || req.type == 4
                
            }else{
                do{
                    
                    res = try JSONDecoder().decode(getRestaurantListRes.self, from: data! as Data)
                    (req.type==0) ? self.sendRes(res: res!, toDelegateNameIs: "getRestaurantList") :
                    self.sendRes(res: res!, toDelegateNameIs: "getRestaurantListAdd/DelFavorite") //req.type == 3 || req.type == 4
                
                }catch{
                    print("ERROR",error)
                }
            }
        }
    }
    
    func sendHttpRequest(req : URLRequest,
                         completionHandle: @escaping (NSData?, NSError?) -> Void){
        
        let task = URLSession.shared.dataTask(with: req){ (data,response,error) in
            guard let data = data else { return }
            
            completionHandle(data as NSData,nil)
            
            if ((error) != nil) {
                completionHandle(nil, error as NSError?)
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode)
                else {
                    completionHandle(nil, error as NSError?)
                    return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("The Response is : ",json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
            
        }
        task.resume()
        
    }
    
    
    func sendRes(res:Any , toDelegateNameIs:String){
        self.delegate?.resInfo(Res: res, name: toDelegateNameIs)
    }
}

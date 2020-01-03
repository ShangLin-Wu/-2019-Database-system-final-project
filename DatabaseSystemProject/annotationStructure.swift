//
//  annotationStructure.swift
//  DatabaseSystemProject
//
//  Created by 吳尚霖 on 12/26/19.
//  Copyright © 2019 吳尚霖. All rights reserved.
//

import UIKit
import MapKit

class customAnnotation : NSObject, MKAnnotation {

    var title: String?
    var subtitle: String?
    var lat: CLLocationDegrees?
    var lng: CLLocationDegrees?
    var coordinate: CLLocationCoordinate2D
    var result: restaurant_Content = restaurant_Content()
    
    init(title:String? ,subtitle:String? ,coordinate:CLLocationCoordinate2D ,res:restaurant_Content){
        
        self.result = res
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.lat = coordinate.latitude
        self.lng = coordinate.longitude
        super.init()
    }
    
}

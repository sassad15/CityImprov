//
//  City.swift
//  City2City729
//
//  Created by mac on 8/6/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import CoreLocation

class City {
    
    let name: String
    let state: String
    let population: String
    let coordinates: CLLocationCoordinate2D
    
    init?(from dict: [String:Any]) {
        
        guard let city = dict["city"] as? String,
            let long = dict["longitude"] as? Double,
            let lat = dict["latitude"] as? Double,
            let pop = dict["population"] as? String,
            let state = dict["state"] as? String else {
            return nil
        }
        
        //if you a key is optional you must state that the property is optional and leave it out of the guard statement, to allow for it to be nil and continue with the object init
        
//        let state = dict["state"] as? String
        
        self.name = city
        self.state = state
        self.population = pop
        self.coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
    }
    
    init(from core: CoreCity) {
        
        let name = core.value(forKey: "name") as! String
        let state = core.value(forKey: "state") as! String
        let lat = core.value(forKey: "latitude") as! Double
        let long = core.value(forKey: "longitude") as! Double
        let population = core.value(forKey: "population") as! String
        
        self.name = name
        self.state = state
        self.population = population
        self.coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        
    }
    
    
}

extension City: Equatable {
    
    static func == (lhs: City, rhs: City) -> Bool {
        return lhs.coordinates.latitude == rhs.coordinates.latitude
            && lhs.coordinates.longitude == rhs.coordinates.longitude
    }
    
}

extension City: CustomStringConvertible {
    
    var description: String {
        return "\(name), \(state)"
    }
    
}

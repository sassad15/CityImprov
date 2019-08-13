//
//  Weather.swift
//  City2City729
//
//  Created by mac on 8/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation


class Weather {
    
    let temperature: Double
    let humidity: Int
    let description: String
    let windSpeed: Double
    
    init?(from dict: [String:Any]) {
        
        guard let weatherDict = dict["weather"] as? [[String:Any]],
            let mainDict = dict["main"] as? [String:Any],
            let windDict = dict["wind"] as? [String:Double] else { return nil }
        
        self.temperature = mainDict["temp"] as! Double
        self.humidity = mainDict["humidity"] as! Int
        self.description = weatherDict[0]["description"] as! String
        self.windSpeed = windDict["speed"] ?? 0.0 //nil-coalescing - give an optional a default value
        
    }
    
}

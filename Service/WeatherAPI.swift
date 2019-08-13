//
//  WeatherAPI.swift
//  City2City729
//
//  Created by mac on 8/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation


struct WeatherAPI {
    
    //api.openweathermap.org/data/2.5/weather?lat=33.7490&lon=84.3880&APPID=7cdcd7f9a8620c069b7159b27a5f7a34&units=imperial
    var city: City
    
    init(with city: City) {
        self.city = city
    }
    
    let base = "https://api.openweathermap.org/data/2.5/weather?"
    let key = "APPID=7cdcd7f9a8620c069b7159b27a5f7a34&units=imperial"
    
    var getUrl: URL? {
        let endpoint = base + key + "&lat=\(city.coordinates.latitude)&lon=\(city.coordinates.longitude)"
        return URL(string: endpoint)
    }
    
}

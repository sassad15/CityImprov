//
//  WeatherService.swift
//  City2City729
//
//  Created by mac on 8/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

typealias WeatherHandler = (Weather?) -> Void


let weatherService = WeatherService.shared

final class WeatherService {
    
    static let shared = WeatherService()
    private init() {}
    
    
    func getWeather(from city: City, completion: @escaping WeatherHandler) {
        
        guard let url = WeatherAPI(with: city).getUrl else {
            completion(nil)
            return
        }
        
        /*API request - we need to create a URLSession data tak to consume an endpoint
         by default a data task starts in a suspended state - put resume on the task to fire it
        */
        
        URLSession.shared.dataTask(with: url) { (dat, _, err) in
            
            if let error = err {
                completion(nil)
                print("Bad Data Task: \(error.localizedDescription)")
                return
            }
            
            if let data = dat {
                do {
                    
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        
                        let weather = Weather(from: jsonResponse)
                        completion(weather)
                    }
                } catch {
                    print("Couldn't Serialize Object: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
            }
        }.resume()
        
    } //end func
    
    
    
}

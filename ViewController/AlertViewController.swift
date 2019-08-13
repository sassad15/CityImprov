//
//  AlertViewController.swift
//  City2City729
//
//  Created by mac on 8/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    @IBOutlet weak var alertCityName: UILabel!
    @IBOutlet weak var alertDescrip: UILabel!
    
    @IBOutlet weak var alertTemp: UILabel!
    @IBOutlet weak var alertHumidity: UILabel!
    @IBOutlet weak var alertWindSpeed: UILabel!
    
    @IBOutlet weak var alertView: UIView!
    
    
    var alertTuple: (city: City, weather: Weather)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAlert()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        if touch.view == self.view {
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    private func setupAlert() {
        
        alertView.layer.cornerRadius = 25
        
        let city = alertTuple.city; let weather = alertTuple.weather
        
        alertCityName.text = "\(city.name), \(city.state)"
        alertDescrip.text = weather.description
        alertTemp.text = "\(weather.temperature) Degrees"
        alertHumidity.text = "\(weather.humidity) Humidity"
        alertWindSpeed.text = "\(weather.windSpeed) Wind Speed"
        
        
    }
    
}

extension AlertViewController {
    
    //static funcs and class functions are the same except; class keyword can only be used for classes AND you can modify a class function
    class func instantiate(with tuple: (city: City, weather: Weather)) -> AlertViewController {
        let storyboard = UIStoryboard(name: "Custom", bundle: Bundle.main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        alertVC.alertTuple = tuple
        return alertVC
    }
}

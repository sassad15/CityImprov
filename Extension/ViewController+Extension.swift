//
//  ViewController+Extension.swift
//  City2City729
//
//  Created by mac on 8/8/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit


extension UIViewController {
    
    func goToMap(of city: City) {
        
        let mapVC = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        
        mapVC.mapCity = city
        
        mapVC.hidesBottomBarWhenPushed = true
        navigationController?.view.backgroundColor = .white
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
}

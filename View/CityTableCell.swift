//
//  CityTableCell.swift
//  City2City729
//
//  Created by mac on 8/6/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class CityTableCell: UITableViewCell {

    //property observer - DidSet, WillSet - This allows us to perform actions before and/or after the value has changed
    var city: City! {
        didSet {
            cityMainLabel.text = "\(city.name), \(city.state)"
            //nil coalescing - give a default value to an optional
            citySubLabel.text = "Population: \(city.population.addCommas ?? "Not Available")"
        }
    }
    
    //static - global property - that allows us to access the property without an instance, it belongs to the object
    static let identifier = "CityTableCell"

    @IBOutlet weak var citySubLabel: UILabel!
    @IBOutlet weak var cityMainLabel: UILabel!
    
    
    
}

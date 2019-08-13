//
//  String+Extension.swift
//  City2City729
//
//  Created by mac on 8/8/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation


extension String {
    
    //Extensions can NOT have stored properties, MUST be computed
    var addCommas: String? {
        
        guard let number = Int(self) else {
            return nil
        }
        
        let nsNum = NSNumber(value: number)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
       return numberFormatter.string(from: nsNum)
    }
    
    
    
}

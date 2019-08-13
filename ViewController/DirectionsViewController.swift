//
//  DirectionsViewController.swift
//  City2City729
//
//  Created by mac on 8/12/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import MapKit

class DirectionsViewController: UIViewController {
    
    @IBOutlet weak var directionsMap: MKMapView!
    
    var cities: [City]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDirections()
    }

    private func setupDirections() {
        directionsMap.delegate = self
        guard let firstCity = cities.first, let secondCity = cities.last else {
            return
        }
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: firstCity.coordinates))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: secondCity.coordinates))
        
        let directions = MKDirections(request: request)
        
        directions.calculate { (resp, _) in
            
            if let response = resp {
                guard let directionLine = response.routes.first?.polyline else {
                    return
                }
                
                self.directionsMap.addOverlay(directionLine)
                self.directionsMap.setVisibleMapRect(directionLine.boundingMapRect, animated: true)
                
            }
        }
    }
}

extension DirectionsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let line = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        line.strokeColor = UIColor.blue
        return line
    }
}

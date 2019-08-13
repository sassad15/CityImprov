//
//  MapViewController.swift
//  City2City729
//
//  Created by mac on 8/8/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var mapCity: City! //dependency injection, whenever a dependency for an object is set from outside the declaration
    var mapWeather: Weather!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWeather()
        setupMap()
        setupBarButtonItems()
    
    }
    
    
    private func setupMap() {
        
        definesPresentationContext = true
        let region = MKCoordinateRegion(center: mapCity.coordinates, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        let location = MKPointAnnotation()
        location.coordinate = mapCity.coordinates
        location.title = mapCity.name
        location.subtitle = mapCity.state
        mapView.addAnnotation(location)
        mapView.delegate = self
        mapView.region = region
    }
    
    private func setupBarButtonItems() {
        
       
        let weatherButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(weatherButtonTapped))
        navigationItem.rightBarButtonItem = weatherButtonItem
    
    }
    
    private func getWeather() {
        
        weatherService.getWeather(from: mapCity) { [weak self] wthr in
            if let weather = wthr {
                self?.mapWeather = weather
                print("Received Weather: \(weather.description)")
            }
        }
    }
    
    
    @objc func weatherButtonTapped() {
        
        let alert = AlertViewController.instantiate(with: (mapCity, mapWeather))
        present(alert, animated: true, completion: nil)
        
    }
    

}

//MARK: MapView Delegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is MKPointAnnotation else {return nil}
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotation")
        
        switch annotationView == nil {
        case true:
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
            annotationView?.canShowCallout = true
        case false:
            annotationView?.annotation = annotation
        }
        
        
        return annotationView
    }
    
}

//
//  FavoritesViewController.swift
//  City2City729
//
//  Created by mac on 8/6/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit


class RecentsViewController: UIViewController {
    
    @IBOutlet weak var recentsTableView: UITableView!
    
    var cities = [City]() {
        didSet {
            recentsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecents()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cities = manager.load()
        
    }
    
    private func setupRecents() {
        
        recentsTableView.register(UINib(nibName: CityTableCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: CityTableCell.identifier)
        recentsTableView.tableFooterView = UIView(frame: .zero)

    }


}

extension RecentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableCell.identifier, for: indexPath) as! CityTableCell
        
        let city = cities[indexPath.row]
        cell.city = city
        
        let backCity : [City] = cities.reversed()
        var _ : [City] = cities.count > 9
        ? Array(backCity.prefix(9)) : backCity
        _ = backCity[indexPath.row]
        cell.city = city
        print("Successful")
        
        
        return cell
    }
    
    
//        func checkFor(_ city: City) { //checks for the city
//
//            let fetch = NSFetchRequest<CoreCity>(entityName: "CoreCity")
//
//            var cities = [CoreCity]()
//
//            do {
//                cities = try context.fetch(fetch)
//            } catch {
//                print("Couldn't Fetch Core: \(error.localizedDescription)")
//            }
//
//            if cities.count > 9 {   // if cities are greater than 9, the previous cities will not show up in the recents view controller.
//                remove(cities.first!)
//            }
//
//            for cty in cities {
//                if cty.name == city.name && cty.state! == city.state {
//                    remove(cty)
//                }
//            }
//
//        }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let city = cities[indexPath.row]
        goToMap(of: city)
    }
    
    
}

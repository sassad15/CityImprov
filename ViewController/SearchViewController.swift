//
//  ViewController.swift
//  City2City729
//
//  Created by mac on 8/6/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var selectButton: UIBarButtonItem!
    /* Access Controls
     1. open - this allows access from outside the module and modabliity
     2. public - this allows access from outside but does NOT allow for modability
     3. internal - default - allows for access inside the module
     4. fileprivate - only allows access in that specific file
     5. private - only allows acess inside the declaration
    */
    
    private var filteredCities = [City]() {
        didSet {
            DispatchQueue.main.async {
                self.searchTableView.reloadData()
            }
        }
    }
    
    private var cities = [City]() {
        didSet {
            orderedCities = order(cities: cities)
        }
    }
    
    private var orderedCities = [String : [City]]() {
        didSet {
            DispatchQueue.main.async {
                self.searchTableView.reloadData()
            }
        }
    }
    
    private var selectedCities = [City]()
    
    private var selectIsActive = false {
        didSet {
            switch selectIsActive {
            case true:
                searchTableView.allowsMultipleSelection = true
                selectButton.tintColor = UIColor.red
            case false:
                searchTableView.allowsMultipleSelection = false
                selectButton.tintColor = UIColor.blue
            }
        }
    }
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearch()
        createSearchBar()
       
        //capture list - set properties to weak that will be used in a closure - used to avoid retain cycles
        manager.getCities { [weak self] citis in
            self?.cities = citis
            print("Cities Count: \(citis.count)")
        }
    }
    
    @IBAction func selectButtonTapped(_ sender: UIBarButtonItem) {
        
        selectIsActive.toggle()
        
    }
    
    

    private func setupSearch() {
        
        //XIBs, are saved in NIB files
        searchTableView.register(UINib(nibName: CityTableCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: CityTableCell.identifier)
        definesPresentationContext = true
    }
    
    private func createSearchBar() {
        
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.dimsBackgroundDuringPresentation = false
        
    }
    
    private func order(cities: [City]) -> [String:[City]] {
        
        
        var ordered = [String: [City]]()
        
        
        for city in cities {
            
            let letter = city.name.first!.uppercased()
            
//            ordered[letter] = ordered[letter] == nil ? [city] : ordered[letter]! + [city]
            
            if ordered[letter] == nil {
                ordered[letter] = [city]
            } else {
                ordered[letter] = ordered[letter]! + [city]
            }
            
        }
        
//        var ordered = Dictionary(grouping: cities, by: {$0.name.first!.uppercased()})

        for (key, value) in ordered {
            ordered[key] = value.sorted(by: ({$0.name < $1.name}))
        }
        
        
        return ordered
    }
    
    private func getCities(for section: Int) -> [City] {
        //dictionaries are unordered, so to the get the correct cities for the section we are on, we need to order the keys before every use. So first we get the keys and order them alphabetically.
        let keys = orderedCities.keys.sorted(by: {$0 < $1})
        //We now have all the keys so we use the section, from the parameter to get the correct key for the section
        let key = keys[section]
        //use the correct key for our ordered cities to get the cities correlating for that section
        let cities = orderedCities[key]!
        return cities
    }
    
    //MARK: Search Functionality

    private var isFiltering: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private func filterCities(by search: String) {
        
        filteredCities = cities.filter({$0.name.lowercased().contains(search.lowercased()) || $0.state.lowercased().contains(search.lowercased()) })
        
        
    }
    
}

//MARK: TableView

extension SearchViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //if isFiltering equals True, use the left side of the colon, if false, use the right side
        return isFiltering ? 1 : orderedCities.keys.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredCities.count : getCities(for: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableCell.identifier, for: indexPath) as! CityTableCell
        
        let cities = isFiltering ? filteredCities : getCities(for: indexPath.section)
        let city = cities[indexPath.row]
        cell.city = city
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isFiltering ? "All Cities" : getCities(for: section)[0].name.first!.uppercased()
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return isFiltering ? nil : orderedCities.keys.sorted(by: {$0 < $1})
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cities = isFiltering ? filteredCities : getCities(for: indexPath.section)
        let city = cities[indexPath.row]
        
        switch selectIsActive {
        case true:
            selectedCities.append(city)
            
            if selectedCities.count == 2 {
                
                let directionsVC = storyboard?.instantiateViewController(withIdentifier: "DirectionsViewController") as! DirectionsViewController
                directionsVC.cities = selectedCities
                
                print("Directions From: \(selectedCities[0]) to \(selectedCities[1])")
                
                selectedCities = []
                selectIsActive.toggle()
                
                navigationController?.pushViewController(directionsVC, animated: true)
                
            }
            
        case false:
            tableView.deselectRow(at: indexPath, animated: true)
            manager.save(city)
            goToMap(of: city)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("Removed Selected City: \(selectedCities.last!.name), \(selectedCities.last!.state)")
        selectedCities.removeLast(1)
    }
}

//MARK: SearchResultsUpdater
extension SearchViewController: UISearchResultsUpdating {
    
    //SearchResultUpdater is used to register each keystroke
    //UISearchBarDelegate would be used for registering once user hits Search button
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        filterCities(by: searchText)
    }
    
}

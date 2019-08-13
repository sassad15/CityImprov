//
//  CityManager.swift
//  City2City729
//
//  Created by mac on 8/6/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import CoreData

typealias CityHandler = ([City]) -> Void //nickname, often used with closures

/* Singleton
 
 is a single instance throughout the life span of an app, and it has a shared instance that everyone must use to interact with the object

 */

let manager = CityManager.shared

//1. final - no one can inherit from a CityManager type
final class CityManager {
    
    static var numberCount = 5
    //2. static shared variable for use
    static let shared = CityManager()
    //3. no one else outside of the declaration can create an instane
    private init() {}
    
    /* Core Data Stack
     1. NSManagedObject - Entity, or models, for core Data - Entities MUST be created in the context
     2. NSManagedObjectContext - place where all editing occurs - Save, Delete, Modify Entity
     3. PersistentStoreCoordinator - How entities are saved
     4. NSPersistentContainer - where all the enetities are stored
    */
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "City2City729")
        
        container.loadPersistentStores(completionHandler: { (storeDescrip, err) in
            if let error = err {
                fatalError("Couldn't Load Persistent Container")
            }
        })
        
        return container
    }()
    
    func save(_ city: City) {
        
        //checkFor(city)
        
        let entity = NSEntityDescription.entity(forEntityName: "CoreCity", in: context)!
        let coreCity = CoreCity(entity: entity, insertInto: context)
        
        //KVC - Key Value Coding - accessing properties by a string
        coreCity.setValue(city.name, forKey: "name")
        coreCity.setValue(city.state, forKey: "state")
        coreCity.setValue(city.coordinates.latitude, forKey: "latitude")
        coreCity.setValue(city.coordinates.longitude, forKey: "longitude")
        coreCity.setValue(city.population, forKey: "population")
        
        
        //everytime you make changes, you MUST save the context or the changes will NOT persist
        saveContext()
        
        print("Saved City to CoreData: \(city.name), \(city.state)")
        
    }
    
    func load() -> [City] {
        
        //access the entities in CoreData you need a fetch request
        let fetchRequest = NSFetchRequest<CoreCity>(entityName: "CoreCity")
        
        var cities = [City]()
        
        do {
            let coreCities = try context.fetch(fetchRequest)
            cities = coreCities.map({ City(from: $0) }) //map - goes over each element in array and performs closure
            cities.reverse()
        } catch {
            print("Couldn't Fetch Core: \(error.localizedDescription)")
        }
        
        print("CoreData City Count: \(cities.count)")
        return cities
    }
    
    
   
//    func checkFor(_ city: City) { //checks for the city
//
//        let fetch = NSFetchRequest<CoreCity>(entityName: "CoreCity")
//
//        var cities = [CoreCity]()
//
//        do {
//            cities = try context.fetch(fetch)
//        } catch {
//            print("Couldn't Fetch Core: \(error.localizedDescription)")
//        }
//
//        if cities.count > 9 {   // if cities are greater than 9, the previous cities will not show up in the recents view controller.
//            remove(cities.first!)
//        }
//
//        for cty in cities {
//            if cty.name == city.name && cty.state! == city.state {
//                remove(cty)
//            }
//        }
//
//    }
    
    
    private func remove(_ city: CoreCity) {
        print("Deleted CoreCity: \(city.name!), \(city.state!)")
        context.delete(city)
        saveContext()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            fatalError("Couldn't Save CoreData Context: \(error.localizedDescription)")
        }
    }
    
    
    /* Closures
     1. Non-Escaping - default - has the same life span of the function that it resides in
     2. escaping - gives a seperate life span to the closure, so that it can wait around to capture the async value
    */
    
    func getCities(_ completion: @escaping CityHandler) {
        
        guard let path = Bundle.main.path(forResource: "cities", ofType: "json") else {
            completion([])
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        
        
                func checkFor(_ city: City) { //checks for the city
        
                    let fetch = NSFetchRequest<CoreCity>(entityName: "CoreCity")
        
                    var cities = [CoreCity]()
        
                    do {
                        cities = try context.fetch(fetch)
                    } catch {
                        print("Couldn't Fetch Core: \(error.localizedDescription)")
                    }
        
                    if cities.count > 9 {   // if cities are greater than 9, the previous cities will not show up in the recents view controller.
                        remove(cities.first!)
                    }
        
                    for cty in cities {
                        if cty.name == city.name && cty.state! == city.state {
                            remove(cty)
                        }
                    }
        
                }
        
        
        //Thread - the context in which tasks are done
        //Queues - are the actionable items that are to be carried out
        
        /* Threads - 4 threads in IOS developmnt
         2 main threads - which are used for the UI
         2 background threads - which are used for long running/expensive tasks
         
         Mulithreading - Using concurrency to execute tasks
         
         GCD - Grand Central Dispatch
         global thread is background - global has multiple qualities of service - priority
         1. userinteractive
         2. userinitiated
         3. default - if we do not specify
         4. utility
         5. background
         
         async - is a concurrent queue - multiple tasks are being executed at the same time
         sync - is a serial queue - is one at a time, each task in queue must be completed before the next one
         
        */
        
        var cities = [City]()
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            do {
                let data = try Data(contentsOf: url)
                
                guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] else {
                    completion([])
                    return
                }
                
                for dict in jsonObject {
                    
                    if let city = City(from: dict) {
                        cities.append(city)
                    }
                }
        
                completion(cities)
                
                
            } catch {
                completion([])
                print("Couldn't Serialize Data: \(error.localizedDescription)")
            }
        }
    }
    
    
}

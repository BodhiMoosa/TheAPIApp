//
//  CoreDataManager.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 3/19/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit
import CoreData

class DataManager {
    static let shared = DataManager()
    
    private init() {}
    
    func checkFavorite(name: String) -> Bool {
        var checker = false
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return false }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        do {
            let result = try context.fetch(fetchRequest)
            for x in result as! [Favorite] {
                if x.name! == name {
                    checker = true
                }
            }
        } catch {
            print("uh oh")
        }
        return checker
        
    }
    
    func getFavorites() -> [Entry] {
        var holderArray : [Entry] = []
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return holderArray}
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        do {
            let result = try context.fetch(fetchRequest)
            for x in result as! [Favorite] {
                let name = x.name ?? "noname"
                let description = x.desc ?? "N/A"
                let auth = x.auth ?? "unknown"
                let https = x.https
                let cors = x.cors ?? "unknown"
                let link = x.link ?? "N/A"
                let category = x.category ?? "unknown"
                let singleEntry = Entry(api: name, description: description, auth: auth, https: https, cors: cors, link: link, category: category)
                holderArray.append(singleEntry)
            }
        } catch {
            print("uh oh")
        }
        return holderArray
    }
    
    func saveFavorite(api: Entry, completed: @escaping (Result<String, CustomErrors>)->Void) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: context)!
        let favorite = NSManagedObject(entity: entity, insertInto: context)
        favorite.setValue(api.api, forKey: "name")
        favorite.setValue(api.auth, forKey: "auth")
        favorite.setValue(api.cors, forKey: "cors")
        favorite.setValue(api.category, forKey: "category")
        favorite.setValue(api.description, forKey: "desc")
        favorite.setValue(api.https, forKey: "https")
        favorite.setValue(api.link, forKey: "link")
        do {
            try context.save()
            completed(.success("Saved!"))
        } catch {
            completed(.failure(.cannotSaveFavorite))
        }
    }
    
    
    
    func removeFavovorite(title: String, completed: @escaping (Result<String, CustomErrors>)-> Void) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        do {
            let result = try context.fetch(fetchRequest) as! [Favorite]
            for x in result {
                if title == x.name {
                    context.delete(x)
                }
            }
            try context.save()
            completed(.success("Favorite Removed!"))
        } catch {
            completed(.failure(.cannotDeleteFavorite))
        }
        
    }
    
    func getAllAPIs() -> [Entry]{
        var holderArray : [Entry] = []
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return holderArray}
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SingleAPI")
        do {
            let result = try context.fetch(fetchRequest)
            for x in result as! [SingleAPI] {
                let name = x.name ?? "noname"
                let description = x.desc ?? "N/A"
                let auth = x.auth ?? "unknown"
                let https = x.https
                let cors = x.cors ?? "unknown"
                let link = x.link ?? "N/A"
                let category = x.category ?? "unknown"
                let singleEntry = Entry(api: name, description: description, auth: auth, https: https, cors: cors, link: link, category: category)
                holderArray.append(singleEntry)
            }
        } catch {
            print(error.localizedDescription)
        }
        return holderArray
    }
    
    func addNewAPI(api: Entry) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        let entity = NSEntityDescription.entity(forEntityName: "SingleAPI", in: context)!
        let single = NSManagedObject(entity: entity, insertInto: context)
        single.setValue(api.api, forKey: "name")
        single.setValue(api.auth, forKey: "auth")
        single.setValue(api.cors, forKey: "cors")
        single.setValue(api.category, forKey: "category")
        single.setValue(api.description, forKey: "desc")
        single.setValue(api.https, forKey: "https")
        single.setValue(api.link, forKey: "link")
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getCategories() -> [String] {
        var holder : [String] = []
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return holder }
        let request = NSFetchRequest<NSManagedObject>(entityName: "SingleAPI")
        do {
            let result = try context.fetch(request) as! [SingleAPI]
            for x in result {
                let category = x.category ?? "empty"
                if !holder.contains(category) && category != "empty" {
                    holder.append(category)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return holder
    }
    
    func getAPIsWithinCategory(category: String) -> [Entry] {
        var holder : [Entry] = []
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return holder }
        let request = NSFetchRequest<NSManagedObject>(entityName: "SingleAPI")
        do {
            let result = try context.fetch(request) as! [SingleAPI]
                for x in result {
                    if x.category == category {
                        let https = x.https
                        if let auth = x.auth,
                            let description = x.desc,
                            let name = x.name,
                            let cors = x.cors,
                            let link = x.link {
                            let entry = Entry(api: name, description: description, auth: auth, https: https, cors: cors, link: link, category: category)
                            holder.append(entry)
                        }
                    }
            }
        } catch {
            print(error.localizedDescription)
        }
    return holder
    }
    
}



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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataEntities.favorite.rawValue)
        guard let result = try? context.fetch(fetchRequest) else { return false }
        for x in result as! [Favorite] {
            if x.name! == name {
                checker = true
            }
        }
        return checker
        
    }
    
    func getFavorites() -> [Entry] {
        var holderArray     : [Entry] = []
        guard let context   = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return holderArray}
        let fetchRequest    = NSFetchRequest<NSManagedObject>(entityName: CoreDataEntities.favorite.rawValue)
        guard let result    = try? context.fetch(fetchRequest) else { return holderArray }
        for x in result as! [Favorite] {
            let name        = x.name ?? "noname"
            let description = x.desc ?? "N/A"
            let auth        = x.auth ?? "unknown"
            let https       = x.https
            let cors        = x.cors ?? "unknown"
            let link        = x.link ?? "N/A"
            let category    = x.category ?? "unknown"
            let singleEntry = Entry(api: name, description: description, auth: auth, https: https, cors: cors, link: link, category: category)
            holderArray.append(singleEntry)
        }
        return holderArray
    }
    
    func saveFavorite(api: Entry) -> Bool {
        guard let context   = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return false }
        let entity          = NSEntityDescription.entity(forEntityName: CoreDataEntities.favorite.rawValue, in: context)!
        let favorite        = NSManagedObject(entity: entity, insertInto: context)
        favorite.setValue(api.api, forKey: CoreDataKeys.name.rawValue)
        favorite.setValue(api.auth, forKey: CoreDataKeys.auth.rawValue)
        favorite.setValue(api.cors, forKey: CoreDataKeys.cors.rawValue)
        favorite.setValue(api.category, forKey: CoreDataKeys.category.rawValue)
        favorite.setValue(api.description, forKey: CoreDataKeys.description.rawValue)
        favorite.setValue(api.https, forKey: CoreDataKeys.https.rawValue)
        favorite.setValue(api.link, forKey: CoreDataKeys.link.rawValue)
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func removeFavovorite(title: String) -> Bool {
        guard let context   = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return false }
        let fetchRequest    = NSFetchRequest<NSManagedObject>(entityName: CoreDataEntities.favorite.rawValue)
        do {
            let result = try context.fetch(fetchRequest) as! [Favorite]
            for x in result {
                if title == x.name {
                    context.delete(x)
                }
            }
            try context.save()
            return true
        } catch {
            return false
        }
        
    }
    
    func getAllAPIs() -> [Entry] {
        var holderArray     : [Entry] = []
        guard let context   = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return holderArray }
        let fetchRequest    = NSFetchRequest<NSManagedObject>(entityName: CoreDataEntities.singleAPI.rawValue)
        guard let result    = try? context.fetch(fetchRequest) else { return holderArray }
        for x in result as! [SingleAPI] {
            let name        = x.name ?? "noname"
            let description = x.desc ?? "N/A"
            let auth        = x.auth ?? "unknown"
            let https       = x.https
            let cors        = x.cors ?? "unknown"
            let link        = x.link ?? "N/A"
            let category    = x.category ?? "unknown"
            let singleEntry = Entry(api: name, description: description, auth: auth, https: https, cors: cors, link: link, category: category)
            holderArray.append(singleEntry)
        }
        return holderArray
    }
    
    func addNewAPI(api: Entry) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        let entity = NSEntityDescription.entity(forEntityName: CoreDataEntities.singleAPI.rawValue, in: context)!
        let single = NSManagedObject(entity: entity, insertInto: context)
        single.setValue(api.api, forKey: CoreDataKeys.name.rawValue)
        single.setValue(api.auth, forKey: CoreDataKeys.auth.rawValue)
        single.setValue(api.cors, forKey: CoreDataKeys.cors.rawValue)
        single.setValue(api.category, forKey: CoreDataKeys.category.rawValue)
        single.setValue(api.description, forKey: CoreDataKeys.description.rawValue)
        single.setValue(api.https, forKey: CoreDataKeys.https.rawValue)
        single.setValue(api.link, forKey: CoreDataKeys.link.rawValue)
        do {
            try context.save()
        } catch {
            return
        }
    }
    
    func getCategories() -> [String] {
        var holder          : [String] = []
        guard let context   = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return holder }
        let request         = NSFetchRequest<NSManagedObject>(entityName: CoreDataEntities.singleAPI.rawValue)
        guard let result    = try? (context.fetch(request) as! [SingleAPI]) else { return holder }
            for x in result {
                let category = x.category ?? "empty"
                if !holder.contains(category) && category != "empty" {
                    holder.append(category)
                }
            }
        return holder
    }
    
    func getAPIsWithinCategory(category: String) -> [Entry] {
        var holder          : [Entry] = []
        guard let context   = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return holder }
        let request         = NSFetchRequest<NSManagedObject>(entityName: CoreDataEntities.singleAPI.rawValue)
        guard let result    = try? (context.fetch(request) as! [SingleAPI]) else { return holder }
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
        return holder
    }
}



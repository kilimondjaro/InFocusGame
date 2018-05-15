//
//  Helpers.swift
//  InFocusGame
//
//  Created by Kirill Babich on 10/05/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import Foundation
import CoreData

func fetchObjects() -> [ObjectType] {
    let fetch = NSFetchRequest<Category>(entityName: "Category")
    
    let c = CoreDataManager.instance.persistentContainer.viewContext
    do {
        let res = try c.fetch(fetch)
        var all: [ObjectType] = []
        for r in res {
            if let objects = r.objects?.allObjects as? [ObjectType] {
                all = all + objects
            }
        }
        return all.sorted(by: { $0.name! < $1.name! })
    }
    catch {
        
    }
    return []
}

func fetchObjectsByCategory(category: Categories) -> [ObjectType] {
    let fetch = NSFetchRequest<Category>(entityName: "Category")
    fetch.predicate = NSPredicate(format: "name == %@", category.rawValue)
    
    let sort = NSSortDescriptor(key: #keyPath(ObjectType.name), ascending: true)
    fetch.sortDescriptors = [sort]
    
    let c = CoreDataManager.instance.persistentContainer.viewContext
    do {
        let res = try c.fetch(fetch)
        for r in res {
            if let objects = r.objects?.allObjects as? [ObjectType] {
                return objects.sorted(by: { $0.name! < $1.name! })
            }
        }
    }
    catch {
        
    }
    return []
}

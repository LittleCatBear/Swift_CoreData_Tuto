//
//  LogItem.swift
//  MyLog
//
//  Created by Julie Huguet on 04/01/2015.
//  Copyright (c) 2015 Shokunin-Software. All rights reserved.
//

import Foundation
import CoreData

class LogItem: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var itemText: String
    @NSManaged var fullTitle: String
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, title: String, fullTitle: String, text: String)->LogItem {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("LogItem", inManagedObjectContext: moc) as LogItem
        newItem.title = title
        newItem.itemText = text
        newItem.fullTitle = fullTitle
        
        return newItem
        
    }

}

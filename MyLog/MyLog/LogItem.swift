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
    
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, title: String, text: String)->LogItem {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("LogItem", inManagedObjectContext: moc) as LogItem
        newItem.title = title
        newItem.itemText = text
        
        return newItem
        
    }

}

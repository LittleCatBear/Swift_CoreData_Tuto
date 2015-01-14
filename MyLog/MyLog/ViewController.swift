//
//  ViewController.swift
//  MyLog
//
//  Created by Julie Huguet on 04/01/2015.
//  Copyright (c) 2015 Shokunin-Software. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        } else {
            return nil
        }
    }()
    
    func presentFirstItem(){
        let fetchRequest = NSFetchRequest(entityName: "LogItem")
        if let fetchResult = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [LogItem]{
            let alert = UIAlertController(title: fetchResult[0].title, message: fetchResult[0].itemText, preferredStyle: .Alert)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        println(managedObjectContext)
        
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("LogItem", inManagedObjectContext: self.managedObjectContext!) as LogItem
        
        newItem.title = "Wrote core data tuto"
        newItem.itemText = "new tuto about core data"
       // presentFirstItem()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        presentFirstItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


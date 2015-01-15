//
//  ViewController.swift
//  MyLog
//
//  Created by Julie Huguet on 04/01/2015.
//  Copyright (c) 2015 Shokunin-Software. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        } else {
            return nil
        }
    }()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LogCell") as UITableViewCell
        let logItem = logItems[indexPath.row]
        cell.textLabel?.text = logItem.title
        return cell
    }
    
    func presentFirstItem(){
        let fetchRequest = NSFetchRequest(entityName: "LogItem")
        if let fetchResult = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [LogItem]{
            let alert = UIAlertController(title: fetchResult[0].title, message: fetchResult[0].itemText, preferredStyle: .Alert)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    var logTableView = UITableView(frame: CGRectZero, style: .Plain)
    var logItems = [LogItem]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let moc = self.managedObjectContext {
            
            LogItem.createInManagedObjectContext(moc, title: "item 1", text: "the first item")
            LogItem.createInManagedObjectContext(moc, title: "item 2", text: "the second item")
            LogItem.createInManagedObjectContext(moc, title: "item 3", text: "the third item")
        }
        
        var viewFrame = self.view.frame
        viewFrame.origin.y += 20
        viewFrame.size.height -= 20
        logTableView.frame = viewFrame
        self.view.addSubview(logTableView)
        logTableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "LogCell")
        logTableView.dataSource = self
        
        logTableView.delegate = self
        
        /*
        println(managedObjectContext)
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("LogItem", inManagedObjectContext: self.managedObjectContext!) as LogItem
        newItem.title = "Wrote core data tuto"
        newItem.itemText = "new tuto about core data"
        */
        
       // presentFirstItem()
        // Do any additional setup after loading the view, typically from a nib.
        fetchLog()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let logItem = logItems[indexPath.row]
        println(logItem.itemText)
    }
    
    func fetchLog(){
        let fetchRequest = NSFetchRequest(entityName: "LogItem")
        let sortDescriptor  = NSSortDescriptor(key: "title", ascending:true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "title == %@", "item 1")
        
        let thpredicate = NSPredicate(format: "title contains %@", "em")
        
        let finalPredicate = NSCompoundPredicate(type: NSCompoundPredicateType.OrPredicateType, subpredicates: [predicate!, thpredicate!])
        fetchRequest.predicate = finalPredicate
        
        
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [LogItem]{
            logItems = fetchResults
        }
    }
    
    override func viewDidAppear(animated: Bool) {
       // presentFirstItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


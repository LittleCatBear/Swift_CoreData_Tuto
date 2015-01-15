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
    
    let addItemAlertViewTag = 0
    let addItemTextAlertViewTag = 1
    
    func addNewItem(){
        
        var titlePrompt = UIAlertController(title: "enter title", message: "enter text", preferredStyle: .Alert)
        
        var titleTextField: UITextField?
        titlePrompt.addTextFieldWithConfigurationHandler{
            (textField) -> Void in titleTextField = textField
            textField.placeholder = "Title"
        }
        
        titlePrompt.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            if let textField = titleTextField{
                self.saveNewItem(textField.text)
            }
        }))
        
        self.presentViewController(titlePrompt, animated: true, completion: nil)
    }
    
    func saveNewItem(title: String){
        
        var newLogItem = LogItem.createInManagedObjectContext(self.managedObjectContext!, title: title, fullTitle: "full title ok", text: "")
        
        self.fetchLog()
        
        if let newItemIndex = find(logItems, newLogItem){
            let newLogItemIndexPath = NSIndexPath(forRow: newItemIndex, inSection: 0)
            logTableView.insertRowsAtIndexPaths([newLogItemIndexPath], withRowAnimation: .Automatic)
            save()
        }
    }
    
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
        
        /*
        if let moc = self.managedObjectContext {
            
            LogItem.createInManagedObjectContext(moc, title: "item 1", text: "the first item")
            LogItem.createInManagedObjectContext(moc, title: "item 2", text: "the second item")
            LogItem.createInManagedObjectContext(moc, title: "item 3", text: "the third item")
        }
        */
        var viewFrame = self.view.frame
        viewFrame.origin.y += 20
        
        let addButton = UIButton(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 44, UIScreen.mainScreen().bounds.size.width, 44))
        addButton.setTitle("+", forState: .Normal)
        addButton.backgroundColor = UIColor(red: 0.5, green: 0.9, blue: 0.5, alpha: 1.0)
        addButton.addTarget(self, action: "addNewItem", forControlEvents: .TouchUpInside)
        self.view.addSubview(addButton)
        
        viewFrame.size.height -= (20 + addButton.frame.size.height)
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
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    //needed for swipe to delete action
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete){
            let logItemToDelete = logItems[indexPath.row]
            
            managedObjectContext?.deleteObject(logItemToDelete)
            self.fetchLog()
            
            logTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            save()
        }
    }
    
    func fetchLog(){
        let fetchRequest = NSFetchRequest(entityName: "LogItem")
        let sortDescriptor  = NSSortDescriptor(key: "title", ascending:true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        /*
        let predicate = NSPredicate(format: "title == %@", "item 1")
        let thpredicate = NSPredicate(format: "title contains %@", "em")
        let finalPredicate = NSCompoundPredicate(type: NSCompoundPredicateType.OrPredicateType, subpredicates: [predicate!, thpredicate!])
        fetchRequest.predicate = finalPredicate
        */
        
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [LogItem]{
            logItems = fetchResults
        }
    }
    
    func save(){
        var error : NSError?
        if managedObjectContext!.save(&error){
            println(error?.localizedDescription)
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


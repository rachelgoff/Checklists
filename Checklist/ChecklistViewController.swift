//
//  ViewController.swift
//  Checklist
//
//  Created by Rachel Goff on 3/21/16.
//  Copyright © 2016 Rachel Goff. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var checklist: Checklist!
    
    /*
    var row0text = "Walk the dog if we have"
    var row1text = "Take a shower"
    var row2text = "Learn Swift programming"
    var row3text = "Watch House of Cards Season 4"
    //var row3text = "Watch House of Cards Season 4 Watch House of Cards Season 4 Watch House of Cards Season 4 Watch House of Cards Season 4"
    var row4text = "Cook dinner at home"
    
    var row0checked = false
    var row1checked = false
    var row2checked = false
    var row3checked = false
    var row4checked = false */
    
    
  /*var items: [ChecklistItem]
    /*Declare a sigle array variable called items. 
    Remeber ChecklistItem serves a purpose to combine text and checked flag into one object.
    This declared that items will hold an array of ChecklistItem objects. 
    But it doesn't actually create the array. 
    At this point items doesn't have any value yet.*/
    
    required init?(coder aDecoder: NSCoder){
        items = [ChecklistItem]()
        
        /*[ChecklistItem] means an array of ChecklistItem objects. This is to construct an array object.
        This instantiates the array.
        Now items contains a valid array object. 
        But the array has no ChecklistItem objects inside it yet.*/

       /* let row0item = ChecklistItem()
        row0item.text = "Walk the dog"
        row0item.checked = false
        items.append(row0item)
        
        let row1item = ChecklistItem()
        row1item.text = "Take a shower"
        row1item.checked = false
        items.append(row1item)
        
        let row2item = ChecklistItem()
        row2item.text = "Learn Swift Programming"
        row2item.checked = false
        items.append(row2item)
        
        let row3item = ChecklistItem()
        row3item.text = "Watch House of Cards"
        row3item.checked = false
        items.append(row3item)
        
        let row4item = ChecklistItem()
        row4item.text = "Cook dinner at home"
        row4item.checked = false
        items.append(row4item)*/
        
        
        super.init(coder: aDecoder)
        loadChecklistItems()
        
        print("Directory is \(documentDirectory())")
        
        print("File path is \(dataFilePath())")
        
    }*/

    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    /*override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem", forIndexPath: indexPath)
        let lable = cell.viewWithTag(1000) as! UILabel
        if indexPath.row % 5 == 0 {
            lable.text = "Walk the dog"
        } else if indexPath.row % 5 == 1{
            lable.text = "Take shower"
        } else if indexPath.row % 5 == 2{
            lable.text = "Learn Swift programming"
        } else if indexPath.row % 5 == 3{
            lable.text = "Watch House of Cards"
        } else if indexPath.row % 5 == 4{
            lable.text = "Cook dinner"
        }
        return cell
    }
    */
    
    /*func configureCheckmarkForCell(cell:UITableViewCell, indexPath: NSIndexPath){
        var isChecked = false
        
        if indexPath.row == 0{
            isChecked = row0item.checked
        } else if indexPath.row == 1{
            isChecked = row1item.checked
        } else if indexPath.row == 2{
            isChecked = row2item.checked
        } else if indexPath.row == 3{
            isChecked = row3item.checked
        } else if indexPath.row == 4{
            isChecked = row4item.checked
        }
        if isChecked{
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
    }*/
    
    //func configureCheckmarkForCell(cell:UITableViewCell, indexPath: NSIndexPath){
    func configureCheckmarkForCell(cell:UITableViewCell, withChecklistItem item: ChecklistItem) {
        
       let label = cell.viewWithTag(1001) as! UILabel
       // let item = checklist.items[indexPath.row]
        
        if item.checked {
            //cell.accessoryType = .Checkmark
            label.text = "√"
            
        } else {
            //cell.accessoryType = .None
            label.text = ""
        }
        
          label.textColor = view.tintColor
    }
    
    
    func configureTextForCell(cell:UITableViewCell, withChecklistItem item: ChecklistItem){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
        
        //label.text = "\(item.itemID): \(item.text)"
      
    }

    
    /*override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem", forIndexPath: indexPath)
        let lable = cell.viewWithTag(1000) as! UILabel
        if indexPath.row == 0{
            lable.text = row0item.text
        } else if indexPath.row == 1{
            lable.text = row1item.text
        } else if indexPath.row == 2{
            lable.text = row2item.text
        } else if indexPath.row == 3{
            lable.text = row3item.text
        } else if indexPath.row == 4{
            lable.text = row4item.text
        }
        configureCheckmarkForCell(cell, indexPath: indexPath)
        return cell
        
    }*/
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem", forIndexPath: indexPath)
        //let lable = cell.viewWithTag(1000) as! UILabel
        let item = checklist.items[indexPath.row]
        
        //lable.text = item.text
        configureTextForCell(cell, withChecklistItem: item)
        //configureCheckmarkForCell(cell, indexPath: indexPath)
        
        configureCheckmarkForCell(cell, withChecklistItem: item)
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        checklist.items.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        //saveChecklistItems()
        
    }
    
    /*override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
        if cell.accessoryType == .None {
            cell.accessoryType = .Checkmark
        } else{
            cell.accessoryType = .None}
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }*/
    
    /*override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
        if indexPath.row == 0 {
            row0checked = !row0checked
            if row0checked{
                cell.accessoryType = .Checkmark
            } else {cell.accessoryType = .None}
        }else if indexPath.row == 1{
            row1checked = !row1checked
            if row1checked{
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
        } else if indexPath.row == 2{
            row2checked = !row2checked
            if row2checked{
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
        } else if indexPath.row == 3{
            row3checked = !row3checked
            if row3checked{
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
        }else if indexPath.row == 4{
            row4checked = !row4checked
            if row4checked{
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
            }
            
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

    }*/
    
    /*override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
           // var isChecked = false
            
            if indexPath.row == 0{
                row0checked = !row0checked
               // isChecked = row0checked
            } else if indexPath.row == 1{
                row1checked = !row1checked
              //  isChecked = row1checked
            } else if indexPath.row == 2{
                row2checked = !row2checked
               // isChecked = row2checked
            } else if indexPath.row == 3{
                row3checked = !row3checked
             //   isChecked = row3checked
            } else if indexPath.row == 4{
                row4checked = !row4checked
            //    isChecked = row4checked
            }
            
           /* if isChecked{
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
        }*/
            configureCheckmarkForCell(cell, indexPath: indexPath)
    }
    
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    }*/
    
 
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
            let item = checklist.items[indexPath.row]
            //item.checked = !item.checked
            item.toggleChecked()
            configureCheckmarkForCell(cell, withChecklistItem: item)
            //configureCheckmarkForCell(cell, indexPath: indexPath)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //saveChecklistItems()
    }
    
   /* @IBAction func addItem(){
        let newRowIndex = items.count
        
        let item = ChecklistItem()
        item.text = "Read a book"
        item.checked = false
        items.append(item)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    
    }*/
    
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem){
        let newRowIndex = checklist.items.count
        
        checklist.items.append(item)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        dismissViewControllerAnimated(true, completion: nil)
        //saveChecklistItems()
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem){
        if let index = checklist.items.indexOf(item) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath){
            configureTextForCell(cell, withChecklistItem: item)
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
        //saveChecklistItems()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "AddItem"{
            let navigationController = segue.destinationViewController as! UINavigationController
            
            let controller = navigationController.topViewController as! ItemDetailViewController
            
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            
            controller.delegate = self
            
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell){
            controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    /*func documentDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return((documentDirectory() as NSString).stringByAppendingPathComponent("Checklist.plist"))
    }
    
    func saveChecklistItems(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        
        archiver.encodeObject(items, forKey: "ChecklistItems")
        archiver.finishEncoding()
        
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadChecklistItems(){
        let path = dataFilePath()
        
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            
            if let data = NSData(contentsOfFile: path) {
                
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                items = unarchiver.decodeObjectForKey("ChecklistItems") as! [ChecklistItem]
            //items = unarchiver.decodeObjectForKey("Checklistitems") as! [ChecklistItem]
            
            unarchiver.finishDecoding()
           }
        }
    }*/
    

}


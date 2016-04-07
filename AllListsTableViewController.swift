//
//  AllListsTableViewController.swift
//  Checklist
//
//  Created by Rachel Goff on 3/27/16.
//  Copyright © 2016 Rachel Goff. All rights reserved.
//

import UIKit

class AllListsTableViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    //var lists: [Checklist]
    
    /*required init?(coder aDecoder: NSCoder){
        
        lists = [Checklist]()
        
        super.init(coder: aDecoder)
        /*var list = Checklist(name: "Birthday party")
        lists.append(list)
        
        list = Checklist(name: "Wash the dog")
        lists.append(list)
        
        list = Checklist(name:"Read a book")
        lists.append(list)
        
       list = Checklist (name: "Shopping")
        lists.append(list)
        
       list = Checklist (name: "Running")
        lists.append(list)

        
        for list in lists{
            let item = ChecklistItem()
            item.text = "Item for \(list.name)"
            list.items.append(item)
        }*/
 
        loadChecklists()
        
        
    }*/
    
    var dataModel: DataModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.lists.count
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        let cell = cellForTableView(tableView)
        
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .DetailDisclosureButton
        
        let count = checklist.countUncheckedItem()
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "(No Items)"
        } else if count == 0 {
            cell.detailTextLabel!.text = "All done"
        } else {
            cell.detailTextLabel!.text = "\(count) remaining"
        }
        //cell.detailTextLabel!.text = "\(checklist.countUncheckedItem()) remaining"
        
        // Configure the cell...
        
        cell.imageView!.image = UIImage(named: checklist.iconName)
        return cell
    }
    
    
    func cellForTableView(tableView: UITableView) -> UITableViewCell{
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier){
            return cell
        } else {
            //return UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
            return UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }
    }
    
    func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist checklist: Checklist) {
       // let newRowIndex = dataModel.lists.count
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        
        //let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
       // let indexPaths = [indexPath]
        //tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        tableView.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist checklist: Checklist){
        /*if let index = dataModel.lists.indexOf(checklist){
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath){
                cell.textLabel!.text = checklist.name
            }
        }*/
        
        dataModel.sortChecklists()
        tableView.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "ChecklistIndex")
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
        performSegueWithIdentifier("ShowChecklist", sender: checklist)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.lists.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ListDetailNavigationController") as! UINavigationController
        
        let controller = navigationController.topViewController as! ListDetailViewController
        
        controller.delegate = self
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        presentViewController(navigationController, animated: true, completion: nil)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destinationViewController as! ChecklistViewController
            controller.checklist = sender as! Checklist
        } else if segue.identifier == "AddChecklist" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            
            controller.delegate = self
            controller.checklistToEdit = nil
        }
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if viewController === self {
            //NSUserDefaults.standardUserDefaults().setInteger(-1, forKey: "ChecklistIndex")
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        
        //let index = NSUserDefaults.standardUserDefaults().integerForKey("ChecklistIndex")
        let index = dataModel.indexOfSelectedChecklist
        
        
        //if index != -1 {
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegueWithIdentifier("ShowChecklist", sender: checklist)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


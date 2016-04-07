//
//  DataModel.swift
//  Checklist
//
//  Created by Rachel on 4/1/16.
//  Copyright © 2016 Rachel Goff. All rights reserved.
//

import Foundation

class DataModel {
    
        
    var lists = [Checklist]()
    
    func documentDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return((documentDirectory() as NSString).stringByAppendingPathComponent("Checklist.plist"))
    }
    
    func saveChecklists(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        
        archiver.encodeObject(lists, forKey: "Checklists")
        archiver.finishEncoding()
        
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadChecklists(){
        let path = dataFilePath()
        
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            
            if let data = NSData(contentsOfFile: path) {
                
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                lists = unarchiver.decodeObjectForKey("Checklists") as! [Checklist]
                //items = unarchiver.decodeObjectForKey("Checklistitems") as! [ChecklistItem]
                
                unarchiver.finishDecoding()
            }
        }
        sortChecklists()
    }
    
    func registerDefaults(){
        //let dictionary = ["ChecklistIndex": -1]
        let dictionary = ["ChecklistIndex": -1, "FirstTime": true, "ChecklistItemID": 0]
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
    }
    
    init(){
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    var indexOfSelectedChecklist: Int {
        get{
            return NSUserDefaults.standardUserDefaults().integerForKey("ChecklistIndex")
            
        }
        
        set{
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "ChecklistIndex")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func handleFirstTime() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let firstTime = userDefaults.boolForKey("FirstTime")
        if firstTime {
            let checklist = Checklist (name: "List")
            lists.append(checklist)
            indexOfSelectedChecklist = 0
            userDefaults.setBool(false, forKey: "FirstTime")
            userDefaults.synchronize()
            
        }
    }
    
    func sortChecklists(){
        lists.sortInPlace({checklist1, checklist2 in return checklist1.name.localizedStandardCompare(checklist2.name) == .OrderedAscending})
        
        //lists.sortInPlace(<#T##isOrderedBefore: (Checklist, Checklist) -> Bool##(Checklist, Checklist) -> Bool#>)
    }
    
    class func nextChecklistItemID() -> Int {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let itemID = userDefaults.integerForKey("ChecklistItemID")
        userDefaults.setInteger(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        return itemID
    }

    
}

//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Rachel Goff on 3/22/16.
//  Copyright © 2016 Rachel Goff. All rights reserved.
//

import Foundation
import UIKit

//ChecklistItem serves the purpose to combine text and checked (instance variables/property) into one object

class ChecklistItem: NSObject, NSCoding {
    var text = ""
    var checked = false
    
    var dueDate = NSDate()
    var shouldRemind = false
    var itemID: Int
    
    func toggleChecked(){
        checked = !checked
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(checked, forKey: "Checked")
        aCoder.encodeObject(dueDate, forKey: "DueDate")
        aCoder.encodeBool(shouldRemind, forKey: "ShouldRemind")
        aCoder.encodeInteger(itemID, forKey: "ItemID")
        
    }
    
    required init?(coder aDecoder: NSCoder){
        text = aDecoder.decodeObjectForKey("Text") as! String
        checked = aDecoder.decodeBoolForKey("Checked")
        dueDate = aDecoder.decodeObjectForKey("DueDate") as! NSDate
        shouldRemind = aDecoder.decodeBoolForKey("ShouldRemind")
        itemID = aDecoder.decodeIntegerForKey("ItemID")
            
        super.init()
    }
    
    override init() {
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    func scheduleNotification() {
        let existingNotification = notificationForThisItem()
        if let notification = existingNotification{
            print ("Found an existing notification:\(notification)")
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
        
        
        if shouldRemind && dueDate.compare(NSDate()) != .OrderedAscending {
            
            let localNotification = UILocalNotification()
            localNotification.fireDate = dueDate
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.alertBody = text
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.userInfo = ["ItemID": itemID]
            
            //UIApplication.sharedApplication().scheduledLocalNotification(localNotification)
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            
            
            print ("Schedule notification \(localNotification) for itemID \(itemID)")
        }
    }
    
    func notificationForThisItem() -> UILocalNotification? {
        let allNotifications = UIApplication.sharedApplication().scheduledLocalNotifications!
        
        for notification in allNotifications {
            if let number = notification.userInfo?["ItemID"] as? Int where number == itemID {
                return notification
            }
        }
        
        return nil
    }
    
    deinit {
        
        if let notification = notificationForThisItem(){
            //print("Removing existing notification \(notification)")
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
    }
    
}

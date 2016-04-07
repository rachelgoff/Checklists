//
//  Checklist.swift
//  Checklist
//
//  Created by Rachel on 3/30/16.
//  Copyright © 2016 Rachel Goff. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    var name = ""
    var items = [ChecklistItem]()
    var iconName: String
    
    init(name: String){
        self.name = name
        //self.iconName = iconName
        iconName = "No Icon"
        super.init()
    }
    
    init(name: String, iconName: String){
        self.name = name
        self.iconName = iconName
        super.init()
    }

    
    required init?(coder aDecoder: NSCoder){
        name = aDecoder.decodeObjectForKey("Name") as! String
        items = aDecoder.decodeObjectForKey("Items") as! [ChecklistItem]
        iconName = aDecoder.decodeObjectForKey("IconName") as! String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "Name")
        aCoder.encodeObject(items, forKey: "Items")
        aCoder.encodeObject(iconName,forKey: "IconName")
    }
    
    func countUncheckedItem() -> Int{
        var count = 0
        
        for item in items where !item.checked {
            count+=1
        }
        return count
    }
    

    }


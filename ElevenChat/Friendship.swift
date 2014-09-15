//
//  Friendship.swift
//  ElevenChat
//
//  Created by Cameron Dershem on 9/12/14.
//  Copyright (c) 2014 Cameron Dershem. All rights reserved.
//

import Foundation


class Friendship : PFObject, PFSubclassing {
    
    override class func load() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "Friendship"
    }
    
    var currentUser: ChatUser? {
        get { return objectForKey("currentUser") as? ChatUser }
        set { setObject(newValue, forKey: "currentUser") }
    }
    
    var theFriend: ChatUser? {
        get { return objectForKey("theFriend") as? ChatUser }
        set { setObject(newValue, forKey: "theFriend") }
    }
    
    var selected = false
}
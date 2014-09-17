//
//  ChatPicture.swift
//  ElevenChat
//
//  Created by Cameron Dershem on 9/12/14.
//  Copyright (c) 2014 Cameron Dershem. All rights reserved.
//

import Foundation

class ChatPicture : PFObject, PFSubclassing {
    
    override class func load() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "ChatPicture"
    }
    
    var fromUser: ChatUser? {
        get { return objectForKey("fromUser") as? ChatUser }
        set { setObject(newValue, forKey: "fromUser") }
    }
    
    var toUser: ChatUser? {
        get { return objectForKey("toUser") as? ChatUser }
        set { setObject(newValue, forKey: "toUser") }
    }
    
    var image: PFFile? {
        get { return objectForKey("image") as? PFFile }
        set { setObject(newValue, forKey: "image") }
    }
    
    
    
}
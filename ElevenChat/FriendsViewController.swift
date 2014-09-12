//
//  FriendsViewController.swift
//  ElevenChat
//
//  Created by Cameron Dershem on 9/12/14.
//  Copyright (c) 2014 Cameron Dershem. All rights reserved.
//

import Foundation

class FriendsViewController : PFQueryTableViewController {
    // get stuff, return count, display stuff
    // PFQueryViewController is a subclass of TableViewController from Parse SDK
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        self.parseClassName = Friendship.parseClassName()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.parseClassName = Friendship.parseClassName()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fixes annoying UI bug
        self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
    }
    
    override func queryForTable() -> PFQuery! {
        var query : PFQuery!
        
        query = Friendship.query()
        query.whereKey("currentUser", equalTo: ChatUser.currentUser())
        query.includeKey("theFriend")
        
        
        return query
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("PFTableViewCell") as PFTableViewCell?
        
        if cell == nil {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "PFTableViewCell")
        }
        
        if object is Friendship {
            var friends = object as Friendship
            
            cell?.textLabel?.text = friends.theFriend?.username
        }
        
        return cell
    }
}
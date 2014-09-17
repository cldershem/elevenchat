//
//  MessagesViewController.swift
//  ElevenChat
//
//  Created by Cameron Dershem on 9/16/14.
//  Copyright (c) 2014 Cameron Dershem. All rights reserved.
//

import UIKit

class MessagesViewController: PFQueryTableViewController {
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        self.parseClassName = ChatPicture.parseClassName()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.parseClassName = ChatPicture.parseClassName()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fix annoying UI Bug
        self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
    }
    
    override func queryForTable() -> PFQuery! {
        var query = ChatPicture.query()
        query.whereKey("toUser", equalTo:ChatUser.currentUser())
        query.includeKey("fromUser")
        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("PFTableViewCell") as? PFTableViewCell
        
        if cell == nil {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "PFTableViewCell")
            cell?.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        }
        
        // Magic happens here
        var message = object as ChatPicture
        cell?.textLabel?.text = message.fromUser?.username
        cell?.imageView?.file = message.image
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
}
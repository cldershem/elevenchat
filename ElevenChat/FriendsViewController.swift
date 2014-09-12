//
//  FriendsViewController.swift
//  ElevenChat
//
//  Created by Cameron Dershem on 9/12/14.
//  Copyright (c) 2014 Cameron Dershem. All rights reserved.
//

import Foundation

class FriendsViewController : PFQueryTableViewController, UISearchBarDelegate {
    // get stuff, return count, display stuff
    // PFQueryViewController is a subclass of TableViewController from Parse SDK
    
    var searchText = ""
    
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
    
    // MARK: tableView
    
    override func queryForTable() -> PFQuery! {
        var query : PFQuery!
        
        if searchText.isEmpty {
            query = Friendship.query()
            query.whereKey("currentUser", equalTo: ChatUser.currentUser())
            query.includeKey("theFriend")
        } else {
            // username search
            var userNameSearch = ChatUser.query()
            userNameSearch.whereKey("username", containsString: searchText)
            
            // email search
            var emailSearch = ChatUser.query()
            emailSearch.whereKey("email", equalTo: searchText)
            
            // phone number search
            var additionalSearch = ChatUser.query()
            additionalSearch.whereKey("additional", equalTo: searchText)
            
            // or them together
            query = PFQuery.orQueryWithSubqueries([userNameSearch, emailSearch, additionalSearch])
        }
        
        
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
        } else if object is ChatUser {
            var user = object as ChatUser
            
            cell?.textLabel?.text = user.username
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as UITableViewCell
        
        return headerCell as UIView
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // get the object
        var selectedObject = self.objectAtIndexPath(indexPath)
        if selectedObject is ChatUser {
            // probably *should* have a confirmation box...
            self.addFriend(selectedObject as ChatUser)
        }
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: Add friend
    func addFriend(friend:ChatUser) {
//        var areFriends = PFQuery(className: self.parseClassName)
        var areFriends = Friendship.query()
        areFriends.whereKey("currentUser", equalTo: ChatUser.currentUser())
        areFriends.whereKey("theFriend", equalTo: friend)
        areFriends.countObjectsInBackgroundWithBlock { (count, _) -> Void in
            if count > 0 {
                // already friends
                println("Not adding, already friends.")
            } else {
                // add friend
                var bff = Friendship()
                bff.currentUser = ChatUser.currentUser()
                bff.theFriend = friend
                bff.saveInBackground()
                println("adding \(bff.currentUser!.username) -> \(bff.theFriend!.username)")
            }
        }
    }
    
    // MARK: Search Bar
    // delegate in story board
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // add minimum length of search
        searchText = searchBar.text
        self.loadObjects()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        // clear out search box
        searchBar.text = nil
        // clear out search variable
        searchText = ""
        // reload the table
        self.loadObjects()
        // hide keyboard
        searchBar.resignFirstResponder()
    }
    
    
    
    
}









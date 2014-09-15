//
//  FriendCell.swift
//  ElevenChat
//
//  Created by Cameron Dershem on 9/12/14.
//  Copyright (c) 2014 Cameron Dershem. All rights reserved.
//

import UIKit

class FriendCell : PFTableViewCell {
    
    @IBOutlet weak var checkBox: UIImageView!
    var theFriendship : Friendship?
    
    func setupCell(friends: Friendship) {
        println("FriendCell.setupCell called")
        theFriendship = friends
        self.textLabel?.text = friends.theFriend?.username
    }
    
    @IBAction func checkBoxTapped(button: UIButton) {
        theFriendship!.selected = !theFriendship!.selected
        var imageName = theFriendship!.selected ? "checkbox_checked" : "checkbox_unchecked"
        checkBox.image = UIImage(named: imageName)
    }
}

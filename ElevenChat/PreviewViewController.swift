//
//  PreviewViewController.swift
//  ElevenChat
//
//  Created by Cameron Dershem on 9/12/14.
//  Copyright (c) 2014 Cameron Dershem. All rights reserved.
//

import UIKit

class PreviewViewController : UIViewController {
    
    @IBOutlet weak var imagePreview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let (_, fullFileName) = CameraViewController.getSnapFileName()
        imagePreview.image = UIImage(contentsOfFile: fullFileName)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is FriendsViewController {
            var friendsVC = segue.destinationViewController as FriendsViewController
            friendsVC.selectFriendMode = true
        }
    }
}
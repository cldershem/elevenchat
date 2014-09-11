//
//  ViewController.swift
//  ElevenChat
//
//  Created by Cameron Dershem on 9/10/14.
//  Copyright (c) 2014 Cameron Dershem. All rights reserved.
//

import UIKit

class RootViewController: UIPageViewController, UIPageViewControllerDataSource {

    var pinkViewController : PinkViewController!
    var cameraViewController : CameraViewController!
    var blueViewController : BlueViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set UIPageViewControllerDataSource
        self.dataSource = self
        
        // Reference all of the view controllers on the storyboard
        self.pinkViewController = self.storyboard?.instantiateViewControllerWithIdentifier("pinkViewController") as? PinkViewController
        self.pinkViewController.title = "Pink"
        println("Pink!")
        
        self.cameraViewController = self.storyboard?.instantiateViewControllerWithIdentifier("cameraViewController") as? CameraViewController
        self.cameraViewController.title = "Camera"
        println("Camera!")
            
        self.blueViewController = self.storyboard?.instantiateViewControllerWithIdentifier("blueViewController") as? BlueViewController
        self.blueViewController.title = "Blue"
        println("Blue!")
        
        // Set starting view controllers
        var startingViewControllers : NSArray = [self.cameraViewController]
        self.setViewControllers(startingViewControllers, direction: .Forward, animated: false, completion: nil)
        println("Captain Planet!")
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        switch viewController.title! {
        case "Pink":
            return nil
        case "Camera":
            return pinkViewController
        case "Blue":
            return cameraViewController
        default:
            return nil
        }
    }
    
    // pink green blue
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        switch viewController.title! {
        case "Pink":
            return cameraViewController
        case "Camera":
            return blueViewController
        case "Blue":
            return nil
        default:
            return nil
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
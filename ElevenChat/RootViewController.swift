//
//  ViewController.swift
//  ElevenChat
//
//  Created by Cameron Dershem on 9/10/14.
//  Copyright (c) 2014 Cameron Dershem. All rights reserved.
//

import UIKit

class RootViewController: UIPageViewController, UIPageViewControllerDataSource,
    PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    var messagesViewController : MessagesViewController!
    var cameraViewController : CameraViewController!
    var friendsViewController : FriendsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set UIPageViewControllerDataSource
        self.dataSource = self
        
        // Reference all of the view controllers on the storyboard
        self.messagesViewController = self.storyboard?.instantiateViewControllerWithIdentifier("messagesViewController") as? MessagesViewController
        self.messagesViewController.title = "Messages"
        println("Messages!")
        
        self.cameraViewController = self.storyboard?.instantiateViewControllerWithIdentifier("cameraViewController") as? CameraViewController
        self.cameraViewController.title = "Camera"
        println("Camera!")
            
        self.friendsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("friendsViewController") as? FriendsViewController
        self.friendsViewController.title = "Friends"
        println("Friends!")
        
        // Set starting view controllers
        var startingViewControllers : NSArray = [self.cameraViewController]
        self.setViewControllers(startingViewControllers, direction: .Forward, animated: false, completion: nil)
        println("Captain Planet!")
    }
    
   override func viewDidAppear(animated: Bool) {
        self.checkAuth()
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        switch viewController.title! {
        case "Messages":
            return nil
        case "Camera":
            return messagesViewController
        case "Friends":
            return cameraViewController
        default:
            return nil
        }
    }
    
    // pink green blue
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        switch viewController.title! {
        case "Messages":
            return cameraViewController
        case "Camera":
            return friendsViewController
        case "Friends":
            return nil
        default:
            return nil
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkAuth() {
        // check if logged in
        if ChatUser.currentUser() == nil {
           
            // 1: create and show login controller
            var loginViewController = PFLogInViewController()
            loginViewController.delegate = self
            
            // 2: Hide cancel button
            loginViewController.fields = PFLogInFields.UsernameAndPassword
                | PFLogInFields.LogInButton
                | PFLogInFields.SignUpButton
                | PFLogInFields.PasswordForgotten
            
            // 3: Customize Logo
            var logo = UIImage(named: "Logo")
            loginViewController.logInView.logo = UIImageView(image: logo)
            
            // 4: create sign up view contorller
            var signUpViewController = PFSignUpViewController()
            signUpViewController.fields = PFSignUpFields.UsernameAndPassword
                | PFSignUpFields.Email
                | PFSignUpFields.Additional
                | PFSignUpFields.SignUpButton
                | PFSignUpFields.DismissButton
            signUpViewController.delegate = self
            
            // 5: customize logo
            signUpViewController.signUpView.logo = UIImageView(image: logo)
            
            // 6: "Repurpose" the additional field as our phone number signup field
            var signupColor = UIColor.lightGrayColor()
            var additionalFieldText = NSAttributedString(string: "Phone Number", attributes: [NSForegroundColorAttributeName: signupColor])
            signUpViewController.signUpView.additionalField.attributedPlaceholder = additionalFieldText
            
            // 7: Assign our signup controller to be displayed from the login controller
            loginViewController.signUpController = signUpViewController
            
            // 8: Present the login view controller
            self.presentViewController(loginViewController, animated: true, completion: nil)
        }
    }
    
    func logInViewController(logInController: PFLogInViewController!, shouldBeginLogInWithUsername username: String!, password: String!) -> Bool {
        
        if username != nil && password != nil && countElements(username) != 0 && countElements(password) != 0 {
            return true // Begin login process
        }
        
        if let ios8Alert: AnyClass = NSClassFromString("UIAlertController") {
            
            var alert = UIAlertController(title: "Error", message: "Username and Password are required!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertView(title: "Error", message: "Username and Password are required!", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
        return false
        
    }
    
    // this also sets ChatUser()
    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController!, didFailToLogInWithError error: NSError!) {
        
        if let ios8Alert: AnyClass = NSClassFromString("UIAlertController") {
            
            var alert = UIAlertController(title: "Login Failed", message: "Login Failed", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertView(title: "Login Failed", message: "Please check your username and password", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, didSignUpUser user: PFUser!) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, shouldBeginSignUp info: [NSObject : AnyObject]!) -> Bool {
        
        var eInfo = info as NSDictionary
        var infoComplete = true
        
        for (key,val) in eInfo {
            if let field = eInfo.objectForKey(key) as? NSString {
                if field.length == 0 {
                    infoComplete = false
                    break
                }
            }
        }
        
        if !infoComplete {
            if let ios8Alert: AnyClass = NSClassFromString("UIAlertController") {
                
                var alert = UIAlertController(title: "Signup Failed", message: "All fields are required", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertView(title: "Signup Failed", message: "All fields are required", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
        }
        
        return infoComplete
    }
    
    
    
    
    
    
    
    
    
    
}
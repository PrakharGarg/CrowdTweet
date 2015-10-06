//
//  ProfilePageViewController.swift
//  Crowd Tweet
//
//  Created by Prakhar Garg on 9/19/15.
//  Copyright (c) 2015 Prakhar Garg. All rights reserved.
//
// Page that shows the user's tweets that are under construction. 
// Allows the user to sign-out. 



import UIKit
import TwitterKit

class ProfilePageViewController: UIViewController {
    

    @IBAction func SignOutButton(sender: AnyObject) {
        Twitter.sharedInstance().logOut()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


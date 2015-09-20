//
//  ViewController.swift
//  Crowd Tweet
//
//  Created by Prakhar Garg on 9/19/15.
//  Copyright (c) 2015 Prakhar Garg. All rights reserved.
//

import UIKit
import TwitterKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (Twitter.sharedInstance().session() == nil)
        {
            let logInButton = TWTRLogInButton { (session, error) in
                if (Twitter.sharedInstance().session() != nil)
                {
                    self.performSegueWithIdentifier("SignInToMainSegue", sender: self)
                }
            }
            
            logInButton.translatesAutoresizingMaskIntoConstraints = false
            let centerXConstraint = NSLayoutConstraint(item: logInButton, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0);
            let centerYConstraint = NSLayoutConstraint(item: logInButton, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0);
            
            self.view.addSubview(logInButton)
            self.view.addConstraints([centerXConstraint, centerYConstraint])
            
        }
        else
        {
            self.performSegueWithIdentifier("SignInToMainSegue", sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


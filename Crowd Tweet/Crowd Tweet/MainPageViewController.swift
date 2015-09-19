//
//  MainPageViewController.swift
//  Crowd Tweet
//
//  Created by Prakhar Garg on 9/19/15.
//  Copyright (c) 2015 Prakhar Garg. All rights reserved.
//

import UIKit
import TwitterKit
import Parse

class MainPageViewController: UIViewController {
    
    // Label that contains an already started Tweet
    @IBOutlet var preExistingTweet: UILabel!
    
    // TextField to enter in part of a Tweet
    @IBOutlet var tweetTextField: UITextField!
    
    @IBAction func submitTweet(sender: AnyObject) {
        
        if preExistingTweet.text != "" {
            var tweets = PFObject(className:"Tweets")
            tweets.setValue(preExistingTweet.text! + " " + tweetTextField.text, forKey: "tweet")
//            tweets["tweet"] = "test"
            tweets.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
        
            //stuff
            })
        }
        else
        {
            var tweets = PFObject(className:"Tweets")
            tweets.setValue(tweetTextField.text, forKey: "tweet")
            //            tweets["tweet"] = "test"
            tweets.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                } else {
                    // There was a problem, check error.description
                }

            })
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

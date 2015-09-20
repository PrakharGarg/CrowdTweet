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
    
    var preExistingTweetParseID: String = ""
    
    var usingUnfinishedTweet = false
    
    @IBAction func submitTweet(sender: AnyObject) {
        
        // If contributing to someone else's tweet
        if preExistingTweet.text != "" {
            // stores it in Parse database
            let tweets = PFObject(className:"Tweets")
            
            // Store tweet and Twitter handle
            
            let query = PFQuery(className:"Tweets")
            let newTweet = self.preExistingTweet.text! + " " + self.tweetTextField.text!

            query.getObjectInBackgroundWithId(self.preExistingTweetParseID) {
                (tweetID: PFObject?, error: NSError?) -> Void in
                print(tweetID)
                if error != nil {
                    print(error)
                }
                else if let tweetID = tweetID {

                    tweetID["tweet"] = newTweet
                    tweetID.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            // The object has been saved.
                        } else {
                            // There was a problem, check error.description
                        }
                        
                    })

                }
            }
          
        }
            
        // If making a new tweet
        else
        {
            let tweets = PFObject(className:"Tweets")
            
            // Store tweet and Twitter handle
            tweets.setObject(tweetTextField.text!, forKey: "tweet")
            tweets.setValue(Twitter.sharedInstance().session()?.userName, forKey: "handle")
            
            tweets.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                } else {
                    // There was a problem, check error.description
                }

            })
            usingUnfinishedTweet = true

        }
        self.preExistingTweet.text = ""
        self.tweetTextField.text = ""
        
    }
    
    @IBAction func getAPrexistingTweet(sender: AnyObject) {
    
        // Get a tweet from database
        let query = PFQuery(className:"Tweets")
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                print("The getFirstObject request failed.")
            } else {
                // The find succeeded.
                print("Successfully retrieved the object.")
                let tweetToEdit = object?.objectForKey("tweet") as! String
                self.preExistingTweet.text = tweetToEdit
                self.preExistingTweetParseID = (object?.objectId)!
            }
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

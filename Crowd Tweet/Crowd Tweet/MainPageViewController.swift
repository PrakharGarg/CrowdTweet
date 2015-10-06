//
//  MainPageViewController.swift
//  Crowd Tweet
//
//  Created by Prakhar Garg on 9/19/15.
//  Copyright (c) 2015 Prakhar Garg. All rights reserved.
//


// Main ViewController of the app. Allows the user to choose between contributing to an already existing Tweet or starting a new tweet.
// The user is given 40 characters to type. 
// The view controller consists of a label to display pre-existing tweets, a field to type in text, a label with the character count, and a submit button.

import UIKit
import TwitterKit
import Parse
import GameplayKit;

class MainPageViewController: UIViewController, UITextFieldDelegate {
    
    // Label that contains an already started Tweet
    @IBOutlet var preExistingTweet: UILabel!
    
    // The indicator is by default hidden until the user asks for a pre-existing tweet. The indicator will show that a tweet is being fetched.
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // TextField to enter in 40 characters.
    @IBOutlet var tweetTextField: UITextField!
    
    // Label that shows the remaining characters that the user has.
    @IBOutlet var characterCount: UILabel!
    
    // ID that correlates to the tweet being used in the Parse Database.
    var preExistingTweetParseID: String = ""
    
    // Boolean by default set to false. Flags if the user is using someone else's tweet.
    var usingUnfinishedTweet = false
    
    // Main function of the app that is called when the submit button is pressed.
    @IBAction func submitTweet(sender: AnyObject) {
        
        // If there is text in the preExistingTweet label, we are using a pre-existing tweet we will update the parse database with the appended text.
        if preExistingTweet.text != "" {
            
            // Appends the new text to the pre-existing tweet.
            _ = PFObject(className:"Tweets")
            let query = PFQuery(className:"Tweets")
            let newTweet = self.preExistingTweet.text! + " " + self.tweetTextField.text!
            
            
            // Use the ParseID stored to update database.
            query.getObjectInBackgroundWithId(self.preExistingTweetParseID) {
                (tweetID: PFObject?, error: NSError?) -> Void in
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
            
            // Create a new data entry
            tweets.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                } else {
                    // There was a problem, check error.description
                }

            })
            usingUnfinishedTweet = true

        }
        
        // Clear the text fields. 
        self.preExistingTweet.text = ""
        self.tweetTextField.text = ""
        characterCount.text = "40"
        
    }
    
    // If user hits "Give Me a Tweet!", select a random object from Parse database and show it.
    @IBAction func getAPrexistingTweet(sender: AnyObject) {
        
        // hide the tweet label to remove old tweet. 
        self.preExistingTweet.hidden = true
        
        // start the activity Indicator until the tweet is fetched.
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        // Stores the number of items int the database.
        var numberOfObjects: Int32 = 0
        
        // create a query
        let query = PFQuery(className:"Tweets")
        
        // Get the number of entries in the Parse Database
        query.countObjectsInBackgroundWithBlock {
            (count: Int32, error: NSError?) -> Void in
            if error == nil {
                numberOfObjects = count
                // Generate a random number between 1 and the number of items
                var randomNumber = Int(numberOfObjects)
                randomNumber = random() % randomNumber
                
                // Get the data entry that correlates to the random number by skipping that many entries.
                query.skip = randomNumber
                query.limit = 1
                
                // Get data entry
                query.getFirstObjectInBackgroundWithBlock {
                    (object: PFObject?, error: NSError?) -> Void in
                    if error != nil || object == nil {
                        print("The getFirstObject request failed.")
                    } else {
                        // The find succeeded.
                        print("Successfully retrieved the object.")
                        let tweetToEdit = object?.objectForKey("tweet") as! String
                        // Stop the activity tracker.
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidden = true
                        // Show the fetched tweet.
                        self.preExistingTweet.text = tweetToEdit
                        self.preExistingTweet.hidden = false
                        // Store the ParseID of fetched tweet.
                        self.preExistingTweetParseID = (object?.objectId)!
                    }
                }
    
            }
        }
    }
    
    // When the app starts up, the activity indicator is hidden.
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // delegate method
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Displays how many characters are left for the user to use.
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text!.utf16).count + (string.utf16).count - range.length
        if(newLength <= 40){
            self.characterCount.text = "\(40 - newLength)"
            return true
        }else{
            return false
        }
    }

}

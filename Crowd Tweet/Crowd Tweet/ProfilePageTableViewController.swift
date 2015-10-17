//
//  ProfilePageTableViewController.swift
//  Crowd Tweet
//
//  Created by Prakhar Garg on 10/17/15.
//  Copyright © 2015 Prakhar Garg. All rights reserved.
//

import UIKit
import TwitterKit
import Parse
import GameplayKit

class ProfilePageTableViewController: UITableViewController {

    @IBAction func refreshPage(sender: AnyObject) {
        
        // Get a new query and update the tweet array.
        updateList({
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            })
        })
        
        
        // Print all of the user's tweets in cells in the table.
        
    }
    
    var tweetArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
    
    var i = 0
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetsInProgress", forIndexPath: indexPath)
        
        cell.textLabel?.text = tweetArray[indexPath.row]
        

        return cell
    }
    
    func updateList(completion: ()->() ) {
        
        // Create a new Parse query to find all the tweets with the handle of the user
        
        let userName = Twitter.sharedInstance().session()?.userName
        // A new query
        let query = PFQuery(className:"Tweets")
        query.whereKey("handle", containsString: userName)
        query.findObjectsInBackgroundWithBlock {
            (TweetID: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(TweetID!.count) scores.")
                // Do something with the found objects
                if let myTweetID = TweetID {
                    for object in myTweetID {
                        self.tweetArray.append(object.objectForKey("tweet") as! String)
                    }
                }
                completion()
                print(self.tweetArray)
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

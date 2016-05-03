//
//  MemeTableViewController.swift
//  MemeMeV1
//
//  Created by Yu-Jen Chang on 4/18/16.
//  Copyright © 2016 Yu-Jen Chang. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {
    
    // get the updated memes everytime when we go back to table view
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // reload the table view data everytime when we go back to table view
        tableView.reloadData()
        tabBarController?.tabBar.hidden = false
        
    }
    
    // get number of rows in table view of memes
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    // display reusable cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SentMemesTableViewCell")
        let meme = memes[indexPath.row]
        
        // set the image & textfield
        cell?.imageView?.image = meme.memedImage
        cell?.textLabel?.text = meme.topText! + "..." + meme.bottomText!
        
        cell?.imageView?.contentMode = .ScaleAspectFit
        cell?.textLabel?.contentMode = .ScaleToFill
        
        return cell!
    }
    
    // went into detailed view when a cell is selected
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        detailController.meme = memes[indexPath.row]
        
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    // swipe to delete function
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            tableView.beginUpdates()
            // delete selected meme
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.memes.removeAtIndex(indexPath.row)
            // update table view to remove the deleted row
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.endUpdates()
        }
    }
    
    
}
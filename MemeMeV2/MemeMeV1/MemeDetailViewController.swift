//
//  MemeDetailViewController.swift
//  MemeMeV1
//
//  Created by Yu-Jen Chang on 4/22/16.
//  Copyright © 2016 Yu-Jen Chang. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        imageView.image = meme.memedImage
        imageView.contentMode = .ScaleAspectFit
        // hide the tab bar when showing the memedImage
        tabBarController?.tabBar.hidden = true
        view.backgroundColor = UIColor.blackColor()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        tabBarController?.tabBar.hidden = false
    }
    
    // go to meme editor to edit the existing meme
    @IBAction func editExistingMeme(sender: AnyObject) {
        let controller: MemeEditorViewController
        controller = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        controller.memeToBeEdited = meme
        navigationController?.pushViewController(controller, animated: true)
    }

}

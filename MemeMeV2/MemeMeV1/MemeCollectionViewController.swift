//
//  MemeCollectionViewController.swift
//  MemeMeV1
//
//  Created by Yu-Jen Chang on 4/18/16.
//  Copyright © 2016 Yu-Jen Chang. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // get the updated memes everytime when we go back to table view
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        // reload the collection view data everytime when we go back to table view
        collectionView!.reloadData()
        tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //modified flowLayout based on main view size
        getFlowLayoutModified(view.frame.size)
    }
    
    // respond to the rotation of view
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        getFlowLayoutModified(size)
    }
    
    // get flowLayout modified when device is rotated
    func getFlowLayoutModified(size: CGSize) {
        let space: CGFloat = 3
        var dimension: CGFloat
        
        if size.width < size.height {
            // portrait
            dimension = (size.width - (2 * space)) / 3.0
        } else {
            // landscape
            dimension = (size.width - (4 * space)) / 5.0
        }
        
        flowLayout?.minimumLineSpacing = space
        flowLayout?.minimumInteritemSpacing = space
        flowLayout?.itemSize = CGSizeMake(dimension, dimension)
    }
    
    // get the number of grids
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    // display each cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]
        
        // set the memedImage to the grid
        cell.memedImage?.image = meme.memedImage
        cell.memedImage?.contentMode = .ScaleAspectFit
        
        return cell
    }
    
    // went into detailed view when a cell is selected
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        detailController.meme = memes[indexPath.item]
        
        navigationController!.pushViewController(detailController, animated: true)
    }
    
}

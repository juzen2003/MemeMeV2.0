//
//  MemeEditorViewController.swift
//  MemeMeV1
//
//  Created by Yu-Jen Chang on 3/23/16.
//  Copyright © 2016 Yu-Jen Chang. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var enableCropping: Bool?
    var memeToBeEdited: Meme?
    var selectedFont: String?
    
    let textFieldDelegate = TextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.hidden = true
        var fontInUse: String
        
        if selectedFont == nil {
            // set the default font
            fontInUse = "Impact"
        } else {
            // set the user selected font
            fontInUse = selectedFont!
        }
        
        if memeToBeEdited == nil {
            // set default view
            setInitialView("TOP", bottomString: "BOTTOM", enableShare: false, image: nil, font: fontInUse)
        } else {
            // set existing image & text for user to modify the existing meme
            selectedFont == nil ?
            setInitialView(memeToBeEdited!.topText!, bottomString: memeToBeEdited!.bottomText!, enableShare: true, image: memeToBeEdited!.image!, font: memeToBeEdited!.font!):
            setInitialView(memeToBeEdited!.topText!, bottomString: memeToBeEdited!.bottomText!, enableShare: true, image: memeToBeEdited!.image!, font: selectedFont!)
        }
    }
    
    // initial view 
    func setInitialView(topString: String, bottomString: String, enableShare: Bool, image: UIImage?, font: String) {
        textFieldInitialization(topTextField, initString: topString, textFontString: font)
        textFieldInitialization(bottomTextField, initString: bottomString, textFontString: font)
        shareButton.enabled = enableShare
        imagePickerView.image = image
    }
    
    func textFieldInitialization(textField: UITextField!, initString: String, textFontString: String) {
        textField.delegate = textFieldDelegate
        // set text attributes
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: textFontString, size: 40)!,
            NSStrokeWidthAttributeName: -1.5
        ]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = initString
        textField.textAlignment = .Center
        
        textField.backgroundColor = UIColor.clearColor()
        textField.borderStyle = UITextBorderStyle.None
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // check if camera is avaiable on the device
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        // sign up to to be notified when keyboard appears
        subscribeKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // unsubscribe keyboard notification
        unsubscribeFromKeyboardNotifications()
    }
    
    // hide the status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // album button
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        presentImagePickerView(.PhotoLibrary)
    }
    
    // camera button
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        presentImagePickerView(.Camera)
    }
    
    // present image picker view
    func presentImagePickerView(source: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
        imagePickerController.sourceType = source
        // allow users to crop image
        if enableCropping == true {
            imagePickerController.allowsEditing = true
        } else {
            imagePickerController.allowsEditing = false
        }
    }
    
    // dimiss image picker view when user select a still image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // display the cropped/original image to UIImageView box based on user's option
        let imageKey: String
        if enableCropping == true {
            imageKey = UIImagePickerControllerEditedImage
        } else {
            imageKey = UIImagePickerControllerOriginalImage
        }
        
        if let image = info[imageKey] as? UIImage {
            imagePickerView.image = image
            imagePickerView.contentMode = .ScaleAspectFit
            shareButton.enabled = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // dimiss image picker view when user hit cancel
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // move the view when textfield is covered by keyboard
    func keyboardWillShow(notification: NSNotification) {
        // aviod view moving twice when user click on both text fields w/o typing
        if view.frame.origin.y == 0 && bottomTextField.isFirstResponder() {
            view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
    }
    
    // move the view frame down a distance equal to keyboard height
    func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y < 0 && bottomTextField.isFirstResponder() {
            view.frame.origin.y = 0
        }
    }
    
    // get keyboard height
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // observe keyboard notifications
    func subscribeKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // remove keyboard notifications
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // share button
    @IBAction func share(sender: AnyObject) {
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        presentViewController(controller, animated: true, completion: nil)
        controller.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [AnyObject]?, error: NSError? ) in
            // return if cancelled
            if (!completed) {
                return
            } else {
                self.save(image)
            }
            
            // go back to sent meme view after saving either a new meme or a edited meme
            if self.memeToBeEdited == nil {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }
    
    // create Meme object
    func save(memedImage: UIImage) {
        let meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, image: imagePickerView.image!, memedImage: memedImage, font: topTextField.font!.fontName)
        
        //add it to memes array in AppDelegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        // hide toolbar and navbar
        navigationController?.navigationBar.hidden = true
        toolBar.hidden = true
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // show toolbar and navbar
        navigationController?.navigationBar.hidden = false
        toolBar.hidden = false
        
        return memedImage
    }
    
    // canecel button, always go back to sent meme view
    @IBAction func cancelAndReturnToOriginalView(sender: AnyObject) {
        if memeToBeEdited == nil {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    // go to setting view
    @IBAction func goToSettingView(sender: AnyObject) {
        let controller: MemeEditorSettingViewController
        controller = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorSettingViewController") as! MemeEditorSettingViewController
        // send in existing to apply the setting if user is trying to edit the existing meme
        controller.editedMeme = memeToBeEdited
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
}


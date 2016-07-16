//
//  ViewController.swift
//  select_display_image
//
//  Created by Anna Rogers on 7/3/16.
//  Copyright © 2016 Anna Rogers. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    
//    name the delegates
    let topTextDelegate = TextFieldDelegate()
    let bottomTextDelegate = TextFieldDelegate()
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerView.contentMode = UIViewContentMode.ScaleAspectFit
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        shareButton.enabled = false
        setupText("TOP")
        setupText("BOTTOM")
    }
    
    func setupText (textPosition: String) {
        let selector = textPosition == "TOP" ? topText : bottomText
        _ = textPosition == "TOP" ? topTextDelegate : bottomTextDelegate
        selector.text = textPosition
        selector.defaultTextAttributes = memeTextAttributes
        selector.textAlignment = .Center
        selector.delegate = topTextDelegate
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
//  ---------- code for moving the image up when the keyboard loads ------
    func subscribeToKeyboardNotifications () {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        } else if topText.isFirstResponder(){
            reset()
        }
    }
    
    //  return the keyboard to the bottom position
    func reset() {
        self.view.frame.origin.y = 0
    }
    
    func keyboardWillHide(notification: NSNotification) {
        reset()
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
//    ---------------------------------------------------------------------
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            imagePickerView.contentMode = UIViewContentMode.ScaleAspectFit
            shareButton.enabled = true
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func pickAnImage (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if sender.tag == 3 {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        } else if sender.tag == 4 {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        }
        presentViewController(imagePicker, animated:true, completion:nil)
    }
    
//    save image
    func save(memedImage: UIImage) {
        _ = Meme(topString: topText.text!, bottomString: bottomText.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
    }
    
    @IBAction func shareMemeButtonPressed(sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = {
            (activity: String?, completed: Bool, items: [AnyObject]?, error: NSError?) -> Void in
            if completed {
                self.save(memedImage)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func generateMemedImage() -> UIImage {
        topToolbar.hidden = true
        bottomToolbar.hidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        topToolbar.hidden = false
        bottomToolbar.hidden = false
        return memedImage
    }

}


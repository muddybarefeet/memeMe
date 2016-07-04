//
//  ViewController.swift
//  select_display_image
//
//  Created by Anna Rogers on 7/3/16.
//  Copyright © 2016 Anna Rogers. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {


    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerView.contentMode = UIViewContentMode.ScaleAspectFill
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        topText.textAlignment = .Center
        bottomText.textAlignment = .Center
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func pickAnImage(sender: AnyObject) {
//        launch the imagepicker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated:true, completion:nil)
    }
    
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let imagePickerCamera = UIImagePickerController()
        imagePickerCamera.delegate = self
        imagePickerCamera.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePickerCamera, animated:true, completion:nil)
        
    }

}


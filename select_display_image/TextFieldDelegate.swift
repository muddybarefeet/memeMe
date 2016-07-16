//
//  TopTextFieldDelegate.swift
//  select_display_image
//
//  Created by Anna Rogers on 7/4/16.
//  Copyright © 2016 Anna Rogers. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var newText: NSString
        newText = textField.text!
        newText = newText.stringByReplacingCharactersInRange(range, withString: string)
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
//if the enter key is pressed the the keyboard wants to be hidden
        textField.resignFirstResponder()
        if (textField.text!.isEmpty) && textField.tag == 1 {
            textField.text = "TOP"
        } else if (textField.text!.isEmpty) && textField.tag == 2 {
            textField.text = "BOTTOM"
        }
        return true
    }
    
}
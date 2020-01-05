//
//  BottomDelegate.swift
//  ImageMeme
//
//  Created by Cristhian Recalde on 1/5/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import Foundation
import UIKit

class BottomDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setupInitialText(textField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        setupInitialText(textField)
        textField.resignFirstResponder()
        return true;
    }
    
    private func setupInitialText(_ textField: UITextField) {
        if textField.text?.count == 0 {
            textField.text = "BOTTOM"
        }
    }
}

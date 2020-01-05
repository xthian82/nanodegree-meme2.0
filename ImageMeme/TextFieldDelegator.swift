//
//  TextFieldDelegator.swift
//  ImageMeme
//
//  Created by Cristhian Recalde on 1/5/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegator: NSObject, UITextFieldDelegate {
    
    var title: String
    var moveUpKeyboard: Bool
    
    init(title: String, moveUpKeyboard: Bool = false) {
        self.title = title
        self.moveUpKeyboard = moveUpKeyboard
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setupInitialText(textField)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        setupInitialText(textField)
        textField.resignFirstResponder()
        return true;
    }
    
    private func setupInitialText(_ textField: UITextField) {
        if textField.text?.count == 0 {
            textField.text = title
        }
    }
}

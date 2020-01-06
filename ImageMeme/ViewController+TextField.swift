//
//  ViewController+TextField.swift
//  ImageMeme
//
//  Created by Cristhian Recalde on 1/5/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import Foundation
import UIKit

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        // we should move the frame only if the bottom textfield is selectd
        shouldMoveUpView = textField.hash == bottomTextField.hash
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
            textField.text = shouldMoveUpView ? ButtonTitle.BOTTOM.rawValue : ButtonTitle.TOP.rawValue
        }
    }
}

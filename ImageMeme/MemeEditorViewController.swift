//
//  MemeEditorViewController.swift
//  ImageMeme
//
//  Created by Cristhian Recalde on 1/4/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBarView: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelShare: UIBarButtonItem!
    @IBOutlet weak var topBarView: UIToolbar!
    
    var shouldMoveUpView = false
    var memmedImage: UIImage!
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -2.0
    ]
    
    // MARK: Delegates
    override func viewDidLoad() {
        super.viewDidLoad()

        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        setupTopBar(enabled: false)
        setUpTextField(topTextField, delegate: self)
        setUpTextField(bottomTextField, delegate: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotification()
    }

    //MARK: ToolBar Actions
    @IBAction func pickAnImageFromLibrary(_ sender: Any) {
        showImagePickController(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        showImagePickController(sourceType: .camera)
    }
    
    @IBAction func shareButtonPressed(){
        self.memmedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [self.memmedImage!], applicationActivities: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            // Ipad uses different controller
            controller.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2,
                                                                          y: UIScreen.main.bounds.height / 2,
                                                                          width: 0,
                                                                          height: 0)
            controller.popoverPresentationController?.sourceView = self.view
            controller.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        
        controller.completionWithItemsHandler = { (type, completed, items, error) in
            // save object on success
            if completed {
                self.save()
            }
        }
        
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancelTopBarButton() {
        navigateToParent()
    }

    //MARK: Notifications
    func subscribeToKeyboardNotifications() {
        // subscribe to textfield show
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillshow(_:)), name:
        UIResponder.keyboardWillShowNotification, object: nil)
        
        // subscribe to textfield hide
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:
            UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotification() {
        // unsubscribe to textfield show
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // unsubscribe to textfield hide
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillshow(_ notification: Notification) {
        view.frame.origin.y = shouldMoveUpView ? -getKeyboardHeight(notification) : 0
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.cgRectValue.height
    }
    
    //MARK: Image related functions
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         dismiss(animated: true, completion: nil)
     }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // info dictionary may contain multiple representations of the image. You want
        var selectedImage : UIImage!
        
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = img // try to use the edited if any
        } else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = img // try to use the original
        } else { // error
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        imagePickerView.image = selectedImage
        setupTopBar(enabled: true)
        dismiss(animated: true, completion: nil)
    }
    
    func save() {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: self.memmedImage)
        
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        navigateToParent()
    }
    
    func generateMemedImage() -> UIImage {
        // to save memmed image we hide top bars
        hideTopBars(isHidden: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // after saving memmed image we show top bars again
        hideTopBars(isHidden: false)
        
        return memedImage
    }
    
    //MARK: Utilities
    private func setUpTextField(_ textField: UITextField, delegate: UITextFieldDelegate) {
        textField.delegate = delegate
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    private func showImagePickController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        if sourceType == .camera {
            imagePickerController.showsCameraControls = true
        }
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func setupTopBar(enabled: Bool) {
        shareButton.isEnabled = enabled
    }
    
    private func hideTopBars(isHidden: Bool) {
        toolBarView.isHidden = isHidden
        topBarView.isHidden = isHidden
    }
    
    private func navigateToParent() {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}


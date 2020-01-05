//
//  ViewController.swift
//  ImageMeme
//
//  Created by Cristhian Recalde on 1/4/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
    }
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBarView: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelShare: UIBarButtonItem!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.white,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  0.0
    ]

    // MARK: Delegates
    let topDelegate = TextFieldDelegator(title: "TOP") //TopDelegate()
    let bottomDelegate = TextFieldDelegator(title: "BOTTOM", moveUpKeyboard: true) //BottomDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

        setUpTextField(topTextField!, delegate: topDelegate)
        setUpTextField(bottomTextField!, delegate: bottomDelegate)
        setupTopBar(enabled: false)
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
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        //TODO: fix finish handler
        // controller.completionWithItemsHandler = save

        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancelTopBarButton() {
        bottomTextField.text = "BOTTOM"
        topTextField.text = "TOP"
        imagePickerView.image = nil
        shareButton.isEnabled = false
    }
    
    //MARK: Library functions
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // info dictionary may contain multiple representations of the image. You want
        // to use the original
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as?
            UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        imagePickerView.image = selectedImage
        setupTopBar(enabled: true)
        dismiss(animated: true, completion: nil)
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
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.cgRectValue.height
    }
    
    func save() {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
        // TODO: test Hide toolbar and navbar
        toolBarView.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: test Show toolbar and navbar
        toolBarView.isHidden = false
        
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
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func setupTopBar(enabled: Bool) {
        shareButton.isEnabled = enabled
        cancelShare.isEnabled = enabled
    }
}


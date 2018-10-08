//
//  PostViewController.swift
//  InstagramClone
//
//  Created by Vu Duong on 10/7/18.
//  Copyright © 2018 Vu Duong. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageToPost: UIImageView!
    @IBOutlet weak var comment: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    @IBAction func postImage(_ sender: Any) {
        
        if let image = imageToPost.image {
        
        let post = PFObject(className: "Post")
        
        post["message"] = comment.text
        post["userid"] = PFUser.current()?.objectId
        
            if let imageData = UIImagePNGRepresentation(image) {
                
                spinner()
                
                let imageFile = PFFile(name: "image.png", data: imageData)
                post["imageFile"] = imageFile
                post.saveInBackground { (success, error) in
                    if success {
                        self.displayAlert(title: "Image Posted", message: "Your image has been posted!")
                        self.comment.text = ""
                        self.imageToPost.image = nil
                        
                    } else {
                        self.displayAlert(title: "Image could not be posted", message: "Please try again later")
                    }
                }
            }
        }
    }
    
    @IBAction func chooseAnImage(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageToPost.image = image
        } else {
            print("Picture error")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title , message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func spinner() {
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorView.Style.gray
        
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
    }
    
}

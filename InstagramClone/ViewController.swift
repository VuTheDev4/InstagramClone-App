//
//  ViewController.swift
//  InstagramClone
//
//  Created by Vu Duong on 9/27/18.
//  Copyright © 2018 Vu Duong. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signupOrLoginButton: UIButton!
    @IBOutlet weak var switchLoginModeButton: UIButton!
    
    var signupModeActive = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
        performSegue(withIdentifier: "showUserTable", sender: self)
        }
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func signupOrLogin(_ sender: Any) {
        
        if email.text == "" || password.text == "" {
            
            displayAlert(title: "Error!", message: "Email and Password is required")
            
        } else {
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorView.Style.gray
            
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()

            
            
            if signupModeActive {
                
                let user = PFUser()
                user.username = email.text
                user.password = password.text
                user.email = email.text
                
                user.signUpInBackground { (success, error) in
                    
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if let error = error {
                        
                        self.displayAlert(title: "Error", message: error.localizedDescription)
                        
                    } else {
                        
                        print("signed up!!!")
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }
                }
            } else {
                
                PFUser.logInWithUsername(inBackground: email.text!, password: password.text!) { (user, error) in
        
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if user != nil {
                        print("Successful login")
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    } else {
                        
                        let errorText = "Please try again"
                        
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        
                        self.displayAlert(title: "Error", message: errorText)
                    }
                }
            }
        }
    }
    
    @IBAction func switchLoginMode(_ sender: Any) {
        
        if signupModeActive {
            
            signupModeActive = false
            signupOrLoginButton.setTitle("Log In", for: [])
            switchLoginModeButton.setTitle("Sign up", for: [])
            
        } else {
            
            signupModeActive = true
            signupOrLoginButton.setTitle("Sign up", for: [])
            switchLoginModeButton.setTitle("Log In", for: [])
            
        }
    }
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title , message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}




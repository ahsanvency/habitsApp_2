//
//  newUserVC.swift
//  Habits
//
//  Created by Ahsan Vency on 3/28/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//


import UIKit
import Firebase
import SwiftKeychainWrapper
import TransitionButton
import DTTextField

class newUserVC: UIViewController {
    
    //Outlets
    
    @IBOutlet weak var nameField: DTTextField!
    @IBOutlet weak var emailField: DTTextField!
    @IBOutlet weak var passwordField: DTTextField!
    @IBOutlet weak var confirmPasswordField: DTTextField!
    
    //    @IBOutlet weak var nameField: UITextField!
//    @IBOutlet weak var emailField: UITextField!
//    @IBOutlet weak var passwordField: UITextField!
//    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var signIntoExistingAccount: UIButton!
    @IBOutlet weak var backgroundLoginButton: roundedButton!
    
    
    
    let button = TransitionButton(frame: CGRect(x: 30, y: 562, width: 315, height: 50))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //button.frame = CGRect(x: self.confirmPasswordView.frame.origin.x, y: self.confirmPasswordView.frame.origin.y + 70, width: self.confirmPasswordView.frame.width, height: 50)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        setupScreen()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    
    @IBAction func buttonAction(_ button: TransitionButton) {
        guard (validateData())else{
            return
        }
        
        button.startAnimation() // 2: Then start the animation when the user tap the button
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            sleep(UInt32(2.0)); // 3: Do your networking task or background work here.
            
            DispatchQueue.main.async(execute: { () -> Void in
                Auth.auth().createUser(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: { (user, error) in
                            //If there are no errors it will register the user
                            if error == nil {
                                if let user = user {
                                    let userData = [ "name": self.nameField.text!, "email" : self.emailField.text!, "profileImage": "https://firebasestorage.googleapis.com/v0/b/habitsapp-7ea48.appspot.com/o/myImage.png?alt=media&token=867310eb-eb88-40e1-932d-236ea372061c"]
                                    self.completeSignIn(id: user.uid, userData: userData as Dictionary<String, AnyObject>);
                                    button.stopAnimation(animationStyle: .expand, completion: {
                                        self.performSegue(withIdentifier: "toAdd", sender: nil)
                                    })
                                }
                            } else {//If the password was too short
                                    self.upAlert(messages: "Account Already Exists");
                                    button.stopAnimation()
                            }
                        })
            })
        })
    }
    
    @IBAction func signIntoExistingAccount(_ sender: Any) {
        
        view.window?.layer.add(leftTransition(duration: 0.5), forKey: nil)
        dismiss(animated: false, completion: nil)
    }
    
    
    //This function will be called everytime there is an error with the values the user entered. The message determining the error will be passed through to the function and displayed on the screen.
    func upAlert (messages: String) {
        let myAlert = UIAlertController(title: "Alert", message: messages, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    //Function that makes completing the sign in easier
    func completeSignIn(id: String, userData: Dictionary<String, AnyObject>){
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        KeychainWrapper.standard.set(id, forKey: KEY_UID);
    }
    
    func setupScreen(){
        
        let placeHolderColor = blueColor
        
        nameField.dtLayer.backgroundColor = UIColor.clear.cgColor
        nameField.dtLayer.borderWidth = 0
        nameField.textColor = placeHolderColor
        nameField.floatPlaceholderActiveColor = placeHolderColor
        nameField.floatPlaceholderColor = placeHolderColor
        nameField.placeholderColor = placeHolderColor
        
        emailField.dtLayer.backgroundColor = UIColor.clear.cgColor
        emailField.dtLayer.borderWidth = 0
        emailField.paddingYErrorLabel = 10
        emailField.textColor = placeHolderColor
        emailField.floatPlaceholderActiveColor = placeHolderColor
        emailField.floatPlaceholderColor = placeHolderColor
        emailField.placeholderColor = placeHolderColor
        
        passwordField.dtLayer.backgroundColor = UIColor.clear.cgColor
        passwordField.dtLayer.borderWidth = 0
        passwordField.textColor = placeHolderColor
        passwordField.floatPlaceholderActiveColor = placeHolderColor
        passwordField.floatPlaceholderColor = placeHolderColor
        passwordField.placeholderColor = placeHolderColor
        
        confirmPasswordField.dtLayer.backgroundColor = UIColor.clear.cgColor
        confirmPasswordField.dtLayer.borderWidth = 0
        confirmPasswordField.textColor = placeHolderColor
        confirmPasswordField.floatPlaceholderActiveColor = placeHolderColor
        confirmPasswordField.floatPlaceholderColor = placeHolderColor
        confirmPasswordField.placeholderColor = placeHolderColor
        
        self.view.addSubview(button)
        button.heightAnchor.constraint(equalTo: backgroundLoginButton.heightAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: backgroundLoginButton.leadingAnchor, constant: 0).isActive = true
        button.trailingAnchor.constraint(equalTo: backgroundLoginButton.trailingAnchor, constant: 0).isActive = true
        button.topAnchor.constraint(equalTo: backgroundLoginButton.topAnchor, constant: 0).isActive = true
        
        button.backgroundColor = .white
        button.setTitle("Create Account", for: .normal)
        button.titleLabel?.font =  UIFont(name: "D-DIN-Bold", size: 20)
        button.cornerRadius = 25.0
        button.spinnerColor = .white
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        buttonGradient(button: button)
        

        nameField.autocorrectionType = .no
        emailField.autocorrectionType = .no
        nameField.textContentType = UITextContentType("")
        emailField.textContentType = UITextContentType("")
        passwordField.textContentType = UITextContentType("")
        confirmPasswordField.textContentType = UITextContentType("")
        emailField.keyboardType = .emailAddress
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.height - 85)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += (keyboardSize.height - 85)
            }
        }
    }
}


extension newUserVC{
    
    func validateData() -> Bool {
        
        guard nameField.text != "" else{
            nameField.showError(message: "Please Enter Name.")
            return false
        }
        
        guard emailField.text != "" else{
            emailField.showError(message: "Please Enter Email.")
            return false
        }
        
        guard validateEmail(enteredEmail: self.emailField.text!) else{
            emailField.showError(message: "Please Enter Valid Email")
            return false
        }
        
        guard (passwordField.text?.count)! > 5 else {
            passwordField.showError(message: "Password must be atleast 6 characters")
            return false
        }
        
        guard passwordField.text != "" else{
            passwordField.showError(message: "Please Enter Password.")
            return false
        }
        
        guard confirmPasswordField.text != "" else{
            confirmPasswordField.showError(message: "Please Confirm Password.")
            return false
        }
        
        guard passwordField.text == confirmPasswordField.text else{
            confirmPasswordField.showError(message: "Passwords Must Match")
            return false
        }
        return true
    }
    
}


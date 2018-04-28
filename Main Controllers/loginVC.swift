//
//  newLoginController.swift
//  Habits
//
//  Created by Ahsan Vency on 2/28/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import TransitionButton
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper
import DTTextField
import paper_onboarding

class loginVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailField: DTTextField!
    @IBOutlet weak var passwordField: DTTextField!
    
//    @IBOutlet weak var emailField: UITextField!
//    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var fbButton: roundedButton!
    @IBOutlet weak var backgroundLoginButton: TransitionButton!
    
    
    let button = TransitionButton()
    
    var loadingViewNumber: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        setupScreen()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func buttonAction(_ button: TransitionButton) {
        
        guard validateData() else{
            return
        }
        
        button.startAnimation() // 2: Then start the animation when the user tap the button
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {

            sleep(UInt32(2.0)); // 3: Do your networking task or background work here.


            DispatchQueue.main.async(execute: { () -> Void in

                if let email = self.emailField.text, let pwd = self.passwordField.text{
                    
//                    if (!email.isEmpty && !pwd.isEmpty){
                        Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                            if error != nil {
                                self.upAlert(messages: "Invalid Username or Password")
                                button.stopAnimation()

                            }else {
                                if let user = user {
                                    self.completeSignIn(id: user.uid)
                                    button.stopAnimation(animationStyle: .expand, completion: {
                                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainVCID") as! MainVC
                                        self.present(newViewController, animated: true, completion: nil)
                                    })
                                }
                            }
                        })
//                    }
                }
            })
        })
    }
    
    func upAlert (messages: String) {
        let myAlert = UIAlertController(title: "Alert", message: messages, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func facebookLogin(_ sender: Any) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email","public_profile"], from: self) { (result, error) -> Void in
            if (error == nil){
                if let _ : FBSDKLoginManagerLoginResult = result {
                    do {
                        self.getFBUserData()
                    }
                }
            }
        }
    }
    
    func getFBUserData(){
        
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name,email, picture.type(large)"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("Error: \(String(describing: error))")
            }
            else
            {
                let data:[String:AnyObject] = result as! [String : AnyObject]
                print(data)
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        })
    }
    
    func firebaseAuth(_ credential: AuthCredential){
        Auth.auth().signIn(with: credential) { (user, error) in
            if let user = user {
                _ = ["provider" : credential.provider]
                self.completeSignIn(id: user.uid);
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainVCID") as! MainVC
                self.present(newViewController, animated: true, completion: nil)
            }
        }
    }
    
    func completeSignIn(id: String){
        KeychainWrapper.standard.set(id, forKey: KEY_UID);
    }
    
    
    func setupScreen(){
        let placeHolderColor = blueColor
        
        button.frame = CGRect(x: backgroundLoginButton.frame.origin.x, y: backgroundLoginButton.frame.origin.y, width: backgroundLoginButton.frame.width, height: backgroundLoginButton.frame.height)
        
        emailField.dtLayer.backgroundColor = UIColor.clear.cgColor
        emailField.dtLayer.borderWidth = 0
        emailField.floatPlaceholderActiveColor = placeHolderColor
        emailField.textColor = placeHolderColor
        emailField.paddingYErrorLabel = 10
        emailField.floatPlaceholderColor = placeHolderColor
        emailField.placeholderColor = placeHolderColor
        
        passwordField.dtLayer.backgroundColor = UIColor.clear.cgColor
        passwordField.dtLayer.borderWidth = 0
        passwordField.floatPlaceholderActiveColor = placeHolderColor
        passwordField.textColor = placeHolderColor
        passwordField.floatPlaceholderColor = placeHolderColor
        passwordField.paddingYErrorLabel = 10
        passwordField.placeholderColor = placeHolderColor
        
        
        
        self.view.addSubview(button)
        button.heightAnchor.constraint(equalTo: backgroundLoginButton.heightAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: backgroundLoginButton.leadingAnchor, constant: 0).isActive = true
        button.trailingAnchor.constraint(equalTo: backgroundLoginButton.trailingAnchor, constant: 0).isActive = true
        button.topAnchor.constraint(equalTo: backgroundLoginButton.topAnchor, constant: 0).isActive = true
        
        
        button.backgroundColor = .white
        button.setTitle("LOGIN", for: .normal)
        button.titleLabel?.font =  UIFont(name: "D-DIN-Bold", size: 20)
        button.cornerRadius = 25
        button.spinnerColor = .white
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        
        buttonGradient(button: button)
        
        emailField.autocorrectionType = .no
        emailField.keyboardType = .emailAddress
        passwordField.textContentType = UITextContentType("")
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.height - 75)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += (keyboardSize.height - 75)
            }
        }
    }
}

extension loginVC{

    func validateData() -> Bool {

        guard emailField.text != "" else{
            emailField.showError(message: "Please Enter Email.")
            return false
        }
        
        guard passwordField.text != "" else{
            passwordField.showError(message: "Please Enter Password.")
            return false
        }
        
//        guard !txtFirstName.text!.isEmptyStr else {
//            txtFirstName.showError(message: firstNameMessage)
//            return false
//        }
        return true
    }
    
}

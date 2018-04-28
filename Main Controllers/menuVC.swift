//
//  ViewController.swift
//  Habits
//
//  Created by Ahsan Vency on 4/16/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import SideMenu
import Firebase
import SwiftKeychainWrapper

class menuVC: UIViewController{
    
    @IBOutlet weak var profileImage: circularImage!
    @IBOutlet weak var nameOfUser: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUser = user{
            nameOfUser.text = currentUser.name
        }else{
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            DataService.ds.REF_USERS.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as! NSDictionary
                
                self.nameOfUser.text = value["name"] as! String
                
                let imageUrl = URL(string: value["profileImage"] as! String)
                let request = NSMutableURLRequest(url:imageUrl!);
                request.httpMethod = "GET";
                
                let session = URLSession(configuration: .default)
                let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                    
                    if error != nil{
                        print(error)
                    }else{
                        if (response as? HTTPURLResponse != nil){
                            if let imageData = data{
                                self.profileImage.image = UIImage(data: imageData)
                            }else{
                                print("No Image Found")
                            }
                        }else{
                            print("No response from server")
                        }
                    }
                }
                
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }


    
    @IBAction func signOut(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
        //        dismiss(animated: true, completion: nil)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "loginID") as! loginVC
        view.window?.layer.add(bottomTransition(duration: 0.5), forKey: nil)
        self.present(newViewController, animated: false, completion: nil)
    }
    
}

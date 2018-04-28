//
//  imagePicker.swift
//  Habits
//
//  Created by Ahsan Vency on 4/20/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import Firebase

//extension SettingsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    
//    func handleProfileImage(){
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.allowsEditing = true
//        
//        present(picker, animated: true, completion: nil)
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        
//        var selectedImageFromPicker: UIImage?
//        
//        if let editedImage = info["UIImagePickerControllerEditedImage"]{
//            selectedImageFromPicker = (editedImage as! UIImage)
//        } else if let originalImage = info["UIImagePickerControllerOriginalImage"]{
//            selectedImageFromPicker = (originalImage as! UIImage)
//        }
//        
//        if let selectedImage = selectedImageFromPicker {
//            userProfileImage.image = selectedImage
//        }
//        
//        dismiss(animated: true, completion: nil)
//    }
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        print("Canceled Picker")
//        dismiss(animated: true, completion: nil)
//    }
//}

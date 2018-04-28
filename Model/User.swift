//
//  User.swift
//  Habits
//
//  Created by Ahsan Vency on 1/11/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import Foundation
import Firebase
import UIKit


class User{
    
    private var _name: String!
    private var _profileImageUrl: String!

    init(name: String, profileImageUrl: String){
        _name = name;
        _profileImageUrl = profileImageUrl
    }
    
    var name: String{
        get{
            return _name;
        }
        set{
            _name = newValue;
        }
    }
    
    var proileImageUrl: String{
        get{
            return _profileImageUrl
        }set{
            _profileImageUrl = newValue;
        }
    }
    
}

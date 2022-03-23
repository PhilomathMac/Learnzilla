//
//  UserService.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 3/22/22.
//

import Foundation

// When user creates an account, we can also update user meta data within our app
class UserService {
    
    var user = User()
    
    // Creating a singleton : single copy of this object
    static var shared = UserService()
    
    // Makes it so you can't create multiple instances of this.
    private init() {
        
    }
}

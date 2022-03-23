//
//  User.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 3/22/22.
//

import Foundation

// Created as a class - typically only want one reference to a single user at a time! We don't want copies being created. We want all references to point to the same user instance.

class User {
    
    var name: String = ""
    var lastModule: Int?
    var lastLesson: Int?
    var lastQuestion: Int?
    
}

//
//  Lesson.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 11/15/21.
//

import Foundation

struct Lesson : Decodable, Identifiable {
    
    var id: String = ""
    var title: String = ""
    var video: String = ""
    var duration: String = ""
    var explanation: String = ""
    
}

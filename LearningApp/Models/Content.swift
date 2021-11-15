//
//  Content.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 11/15/21.
//

import Foundation

struct Content : Decodable, Identifiable {
    
    var id: Int
    var image: String
    var time: String
    var description: String
    var lessons: [Lesson]
    
}

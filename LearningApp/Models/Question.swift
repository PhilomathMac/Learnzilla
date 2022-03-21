//
//  Question.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 11/15/21.
//

import Foundation

struct Question : Decodable, Identifiable {
    
    var id: String = ""
    var content: String = ""
    var correctIndex: Int = 0
    var answers: [String] = [String]()
    
}

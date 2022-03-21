//
//  Test.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 11/15/21.
//

import Foundation

struct Test : Decodable, Identifiable {
    
    var id: String = ""
    var image: String = ""
    var time: String = ""
    var description: String = ""
    var questions: [Question] = [Question]()
    
}

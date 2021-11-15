//
//  Models.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 11/15/21.
//

import Foundation

struct Module : Decodable, Identifiable {
    
    var id: Int
    var category: String
    var content: Content
    var test: Test
    
}

//
//  ContentModel.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 11/15/21.
//

import Foundation

class ContentModel : ObservableObject {
    
    @Published var modules = [Module]()
    var styleData : Data?
    
    init() {
        getLocalData()
    }
    
    func getLocalData() {
        // Get url
        let jsonURL = Bundle.main.url(forResource: "data", withExtension: "json")
        guard jsonURL != nil else {
            return
        }
        
        do {
            
            // Create data object
            let jsonData = try Data(contentsOf: jsonURL!)
            
            // Try to decode the json into array of modules
            let jsonDecoder = JSONDecoder()
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            
            // Assign parsed modules to modules property
            self.modules = modules
            
        } catch {
            // TODO Log Error
            print("Couldn't parse local data")
            print(error)
        }
        
        // Parse style data
        let styleURL = Bundle.main.url(forResource: "style", withExtension: "html")
        guard styleURL != nil else {
            return
        }
        do {
            // Create data object
            let styleData = try Data(contentsOf: styleURL!)
            self.styleData = styleData

        } catch {
            print("Couldn't parse style data")
            print(error)
        }
        
    }
}

//
//  ContentModel.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 11/15/21.
//

import Foundation

class ContentModel : ObservableObject {
    
    // List of Modules
    @Published var modules = [Module]()
    
    // Curent Module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    var styleData : Data?
    
    init() {
        getLocalData()
    }
    
    //MARK: Module Navigation Methods
    
    func beginModule(moduleID: Int) {
        
        // Find index for this module ID
        for index in 0..<modules.count {
            if modules[index].id == moduleID {
                currentModuleIndex = index
                break
            }
        }
        // Set current module
        currentModule = modules[currentModuleIndex]
    }
    //MARK: Data Methods
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

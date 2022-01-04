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
    
    // Current Module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // Current Lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    // Current Lesson Explanation
    @Published var currentLessonDescription = NSAttributedString()
    
    // Binding for Navigation Links -> Current Selected Content and Test
    @Published var currentContentSelected: Int?
    
    
    // Style Data
    var styleData : Data?
    
    init() {
        getLocalData()
    }
    
    // MARK: Module Navigation Methods
    
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
    
    func beginLesson(lessonIndex: Int) {
        
        // Check that lesson index is within range of module.lessons
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        } else {
            currentLessonIndex = 0
        }
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        
        // Set lesson description
        currentLessonDescription = addStyling(htmlString: currentLesson!.explanation)
    }
    
    func hasNextLesson() -> Bool {
        return (currentLessonIndex + 1) < currentModule!.content.lessons.count
    }
    
    func nextLesson() {
        // Advance lesson index
        currentLessonIndex += 1
        // Check if in range
        if currentLessonIndex < currentModule!.content.lessons.count {
            // Set currentLesson
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            currentLessonDescription = addStyling(htmlString: currentLesson!.explanation)
        } else {
            // Reset lesson state
            currentLesson = nil
            currentLessonIndex = 0
        }
    }
    
    // MARK: Data Methods
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
    
    // MARK: Code Styling
    private func addStyling(htmlString: String) -> NSAttributedString {
        var resultString = NSAttributedString()
        var data = Data()
        
        // Add styling data
        if styleData != nil {
            data.append(self.styleData!)
        }
        
        // Add html data
        data.append(Data(htmlString.utf8))
        
        // Convert to attributed string
        // tries to do the stuff after the try and if it can't then it just skips the code (if let asdfasdf = try?)
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                
            resultString = attributedString
            
        }
        
        return resultString
    }
}

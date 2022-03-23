//
//  ContentModel.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 11/15/21.
//

import Foundation
import Firebase
import FirebaseAuth

class ContentModel : ObservableObject {
    
    // Authentication flag
    @Published var loggedIn = false
    
    // Database of modules
    let database = Firestore.firestore()
    
    // List of Modules
    @Published var modules = [Module]()
    
    // Current Module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // Current Lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    // Current Question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    // Current Lesson Explanation
    @Published var codeText = NSAttributedString()
    
    // Binding for Navigation Links -> Current Selected Content and Test
    @Published var currentContentSelected: Int?
    @Published var currentTestSelected: Int?
    
    
    // Style Data
    var styleData : Data?
    
    init() {
        // Won't get data in init method anymore. Since we want to control when we get the data.
        //getLocalData()
        //getRemoteData()
        //getDatabaseModules()
        
    }
    // MARK: Authentication Methods
    
    func checkLogin() {
        
        // Check if authenticated to determine if loggedIn
        loggedIn = Auth.auth().currentUser != nil ? true : false
        
        // Check if user meta data has been fetched.
        if UserService.shared.user.name == "" {
            
            // Data hasn't been fetched yet
            getUserData()
        }
        
    }
    
    
    // MARK: Module Navigation Methods
    
    func beginModule(_ moduleID: String) {
        
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
        codeText = addStyling(htmlString: currentLesson!.explanation)
    }
    
    func hasNextLesson() -> Bool {
        guard currentModule != nil else {
            return false
        }
        
        return (currentLessonIndex + 1) < currentModule!.content.lessons.count
    }
    
    func beginTest(_ moduleID: String) {
        
        //Set Current Module
        beginModule(moduleID)
        
        // Set current question index
        currentQuestionIndex = 0
        
        // If there are questions, set currentQuestion to first question
        if currentModule?.test.questions.count ?? 0 > 0 {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            
            // Set question content
            codeText = addStyling(htmlString: currentQuestion!.content)
        }
    }
    
    func nextLesson() {
        
        // Advance lesson index
        currentLessonIndex += 1
        
        // Check if in range
        if currentLessonIndex < currentModule!.content.lessons.count {
            // Set currentLesson
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(htmlString: currentLesson!.explanation)
        } else {
            // Reset lesson state
            currentLesson = nil
            currentLessonIndex = 0
        }
        
        // Save the progress
        saveUserData()
        
    }
    
    func nextQuestion() {
        
        // Advance question index
        currentQuestionIndex += 1
        
        // Check if in range
        if currentQuestionIndex < currentModule!.test.questions.count {
            // Set currentQuestion
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(htmlString: currentQuestion!.content)
        } else {
            // Reset question state
            currentQuestion = nil
            currentQuestionIndex = 0
        }
        
        // Save user data
        saveUserData()
        
    }
    
    // MARK: Data Methods
    
    ///Saves user data locally in UserService singleton. If writeToDatabase parameter is true, it also writes the userData to Firestore database.
    func saveUserData(writeToDatabase: Bool = false) {
        
        // Check if logged in
        if let loggedInUser = Auth.auth().currentUser {
            
            // Save the data locally
            let user = UserService.shared.user
            
            user.lastModule = currentModuleIndex
            user.lastLesson = currentLessonIndex
            user.lastQuestion = currentQuestionIndex
            
            if writeToDatabase {
                
                // Save the data in database
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(loggedInUser.uid)
                
                // Note: NSNull is the same as nil but works with Firestore database
                userRef.setData(["lastModule": user.lastModule ?? NSNull(),
                                 "lastLesson" : user.lastLesson  ?? NSNull(),
                                 "lastQuestion" : user.lastQuestion  ?? NSNull()], merge: true)
                
            }
            
        }
        
    }
    func getUserData() {
        
        // Check if there is a logged in user
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        // Get references
        let db = Firestore.firestore()
        let ref = db.collection("users").document(Auth.auth().currentUser!.uid)
        
        // Get user meta data
        ref.getDocument { docSnapshot, error in
            
            guard error == nil && docSnapshot != nil else {
                return
            }
            
            let data = docSnapshot!.data()
            let user = UserService.shared.user
            
            // Parse data into the user meta data
            user.name = data?["name"] as? String ?? ""
            user.lastModule = data?["lastModule"] as? Int
            user.lastLesson = data?["lastLesson"] as? Int
            user.lastQuestion = data?["lastQuestion"] as? Int
            
        }
    }
    func getDatabaseModules() {
        // Parse local style.html data
        getLocalStyles()
        
        // Specify path
        let collection = database.collection("modules")
        
        // Get documents in collection
        collection.getDocuments { querySnapshot, error in
            
            if let error = error {
                print(error.localizedDescription)
            } else if let snapShot = querySnapshot {
                
                // Create an array to temporarily store the modules
                var modules = [Module]()
                
                // Loop through the documents in snapShot
                // snapShot.documents = dictionary that contains all the key/value pairs (field/value) pairs
                for doc in snapShot.documents {
                    
                    // Create a new module instance
                    var m = Module()
                    
                    // Parse the values from doc into module
                    m.id = doc["id"] as? String ?? ""
                    m.category = doc["category"] as? String ?? ""
                    
                    // Parse lesson content
                    let contentMap = doc["content"] as! [String:Any]
                    
                    m.content.id = contentMap["id"]  as? String ?? ""
                    m.content.description = contentMap["description"]  as? String ?? ""
                    m.content.image = contentMap["image"]  as? String ?? ""
                    m.content.time = contentMap["time"]  as? String ?? ""
                    
                    
                    // Parse test content
                    let testMap = doc["test"] as! [String:Any]
                    
                    m.test.id = testMap["id"]  as? String ?? ""
                    m.test.description = testMap["description"]  as? String ?? ""
                    m.test.image = testMap["image"]  as? String ?? ""
                    m.test.time = testMap["time"]  as? String ?? ""
                    
                    // Add module to array
                    modules.append(m)
                    
                }
                
                // Assign modules to the published property in a dispatch queue since it updates the UI
                DispatchQueue.main.async {
                    self.modules = modules
                }
                
            } else {
                print("No snapShot returned")
            }
            
        }
        
    }
    
    func getLessons(module: Module, completion: @escaping () -> Void) {
        
        // Specify path to the lessons
        let collection = database.collection("modules").document("\(module.id)").collection("lessons")
        
        // Get documents
        collection.getDocuments { querySnapshot, error in
            
            if let error = error {
                print(error.localizedDescription)
            }
            else if let snapShot = querySnapshot {
                
                // Create temporary array to hold lessons as we get them
                var lessons = [Lesson]()
                
                // Loop through documents in the snapShot to build array of lessons
                for doc in snapShot.documents {
                 
                    // Empty lesson
                    var l = Lesson()
                    
                    // Parse and set properties
                    l.id = doc["id"] as? String ?? UUID().uuidString
                    l.duration = doc["duration"] as? String ?? ""
                    l.explanation = doc["explanation"] as? String ?? ""
                    l.title = doc["title"] as? String ?? ""
                    l.video = doc["video"] as? String ?? ""
                    
                    // Add lesson to array
                    lessons.append(l)
                }
                
                // Set the lesson to the module
                
                // Loop through published modules array using ennumerated so we get the index
                for (index, m) in self.modules.enumerated() {
                    
                    // Find module that matches module passed into function
                    if m.id == module.id {
                        
                        // Found the matching one
                        self.modules[index].content.lessons = lessons
                        
                        // Call completion closure to run code inside completion closure
                        completion()
                        
                    }
                }
            }
            else {
                print("No snapShot returned")
            }
        }
    }
    
    func getQuestions(module: Module, completion: @escaping () -> Void ) {
        
        // Specify path to the questions
        let collection = database.collection("modules").document(module.id).collection("questions")
        
        // Get documents
        collection.getDocuments { querySnapShot, error in
            
            if let error = error {
                print(error.localizedDescription)
            }
            else if let snapShot = querySnapShot {
                
                // Create temporary array to hold questions as we get them
                var questions = [Question]()
                
                // Loop through documents in the snapShot to build array of questions
                for doc in snapShot.documents {
                    
                    // Empty question
                    var q = Question()
                    
                    // Parse and set properties
                    q.id = doc["id"] as? String ?? UUID().uuidString
                    q.correctIndex = doc["correctIndex"] as? Int ?? 0
                    q.content = doc["content"] as? String ?? ""
                    q.answers = doc["answers"] as? [String] ?? [String]()
                    
                    // Add question to array
                    questions.append(q)
                }
                
                // Set the questions to the lesson
                // Loop through published modules array using ennumerated so we get the index
                for (index, m) in self.modules.enumerated() {
                    // Find module that matches module passed into function
                    if m.id == module.id {
                        
                        // Found the matching one so assign questions
                        self.modules[index].test.questions = questions
                        
                        // Call completion closure to run code inside completion closure
                        completion()
                    }
                }
                
                
            }
            else {
                print("No snapshot returned for questions")
            }
        }
    }
    
    func getLocalStyles() {
        
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
            
            DispatchQueue.main.async {
                // Assign parsed modules to modules property
                self.modules = modules
            }
            
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
    
    func getRemoteData() {
        
        // Get string path
        let urlString = "https://philomathmac.github.io/learningapp-data/data2.json"
        
        // Create a URL object
        let url = URL(string: urlString)
        
        guard url != nil else {
            // Couldn't create url
            print("Could not create remote url object")
            return
        }
        
        // Create a URLRequest object
        let request = URLRequest(url: url!)
        
        // Create a session to kick off the task
        let session = URLSession.shared
        
        // Create a data task
        let dataTask = session.dataTask(with: request) { data, response, error in
            
            // Check if there's an error
            guard error == nil else {
                // There was an error
                print("Error creating dataTask")
                return
            }
            
            // Handle the response
            do {
                // Create json decoder
                let decoder = JSONDecoder()
            
                // Decode
                let modules = try decoder.decode([Module].self, from: data!)
                // Wrap in a dispatch queue to tell main that it can fetch the data when it has a chance
                DispatchQueue.main.async {
                    // Append modules into modules property
                    self.modules += modules
                }
                
            } catch {
                // Couldn't parse json
                print("Couldn't parse remote data")
                print(error)
            }
            
        }
        
        // Kick off the data task
        dataTask.resume()
        
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

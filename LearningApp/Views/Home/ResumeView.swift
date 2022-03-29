//
//  ResumeView.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 3/24/22.
//

import SwiftUI

struct ResumeView: View {
    @EnvironmentObject var model: ContentModel
    @State var resumeSelected: Int?
    
    var user = UserService.shared.user
    
    var resumeTitle: String {
        
        let module = model.modules[user.lastModule ?? 0]
        
        if user.lastLesson != 0 {
            // Resume a lesson
            return "Learn \(module.category): Lesson \(user.lastLesson! + 1)"
        }
        else {
            // Resume a test
            return "\(module.category) Test: Question \(user.lastQuestion! + 1)"
        }
    }
    
    var destination: some View {
        return Group {
            
            let module = model.modules[user.lastModule ?? 0]
            
            // Determine if we need to go into a ContentDetailView or a TestView
            if user.lastLesson! > 0 {
                // Go to ContentDetailView
                ContentDetailView()
                    .onAppear {
                        
                        // Fetch lessons
                        model.getLessons(module: module) {
                            model.beginModule(module.id)
                            model.beginLesson(lessonIndex: user.lastLesson!)
                        }
                    }
                
            }
            else {
                // Go to TestView
                TestView()
                    .onAppear(perform: {
                        model.getQuestions(module: module) {
                            // On completion calls begin Test
                            model.beginTest( module.id)
                            model.currentQuestionIndex = user.lastQuestion!
                        }
            })
            }
        }
    }
    
    var body: some View {
        let module = model.modules[user.lastModule ?? 0]
        
        NavigationLink(tag: module.id.hash, selection: $resumeSelected) {
            
            destination
            
        } label: {
            ZStack {
                
                RectangleCard(color: .white)
                    .frame(height: 66)
                
                HStack {
                    
                    VStack (alignment: .leading) {
                        Text("Continue where you left off:")
                        Text(resumeTitle)
                            .bold()
                    }
                    
                    Spacer()
                    
                    Image("play")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
                .padding()
                .foregroundColor(.black)
                
            }
        }

    }
}

struct ResumeView_Previews: PreviewProvider {
    static var previews: some View {
        ResumeView()
    }
}

//
//  ContentView.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 11/15/21.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model : ContentModel
    let user = UserService.shared.user
    
    var navTitle: String {
        if user.lastLesson != nil || user.lastQuestion != nil {
            
            return "Welcome Back!"
            
        }
        else {
            return "Get Started"
        }
    }
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                
                if user.lastLesson != nil && user.lastLesson! >= 0 || user.lastQuestion != nil && user.lastQuestion! >= 0 {
                    
                    ResumeView()
                        .padding(.horizontal)

                } else {
                    
                    Text("What would you like to do today?")
                        .padding(.leading)
                }
                
                ScrollView {
                    
                    LazyVStack {
                        ForEach (model.modules) { module in
                            
                            VStack (spacing: 20){
                                
                                // Old style of Navigation Link that matches demo app - format : destination, tag, selection, label
                                NavigationLink(
                                    destination:
                                        ContentView()
                                            .onAppear(perform: {
                                                model.getLessons(module: module) {
                                                    // On completion calls begin Module
                                                    model.beginModule( module.id)
                                                }
                                        }),
                                    tag: module.id.hash,
                                    selection: $model.currentContentSelected) {
                                        // Learning Card
                                        HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, countString: "\(module.content.lessons.count) Lessons", time: module.content.time)
                                    }
                                
                                NavigationLink(
                                    destination:
                                        TestView()
                                            .onAppear(perform: {
                                                model.getQuestions(module: module) {
                                                    // On completion calls begin Test
                                                    model.beginTest( module.id)
                                                }
                                    }),
                                    tag: module.id.hash,
                                    selection: $model.currentTestSelected ) {
                                        HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, countString: "\(module.test.questions.count) Questions", time: module.test.time)
                                    }
                            }
                            .padding(.bottom, 10)
                        }
                    }
                    .accentColor(.black)
                    .padding()
                }
            }
            .navigationTitle(navTitle)
            .onChange(of: model.currentContentSelected) { newValue in
                if newValue == nil {
                    model.currentModule = nil
                }
            }
            .onChange(of: model.currentTestSelected) { newValue in
                if newValue == nil {
                    model.currentModule = nil
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}

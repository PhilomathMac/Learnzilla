//
//  ContentView.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 11/15/21.
//

import SwiftUI

struct HomeView: View {
    //MARK: Properties
    @EnvironmentObject var model : ContentModel
    
    //MARK: UI
    var body: some View {
        
        
        NavigationView {
            VStack(alignment: .leading) {
                Text("What would you like to do today?")
                    .padding(.leading, 20)
                ScrollView {
                    LazyVStack {
                        ForEach (model.modules) { module in
                            
                            VStack (spacing: 20){
                                
                                NavigationLink {
                                    ContentView()
                                        .onAppear {
                                            model.beginModule(moduleID: module.id)
                                        }
                                } label: {
                                    // Learning Card
                                    HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, countString: "\(module.content.lessons.count) Lessons", time: module.content.time)
                                }

                                NavigationLink {
                                    ContentView()
                                        .onAppear {
                                            model.beginModule(moduleID: module.id)
                                        }
                                } label: {
                                    // Test Card
                                    HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, countString: "\(module.test.questions.count) Questions", time: module.test.time)
                                }
                            }
                        }
                    }
                    .accentColor(.black)
                    .padding()
                }
            }
            .navigationTitle("Get Started")
        }
    }
    //MARK: Methods
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}

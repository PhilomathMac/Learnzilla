//
//  ContentView.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 11/15/21.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model : ContentModel
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                Text("What would you like to do today?")
                    .padding(.leading, 20)
                
                ScrollView {
                    
                    LazyVStack {
                        ForEach (model.modules) { module in
                            
                            VStack (spacing: 20){
                                
                                // Old style of Navigation Link that matches demo app - format : destination, tag, selection, label
                                NavigationLink(
                                    destination:
                                        ContentView()
                                            .onAppear(perform: {
                                                model.beginModule( module.id)
                                        }),
                                    tag: module.id,
                                    selection: $model.currentContentSelected) {
                                        // Learning Card
                                        HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, countString: "\(module.content.lessons.count) Lessons", time: module.content.time)
                                    }
                                
                                NavigationLink(
                                    destination:
                                        TestView()
                                            .onAppear(perform: {
                                                model.beginTest( module.id)
                                    }),
                                    tag: module.id,
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
            .navigationTitle("Get Started")
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

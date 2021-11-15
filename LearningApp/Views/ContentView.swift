//
//  ContentView.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 11/15/21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model : ContentModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                // Confirm current module is set
                if model.currentModule != nil {
                    // Create list of lessons
                    ForEach(0..<model.currentModule!.content.lessons.count) { index in
                        ContentViewRow(index: index)
                    }
                }
            }
            .padding()
            .navigationTitle("Learn \(model.currentModule?.category ?? "")")
        }
    }
}

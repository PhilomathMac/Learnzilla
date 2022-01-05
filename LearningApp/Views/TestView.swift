//
//  TestView.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 1/5/22.
//

import SwiftUI

struct TestView: View {
    @EnvironmentObject var model : ContentModel
    
    var body: some View {
        if model.currentQuestion != nil {
            VStack {
                // Question Number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                
                // Question
                CodeTextView()
                
                // Answers
                
                // Submit or Complete Button
                
                
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
        } else {
            // Test hasn't loaded yet
            ProgressView()
        }
    }
    
    
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

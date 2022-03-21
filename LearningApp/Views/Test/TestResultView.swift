//
//  TestResultView.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 1/5/22.
//

import SwiftUI

struct TestResultView: View {
    @EnvironmentObject var model : ContentModel
    
    var numCorrect: Int
    var feedbackText : String {
        
        guard model.currentModule != nil else {
            return ""
        }
        
        let percentCorrect = Double(numCorrect)/Double(model.currentModule!.test.questions.count)
        
        if percentCorrect == 1.0 {
            return "That's Amazing!"
        } else if percentCorrect > 0.8 {
            return "Great job!"
        } else if percentCorrect > 0.7 {
            return "You passed!"
        } else {
            return "Maybe you should study this topic again."
        }
        
    }
    
    var body: some View {
        VStack (alignment: .center) {
            Text(feedbackText)
                .font(.title)
            Spacer()
            Text("You got \(numCorrect) out of \(model.currentModule?.test.questions.count ?? 0) questions correct.")
            Spacer()
            Button {
                // Sends user back to home view
                model.currentTestSelected = nil
            } label: {
                ZStack {
                    RectangleCard(color: .green)
                        .frame(height: 48)
                    Text("Complete")
                        .bold()
                        .foregroundColor(.white)
                }
            }
            .padding()
            Spacer()

        }
    }
}

struct TestResultView_Previews: PreviewProvider {
    static var previews: some View {
        TestResultView(numCorrect: 8)
    }
}

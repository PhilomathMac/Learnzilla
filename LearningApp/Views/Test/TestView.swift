//
//  TestView.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 1/5/22.
//

import SwiftUI

struct TestView: View {
    @EnvironmentObject var model : ContentModel
    @State var submitted = false
    @State var selectedAnswerIndex: Int?
    @State var numCorrect = 0
    @State var showResults = false
    
    
    var body: some View {
        if model.currentQuestion != nil && showResults == false {
            VStack (alignment: .leading) {
                // Question Number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading, 20)
                
                // Question
                CodeTextView()
                    .padding(.horizontal, 20)
                
                // Answers
                ScrollView {
                    VStack {
                        ForEach (0..<model.currentQuestion!.answers.count, id: \.self) { index in
                            
                            Button {
                                // Track selected index
                                selectedAnswerIndex = index
                            } label: {
                                ZStack {
                                    if submitted == false {
                                        RectangleCard(color: index == selectedAnswerIndex ? .gray : .white)
                                            .frame(height: 48)
                                    } else {
                                        if index == model.currentQuestion!.correctIndex {
                                            RectangleCard(color: .green)
                                                .frame(height: 48)
                                        } else if index == selectedAnswerIndex && index != model.currentQuestion!.correctIndex {
                                            RectangleCard(color: .red)
                                                .frame(height: 48)
                                        } else {
                                            RectangleCard(color: .white)
                                                .frame(height: 48)
                                        }
                                    }
                                    Text(model.currentQuestion!.answers[index])
                                }
                            }
                            .disabled(submitted)
                        }
                    }
                    .padding()
                    .accentColor(.black)
                }
                
                // Submit or Complete Button
                Button {
                    // Check if answer has been submitted
                    if submitted {
                        
                        if model.currentQuestionIndex + 1 == model.currentModule!.test.questions.count {
                            
                            // Call nextQuestion just to ensure that user data saves correctly
                            model.nextQuestion()
                            
                            showResults = true
                        }
                        model.nextQuestion()
                        submitted = false
                        selectedAnswerIndex = nil
                    } else {
                        // Change state to true
                        submitted = true
                        // Check the answer and increment numCorrect
                        if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                            numCorrect += 1
                        }
                    }
                } label: {
                    ZStack {
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        Text(buttonText)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                .disabled(selectedAnswerIndex == nil)
                
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
        } else if showResults == true {
            // Show results view
            TestResultView(numCorrect: numCorrect)
        } else {
            ProgressView()
        }
    }
    
    var buttonText : String {
        // Check if answer has been submitted
        if submitted == true {
            if model.currentQuestionIndex + 1 == model.currentModule?.test.questions.count ?? 0 {
                return "Show Score"
            } else {
                return "Next Question"
            }
        } else {
            return "Submit"
        }
    }
    
    
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

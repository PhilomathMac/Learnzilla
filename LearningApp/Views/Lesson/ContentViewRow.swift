//
//  ContentViewRow.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 11/15/21.
//

import SwiftUI

struct ContentViewRow: View {
    
    @EnvironmentObject var model: ContentModel
    var index: Int
    var lesson: Lesson {
        if model.currentModule != nil && index < model.currentModule!.content.lessons.count {
            return model.currentModule!.content.lessons[index]
        } else {
            return Lesson(id: "", title: "Loading", video: "", duration: "", explanation: "")
        }
    }
    
    var body: some View {
//        let lesson = model.currentModule!.content.lessons[index]
        // Lesson Card
        ZStack (alignment: .leading) {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(height: 66)
                             
            HStack (spacing: 30) {
                Text("\(index + 1)")
                    .bold()
                VStack(alignment: .leading) {
                    Text(lesson.title)
                        .bold()
                    Spacer()
                    Text(lesson.duration)
                }
            }
            .padding()
        }
        .padding(.bottom, 5)
    }
}

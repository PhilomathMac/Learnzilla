//
//  ContentDetailView.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 11/15/21.
//

import SwiftUI
import AVKit

struct ContentDetailView: View {
    
    @EnvironmentObject var model : ContentModel
    
//    var player: AVPlayer {
//        if url != nil {
//            return AVPlayer(url: url!)
//        } else {
//            return AVPlayer(url: URL(string: "https://codewithchris.github.io/Module5Challenge/Lesson%201.mp4"))
//        }
//    }
    
    var body: some View {
        let lesson = model.currentLesson
        let url = URL(string: Constants.videoHostURL + (lesson?.video ?? ""))

        
        VStack {
        // Only show videoPlayer if we get a valid url
        if url != nil {
            VideoPlayer(player: AVPlayer(url: url!))
                .cornerRadius(10)
        }
        
        // Description
        CodeTextView()
        
        // Lesson Button (only if there IS a next lesson) and Complete Button (if not)
            if model.hasNextLesson() {
                Button {
                    model.nextLesson()
                } label: {
                    ZStack {
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        Text("Next Lesson: \(model.currentModule!.content.lessons[model.currentLessonIndex+1].title)")
                            .foregroundColor(.white)
                            .bold()
                    }
                }
            } else {
                Button {
                    // Call next lesson - to ensure that user data is saving correctly
                    model.nextLesson()
                    
                    model.currentContentSelected = nil
                } label: {
                    ZStack {
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        Text("Complete")
                            .foregroundColor(.white)
                            .bold()
                    }
                }
            }
        }
        .padding()
        .navigationTitle(lesson?.title ?? "Lesson")
    }
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
    }
}

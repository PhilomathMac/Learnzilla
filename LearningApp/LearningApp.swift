//
//  LearningAppApp.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 11/15/21.
//

import SwiftUI
import Firebase

@main
struct LearningApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(ContentModel())
        }
    }
}

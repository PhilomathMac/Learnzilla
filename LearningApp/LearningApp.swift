//
//  LearningAppApp.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 11/15/21.
//

import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}

//
//  LaunchView.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 3/17/22.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        if model.loggedIn == false {
            // Show login view
            LoginView()
                .onAppear {
                    // Check if user is logged in or out
                    model.checkLogin()
                }
        }
        else {
            
            // Show logged in view - tabs to show homeView and profileView
            TabView {
                
                HomeView()
                    .tabItem {
                        VStack {
                            Image(systemName: "book")
                            Text("Learn")
                        }
                    }
                
                ProfileView()
                    .tabItem {
                        VStack {
                            Image(systemName: "person")
                            Text("Profile")
                        }
                    }
                
            }
            .onAppear {
                model.getDatabaseModules()
            }
            
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}

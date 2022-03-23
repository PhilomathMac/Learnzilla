//
//  ProfileView.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 3/17/22.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        Button {
            // Sign out User
            // Note - not catching errors right now
            try! Auth.auth().signOut()
            
            // Change to sign out view
            model.checkLogin()
            
        } label: {
            Text("Sign Out")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

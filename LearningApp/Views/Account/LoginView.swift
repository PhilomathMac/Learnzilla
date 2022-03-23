//
//  LoginView.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 3/17/22.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct LoginView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var loginMode = Constants.LoginMode.login
    @State var email = ""
    @State var name = ""
    @State var password = ""
    @State var errorMessage: String? = nil
    
    var buttonText: String {
        
        if loginMode == Constants.LoginMode.login {
            return "Login"
        }
        else {
            return "Sign Up"
        }
        
    }
    
    var body: some View {
        
        VStack (spacing: 10) {
            
            Spacer()
            
            // Logo
            Image(systemName: "book")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 150)
            
            // Title
            Text("Learnzilla")
                .font(.largeTitle)
            
            Spacer()
            
            // Picker
            Picker(selection: $loginMode) {
                
                // Content
                Text("Login")
                    .tag(Constants.LoginMode.login)
                
                Text("Sign Up")
                    .tag(Constants.LoginMode.createAccount)
                
            } label: {
                Text("Picker Label")
            }
            .pickerStyle(.segmented)
            
            // Form
            Group {
                if loginMode == Constants.LoginMode.createAccount {
                    TextField("Name", text: $name)
                }
                
                TextField("Email", text: $email)
                
                SecureField("Password", text: $password)
                
                // Error Message
                if errorMessage != nil {
                    Text(errorMessage!)
                        .foregroundColor(.red)
                        .italic()
                }
            }
            
            // Button
            Button {
                if loginMode == Constants.LoginMode.login {
                    
                    // Log the user in
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        
                        // Check for error
                        guard error == nil else {
                            self.errorMessage = error!.localizedDescription
                            return
                        }
                        // Clear error message
                        self.errorMessage = nil
                        
                        // Fetch the user meta data
                        self.model.getUserData()
                        
                        // checkLogin to change LoggedIn
                        // changes the view to logged in view
                        model.checkLogin()
                    }
                }
                else {
                    // Create a new account
                    Auth.auth().createUser(withEmail: email, password: password) { result, error in
                        
                        // Check for errors
                        guard error == nil else {
                            self.errorMessage = error!.localizedDescription
                            return
                        }
                        
                        // Clear error message
                        self.errorMessage = nil
                        
                        // TODO: Refactor code - move methods out of view code
                        // Save the first name to database
                        let db = Firestore.firestore()
                        
                        let firestoreUser = Auth.auth().currentUser
                        
                        let userDoc = db.collection("users").document(firestoreUser!.uid)
                        
                        userDoc.setData(["name" : name], merge: true)
                        
                        // Update user meta data
                        let user = UserService.shared.user
                        user.name = name
                        
                        // checkLogin to change LoggedIn
                        // changes the view to logged in view
                        model.checkLogin()
                        
                    }
                }
            } label: {
                ZStack {
                    Rectangle()
                        .foregroundColor(.blue)
                        .frame(height: 40)
                        .cornerRadius(10)
                    Text(buttonText)
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
            
        }
        .padding(.horizontal, 40)
        .textFieldStyle(.roundedBorder)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

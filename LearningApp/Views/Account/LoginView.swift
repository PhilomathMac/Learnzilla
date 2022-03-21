//
//  LoginView.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 3/17/22.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var loginMode = Constants.LoginMode.login
    @State var email = ""
    @State var name = ""
    @State var password = ""
    
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
            
            // TODO: Logo
            Image(systemName: "book")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 150)
            
            // TODO: Title
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
            if loginMode == Constants.LoginMode.createAccount {
                TextField("Name", text: $name)
            }
            
            TextField("Email", text: $email)
            
            SecureField("Password", text: $password)
            
            // Button
            Button {
                if loginMode == Constants.LoginMode.login {
                    // TODO: Log the user in
                }
                else {
                    // TODO: Create a new account
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

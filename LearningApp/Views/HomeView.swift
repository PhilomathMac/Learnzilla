//
//  ContentView.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 11/15/21.
//

import SwiftUI

struct HomeView: View {
    //MARK: Properties
    @EnvironmentObject var model : ContentModel
    //MARK: UI
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
    //MARK: Methods    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

//
//  HomeViewRow.swift
//  LearningApp
//
//  Created by McKenzie Macdonald on 11/15/21.
//

import SwiftUI

struct HomeViewRow: View {
    
    var image: String
    var title: String
    var description: String
    var countString: String
    var time: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                // Hard coded size - not good for adjustable sizes
                //.frame(width: 335, height: 175)
                // Using aspect ratio - will take up as much space as it can while maintaining aspect ratio
                .aspectRatio(CGSize(width: 335, height: 175), contentMode: .fit)
            
            HStack {
                Image(image)
                    .resizable()
                    .frame(width: 116, height: 116)
                    .clipShape(Circle())
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(title)
                        .bold()
                    Text(description)
                        .padding(.bottom, 20)
                        .font(.caption)
                    
                    HStack{
                        Image(systemName: "text.book.closed")
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text(countString)
                            .font(Font.system(size: 10))
                        
                        Spacer()
                        
                        Image(systemName: "clock")
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text(time)
                            .font(Font.system(size: 10))
                    }
                }
                .padding(.leading, 20)
            }
            .padding(.horizontal, 20)
        }
    }
}

struct HomeViewRow_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewRow(image: "swift", title: "Learn Swift", description: "testing testing testing testing testing testing description", countString: "10 Lessons", time: "2 Hours")
    
    }
}

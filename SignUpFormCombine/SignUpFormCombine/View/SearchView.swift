//
//  SearchView.swift
//  SignUpFormCombine
//
//  Created by Jakub Gawecki on 26/05/2021.
//

import SwiftUI

struct SearchView: View {
   @StateObject private var viewModel = SearchViewModel()
   var body: some View {
      ZStack {
         VStack {
            Image(GHImage.logo)
               .resizable()
               .frame(width: 200, height: 200)
            
            TextField("Search username",
                      text: $viewModel.username)
               .frame(width: 250, height: 50)
               .textFieldStyle(RoundedBorderTextFieldStyle())
               .multilineTextAlignment(TextAlignment.center)
            
            Button(action: {
               viewModel.searchButtonTapped.toggle()
            }, label: {
               RoundedRectangle(cornerRadius: 8)
                  .overlay(
                     Text("Search")
                        .foregroundColor(.white)
                  )
            })
            .frame(width: 150, height: 44)
         }
      }
      .sheet(isPresented: $viewModel.presentingFollowersGrid, content: {
         FollowersGridView()
      })
      
      
   }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

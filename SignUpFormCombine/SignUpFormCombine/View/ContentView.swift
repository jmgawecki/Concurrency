//
//  ContentView.swift
//  SignUpFormCombine
//
//  Created by Jakub Gawecki on 25/05/2021.
//

import SwiftUI

struct ContentView: View {
   @StateObject private var viewModel = FormViewModel()
   
    var body: some View {
      NavigationView {
         VStack {
            FormView(viewModel: viewModel)
               LoginButtonView(viewModel: viewModel)
         }
         .navigationTitle("Sign up!")
         
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct FormView: View {
   @ObservedObject var viewModel: FormViewModel
   var body: some View {
      Form {
         Section(header: Text("Username")) {
            TextField("Username", text: $viewModel.name)
               .autocapitalization(.none)
         }
         Section(
            header: Text("Password"),
            footer: Text(viewModel.passwordMessage)
               .foregroundColor(
                  viewModel.passwordMessage == PasswordStatus.itsAllGood.rawValue ? .green : .red)
         ) {
            SecureField("Password", text: $viewModel.password)
            SecureField("Repeat password", text: $viewModel.passwordAgain)
         }
         
      }
   }
}

struct LoginButtonView: View {
   @ObservedObject var viewModel: FormViewModel
   
   var body: some View {
      ZStack {
         NavigationLink(destination: SearchView() ) {
            RoundedRectangle(cornerRadius: 10)
               .overlay(
                  Text("Tap me, aye aye!")
                     .foregroundColor(.white)
               )
               .frame(width: 150, height: 50, alignment: .center)
         }
         .disabled(!viewModel.isValid)
         
      }
   }
}

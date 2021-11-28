//
//  FormViewModel.swift
//  SignUpFormCombine
//
//  Created by Jakub Gawecki on 25/05/2021.
//

import SwiftUI
import Combine

class FormViewModel: ObservableObject {
   @Published var name              = ""
   @Published var password          = ""
   @Published var passwordAgain     = ""
   
   @Published var isValid           = false
   @Published var passwordMessage: PasswordStatus.RawValue = PasswordStatus.initial.rawValue
   
   private var cancellables = Set<AnyCancellable>()
   
   // MARK: - Initialiser
   
   init() {
      isFormValidPublisher
         .receive(on: RunLoop.main)
         .assign(to: \.isValid, on: self)
         .store(in: &cancellables)
      
      isPasswordValidPublisher
         .receive(on: RunLoop.main)
         .assign(to: \.passwordMessage, on: self)
         .store(in: &cancellables)
   }
      
   
   // MARK: - Username Publisher
   
   
   private var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
      $name
         .debounce(for: 0.8, scheduler: DispatchQueue.main)
         .removeDuplicates()
         .map {
            $0.count > 3 && $0.count < 12
         }
         .eraseToAnyPublisher()
   }
   
   
   // MARK: - Password Publisher
   
   
   private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
      $password
         .debounce(for: 0.8, scheduler: DispatchQueue.main)
         .removeDuplicates()
         .map { $0.isEmpty }
         .eraseToAnyPublisher()
   }
   
   
   private var arePasswordsSamePublisher: AnyPublisher<Bool, Never> {
      Publishers.CombineLatest($password, $passwordAgain)
         .debounce(for: 0.8, scheduler: RunLoop.main)
         .map { password, repeatPassword in
            password == repeatPassword
         }
         .eraseToAnyPublisher()
   }
   
   
   private var isPasswordStrongEnoughPublisher: AnyPublisher<Bool, Never> {
      $password
         .debounce(for: 0.8, scheduler: RunLoop.main)
         .removeDuplicates()
         .map {
            $0.count > 5 && $0.count < 12
         }
         .eraseToAnyPublisher()
   }
   
   
   private var isPasswordValidPublisher: AnyPublisher<PasswordStatus.RawValue, Never> {
      Publishers.CombineLatest3(isPasswordEmptyPublisher, isPasswordStrongEnoughPublisher, arePasswordsSamePublisher)
         .dropFirst(3)
         .map { empty, strong, same in
            
            if empty { return PasswordStatus.isEmpty.rawValue }
            
            if !strong { return PasswordStatus.notStrongEnough.rawValue }
            
            if !same { return PasswordStatus.doesNotMatch.rawValue }
            
            return PasswordStatus.itsAllGood.rawValue
         }
         .eraseToAnyPublisher()
   }
   
   
   // MARK: - Form Publisher
   
   
   private var isFormValidPublisher: AnyPublisher<Bool, Never> {
      Publishers.CombineLatest(isUsernameValidPublisher, isPasswordValidPublisher)
         .debounce(for: 0.8, scheduler: RunLoop.main)
         .map { username, password in
            username == true && password == PasswordStatus.itsAllGood.rawValue
         }
         .eraseToAnyPublisher()
   }
}

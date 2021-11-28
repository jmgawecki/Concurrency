//
//  PasswordStatus.swift
//  SignUpFormCombine
//
//  Created by Jakub Gawecki on 25/05/2021.
//

import Foundation

enum PasswordStatus: String {
   case isEmpty         = "Password is Empty"
   case doesNotMatch    = "Passwords are not matching!"
   case notStrongEnough = "Password is not strong enough. Please use Capital letter and one special sign"
   case itsAllGood      = "You are good to go!"
   case initial         = ""
}

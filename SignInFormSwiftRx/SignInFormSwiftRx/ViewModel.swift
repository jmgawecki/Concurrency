//
//  ViewModel.swift
//  SignInFormSwiftRx
//
//  Created by Jakub Gawecki on 28/11/2021.
//

import SwiftUI
import RxSwift

class ViewModel: NSObject {
    let usernamePublisher = PublishSubject<String>()
    let passwordPublisher = PublishSubject<String>()
    
    func isValid() -> Observable<Bool> {
        Observable.combineLatest(
            usernamePublisher.asObservable(),
            passwordPublisher.asObservable()
        ).map({ $0.0.count > 5 && $0.1.count > 5 })
    }
}

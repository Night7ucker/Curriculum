//
//  LoginViewModel.swift
//  Curriculum
//
//  Created by VironIT Developer on 12/6/17.
//  Copyright © 2017 VironIT Developer. All rights reserved.
//

import Foundation
import RxSwift

class LoginViewModel {

    let login = Variable<String>("")
    let password = Variable<String>("")

    let isValid: Observable<Bool>

    init() {
        isValid = Observable.combineLatest(self.login.asObservable(), self.password.asObservable())
        { (login, password) in
            return login.count > 0 && password.count > 0
        }
    }

}

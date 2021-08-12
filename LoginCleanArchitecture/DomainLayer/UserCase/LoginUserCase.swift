//
//  LoginUserCase.swift
//  LoginCleanArchitecture
//
//  Created by Hoang Manh Tien on 8/10/21.
//

import Firebase

protocol LoginUserCaseInterface {
//    func loginUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?)
    func checkAcount(withUsername username: String, password: String) -> String
}

struct LoginUserCase: LoginUserCaseInterface {
    
    private let loginRepository: LoginRepositoryInterface
    
    init(loginRepository: LoginRepository) {
        self.loginRepository = loginRepository
    }
    
    func checkAcount(withUsername username: String, password: String) -> String {
        return loginRepository.checkAcount(withUsername: username, password: password)
    }
    
//    func loginUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
//        loginRepository.loginUserIn(withEmail: email, password: password, completion: completion)
//        Firestore.firestore()
//    }
}

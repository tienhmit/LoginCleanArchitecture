//
//  LoginRepository.swift
//  LoginCleanArchitecture
//
//  Created by Hoang Manh Tien on 8/10/21.
//

import Firebase

protocol LoginRepositoryInterface {
//    func loginUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?)
    func checkAcount(withUsername username: String, password: String) -> String
    
}

struct LoginRepository: LoginRepositoryInterface {
    
    private let loginDataStore: LoginDataStoreInterface
    
    init(loginDataStore: LoginDataStore) {
        self.loginDataStore = loginDataStore
    }
    
    func checkAcount(withUsername username: String, password: String) -> String {
        return loginDataStore.checkAcount(withUsername: username, password: password)
    }
    
//    func loginUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
//        loginDataStore.loginUserIn(withEmail: email, password: password, comletion: completion)
//    }
}

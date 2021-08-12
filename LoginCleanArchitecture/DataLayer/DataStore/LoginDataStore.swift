//
//  LoginDataStore.swift
//  LoginCleanArchitecture
//
//  Created by Hoang Manh Tien on 8/10/21.
//

import Firebase
import FirebaseFirestoreSwift

enum LoginStringKey: String {
    case collectionName = "account"
    case successString = "Chúc mừng bạn đã đăng nhập thành công"
    case errorString = "Đăng nhập không thành công. Hãy kiểm tra lại username hoặc password"
    case lockString = "Tài khoản đã bị khóa do đăng nhập sai 3 lần. Bạn hãy thử lại sau 30 phút"

}

protocol LoginDataStoreInterface {
//    func loginUserIn(withEmail email: String, password: String, comletion: AuthDataResultCallback?)
    func checkAcount(withUsername username: String, password: String) -> String
}

final class LoginDataStore: LoginDataStoreInterface {
    
    private var loginEntity: LoginEntity?
    
    init(loginEntity: LoginEntity) {
        self.loginEntity = loginEntity
    }
    
    func checkAcount(withUsername username: String, password: String) -> String {
        var string = ""
        fetchAccount(withDocumentName: username) {
        }
        if self.loginEntity?.password != password {
            self.loginEntity?.loginCount += 1
            Firestore.firestore().collection(LoginStringKey.collectionName.rawValue).document(username).updateData(["loginCount": self.loginEntity?.loginCount as Any])
            string = self.loginEntity?.loginCount ?? 0 > 3 ? LoginStringKey.lockString.rawValue : LoginStringKey.errorString.rawValue
        } else {
            self.loginEntity?.loginCount = 0
            Firestore.firestore().collection(LoginStringKey.collectionName.rawValue).document(username).updateData(["loginCount": self.loginEntity?.loginCount as Any])
            string = LoginStringKey.successString.rawValue
        }
        return string
    }
}

extension LoginDataStore {
    
    private func fetchAccount(withDocumentName username: String,  completion: @escaping () -> Void) {
        Firestore.firestore().collection(LoginStringKey.collectionName.rawValue).document(username).getDocument { document, error in
            if let error = error {
                print("Debug: \(error.localizedDescription)")
            }
            
            do {
                self.loginEntity = try document?.data(as: LoginEntity.self)
                
            } catch {
                print("Debug: \(error.localizedDescription)")
            }
            completion()
        }
    }
}

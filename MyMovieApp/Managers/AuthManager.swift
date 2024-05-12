//
//  AuthManager.swift
//  MyMovieApp
//
//  Created by Macbook on 2/5/24.
//

import FirebaseAuth
import FirebaseFirestore

final class AuthManager {
    
    static let shared = AuthManager()
    private init() {}
    
    // A method to register the user
    // - Parameters:
    //    - userRequest: The user informashion (username, email, password)
    //    - compleation: A compleation with two values:
    //    - Bool: User was registered (saved) or not in data base correctly
    //    - Error: An optional errors with connection to data base
    
    func registerUser(with userRequest: RegisterUserRequest, compleation: @escaping (Bool, NetworkError?) -> Void) {
        let username = userRequest.username
        let email = userRequest.email
        let password = userRequest.password
        let avatar = userRequest.avatar
        let gender = userRequest.gender
        let date = userRequest.date
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error)
                compleation(false, .registerUser)
                return
            }
            
            guard let resultUser = result?.user else {
                compleation(false, nil)
                return
            }
            
            let db = Firestore.firestore() // Referense to data base
            db.collection("users")
                .document(resultUser.uid)
                .setData([
                    "userId " : result?.user.uid, "username" : username, "email" : email, "avatar" : avatar,
                    "gender" : gender, "date" : date]) { error in
                        
                    if let error = error {
                        print(error)
                        compleation(false, .passUserDataToCollectionUser)
                        return
                    }
                    compleation(true, nil) // If successfuly pass user data to db
            }
        }
    }
    
    func signIn(with userRequest: LoginUserRequest, compleation: @escaping (NetworkError?) -> Void) {
        Auth.auth().signIn(withEmail: userRequest.email, password: userRequest.password) { result, error in
            if let error = error {
                print(error)
                compleation(.signInAuth)
                return
            } else {
                compleation(nil)
            }
        }
    }
    
    func signOut(completion: @escaping (NetworkError?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            print(error.localizedDescription)
            completion(.errorWithSignOut)
        }
    }
    
    func forgotPassword(with email: String, compleation: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            compleation(error)
        }
    }
}

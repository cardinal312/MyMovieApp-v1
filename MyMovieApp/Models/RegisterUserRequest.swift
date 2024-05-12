//
//  RegisterUserRequest.swift
//  MyMovieApp
//
//  Created by Macbook on 2/5/24.
//

import Foundation
import Firebase

struct RegisterUserRequest {
    let username: String
    let email: String
    let password: String
    let avatar: String = ""
    let gender: String = ""
    let date: Timestamp = Timestamp()
}



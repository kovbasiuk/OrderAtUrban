//
//  SessionStore.swift
//  orderaturban2
//
//  Created by Robert Kovbasiuk on 01/05/2020.
//  Copyright © 2020 RK. All rights reserved.
//


import SwiftUI
import Firebase



//Purpose of this struct is to keep track of data relating to Firebase Auhentication and any saved runtime data
//ObservableObject so its values dynamically update in other views

class SessionStore : ObservableObject  {
    

    //Published optional varibale to keep track of authentication user
    @Published var session: User?
    
    //variable that is attached to self in content view, stores run time data
    var appData:RTData?
    
    //used to detect authentication changes using firebase in listen()
    var handle: AuthStateDidChangeListenerHandle?
    
    //attaches appData to self so data can be accessed from any class
    //Used in: ContentView
    func attatch(appData: RTData) {
        self.appData = appData
    }
    
    //monitor authentication changes using firebase
    //Used in: ContentView
    func listen () {
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let  user = user {
                // if we have a user, create a new user model
                print("Got user: \(user)")
                self.session = User(
                    uid: user.uid,
                    displayName: user.displayName,
                    email: user.email
                    
                )
            } else {
                // if we don't have a user, set our session to nil
                self.session = nil
            }
            
        }
    }
    //Registers user for Firebase Authentication
    //Used in: SignUpView
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback){
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    //Signs user in using Firebase Authentication
    //Used in: AuthView
    func signIn(email: String, password: String, handler: @escaping AuthDataResultCallback){
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
        
        
    }
    //Signs user out using Firebase Authentication, resets the run time data variable fields
    //Used in: Profile
    func signOut() {
        do{
            try Auth.auth().signOut()
            self.appData?.currOrder.items.removeAll()
            self.appData!.orders.removeAll()
            
            self.session = nil
            
            print("user signed out")
        }
        catch {
            print("Error Signing out")
        }
    }
    
    //a way to stop listening to our authentication change handler
    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    //used for when setting self to nil
    deinit {
        unbind()
    }
    
}

//used for creating a new user for firebase authentication
//assigned to "session" variable in self
//Used in: SignUpView
struct User {
    var uid: String?
    var email: String?
    var displayName: String?
    
    //initialiser
    init(uid: String, displayName: String?, email: String?) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
        
        
    }
    
}

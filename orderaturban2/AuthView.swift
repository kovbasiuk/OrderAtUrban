//
//  AuthView.swift
//  orderaturban2
//
//  Created by Robert Kovbasiuk on 01/05/2020.
//  Copyright © 2020 RK. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase

//Purpose of this struct is to style the image used in SignInVIew
struct LoginImage: View {
    var body: some View {
        Image("urban")
            .resizable()
            
            .frame(width: 270.0, height: 300.0)
            .scaledToFit()
            .clipShape(Circle())
            .overlay(Circle()
                .stroke(Color.white, lineWidth: 3))
            .shadow(radius: 10)
    }
}


//Struct is used to give the user an opportunity to log in or register
struct SignInView : View {
    
    //Fields to keep track off for login
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var error: String = ""
    @EnvironmentObject var session: SessionStore
    
    
    //calls sessionstore function to sign in
    //UsedIn: button inside self's body
    func signIn(){
        session.signIn(email: email, password: password){ (result, error) in
            if let error = error {
                self.error = error.localizedDescription
            }
            else {
                self.email = ""
                self.password = ""
            }
        }
        
    }
    
    
    var body: some View {
        VStack {
            Text("Order@Urban")
                .foregroundColor(Color("primGreen"))
                .font(.system(size: 42, weight: .heavy))
                .padding(.bottom, 20)
            LoginImage()
            
            
            
            
            VStack{
                //enter user details here, updates @State variables
                TextField(/*@START_MENU_TOKEN@*/"Email"/*@END_MENU_TOKEN@*/, text: $email)
                    .padding([.top, .leading, .trailing], 20)
                SecureField("Password", text: $password)
                    .padding([.top, .leading, .trailing], 20)
                
            }
            
            
            VStack{
                
                //user signs in using this button
                Button(action: signIn) {
                    Spacer()
                    Text("Login")
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    
                    
                    Spacer()
                    
                }
                .padding(.all,12)
                    
                .background(Color("primGreen"))
                .cornerRadius(/*@START_MENU_TOKEN@*/7.0/*@END_MENU_TOKEN@*/)
                .accentColor(.white).padding()
                
                //prints error relevant error if it doesnt work
                if(error != ""){
                    Text(error)
                        .font(.system(size:14, weight: .semibold))
                        .foregroundColor(.red)
                        .padding()
                }
                
                
                
                //used for new users who want to create an account
                NavigationLink(destination: SignUpView()){
                    VStack{
                        HStack{
                            Text("Im a new user")
                                .foregroundColor(Color.gray)
                            Text("Create an account")
                                .foregroundColor(Color("primGreen"))
                        }
                    }
                    .padding(.horizontal,12.0)
                    
                    
                }
                .padding(.vertical,  20.0)
                
            }
            .padding(.top, 20.0)
            
        }
        
    }
}



//Struct is used to give new users an opportunity to sign in
struct SignUpView : View {
    
    
    
    //neccessary fields
    @State private var email: String = ""
    @State private var firstName: String = ""
    @State private var password: String = ""
    @State private var error: String = ""
    @EnvironmentObject var session: SessionStore
    
    //used to determine what type of account the user is registering for by a toggle. Vendor accounts are for staff working in the cafe
    @State private var vendorAcc: Bool = false
    
    
    
    //first step in completing the registration. If registering the account with Firebase Authentication is successful, completion handlers passes a boolean value which can be assigned to a variable in a closure when this method is called
    // Used In: completeSignUp()
    func signUp(completion: @escaping (Bool)->Void){
        
        
        session.signUp(email: email, password: password){ (result, error) in
            if let error = error {
                self.error = error.localizedDescription
                print("completion false")
                completion(false)
                
            }
            else {
                print("completion true")
                
                completion(true)
                self.email = ""
                self.password = ""
                
            }
            
        }
        
    }
    
    //As this app relies on downloading and updating orders based on the user's ID therefor it must register the users ID in Firestore  "users" collection the same as the ID assigned in Firebase Authentication services.
    
    //uid param will be the authentication account's id which was created in self.signUp()
    //Used in: completeSignUp()
    func writeFirestoreUID(uid: String) {
        
        print("writing user data")
        // Add a new document with a generated ID
        // var ref: DocumentReference? = nil
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).setData( [
            "email": self.email,
            
            "registered on": Timestamp(),
            "vendorAcc": self.vendorAcc,
            "uid": uid

        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {

                
                
                print("Document added with ID: \(uid)")
                
            }
        }
    }
    
    
    //RTData class uses Firebase Authentication to get the user's authenticatio ID once logged in then downloads orders using that ID from firestore. Therefor it is important firestore user id is the same as authentication account ID
    
    //Used in: button in self's body
    func completeSignUp(){
        
        //result is the escaped variable from the completion
        signUp(completion: { result in
            
            
            //if te user was successfully registered with authentication
            if result == true {
 
                //gets the user's ID created in self.signUp() and checks if its not nil
                guard let uid = Auth.auth().currentUser?.uid   else {
                    print("current user's ID is nil, couldnt complete sign up")
                    return
                }
                
                //writes data to firestore
                self.writeFirestoreUID(uid: uid)
                
                
            }
            
        })
        
        
    }
    
    
    
    
    
    var body: some View {
        
        
        
        VStack{
            
            
            Text("Create an account")
                
                .font(.system(size: 32, weight: .heavy))
            
            Text("Sign up to get started")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color.gray)
            
            
            VStack(spacing: 18){
                TextField(/*@START_MENU_TOKEN@*/"Email"/*@END_MENU_TOKEN@*/, text: $email)
                    .padding([.top, .leading, .trailing], 20)
                
                SecureField("Password", text: $password)
                    .padding([.top, .leading, .trailing], 20)
                
                
                Toggle(isOn: $vendorAcc) {
                    Text("Vendor Account")
                        .font(.headline)
                    
                }
                
                
            }.padding(20)
            
            
            //user will press this button once filling the textfields in
            Button(action: completeSignUp){
                Text("Create account")
            }
            
            if(error != ""){
                Text(error)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.red)
            }
            
        }
        
    }
}

//purpose of this struct is to display SignInView in NavigationView
struct AuthView : View {
    var body: some View {
        NavigationView{
            SignInView()
        }
        .padding(20.0)
        
    }
}


struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}

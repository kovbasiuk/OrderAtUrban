//
//  Profile.swift
//  orderaturban2
//
//  Created by Robert Kovbasiuk on 03/05/2020.
//  Copyright © 2020 RK. All rights reserved.
//

import SwiftUI
//Purpose of this struct is to provide the user a chance to log out
//Used in: Home
struct Profile: View {
     @EnvironmentObject var session: SessionStore
    
    var body: some View {
        VStack {
            Text("Profile")
        
               //sign out -> sets session to nil and user gets redirected to AuthView
            Button(action: session.signOut){
        Text("Sign out")
        }

    }
}
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}

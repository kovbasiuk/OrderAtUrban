//
//  Profile.swift
//  orderaturban2
//
//  Created by Robert Kovbasiuk on 03/05/2020.
//  Copyright © 2020 RK. All rights reserved.
//

import SwiftUI

struct Profile: View {
     @EnvironmentObject var session: SessionStore
    
    var body: some View {
        VStack {
            Text("Profile")
            
           // Text("My userID: \(session.appData?.userID ?? "no user ID found")" ?? "No user Id")
               
        
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

//
//  ContentView.swift
//  orderaturban2
//
//  Created by Robert Kovbasiuk on 01/05/2020.
//  Copyright © 2020 RK. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    //session store object to keep track of login and appData (RTData)
    @EnvironmentObject var session: SessionStore
    
    @ObservedObject var appData = RTData()
  
    
    
    // .listen checks if user is signed in
    // Used in: loadFuncs()
     func getUser(){
        session.listen()
    }
    
    //attatches RTData app to the session EnvirnmentObject to access the data amongst all classes
    // Used in: loadFuncs()
    func attatch(appData: RTData) {
        session.attatch(appData: appData)
    }
    
    //function which runs other functions defined in this class
    // Used in: var body, Group.onAppear
     func loadFuncs(){
        getUser()
        attatch(appData: self.appData)
         
    }
    
    var body: some View {
        
        Group {
            //if session is not nil/user is signed in displays Home
            // else user is taken to AuthView
            if(session.session != nil) {
                
                
                Home(appData: appData)
             
            }
                
            else {
                AuthView()
            }
            //calls function when first appears
        }.onAppear(perform: loadFuncs)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SessionStore())
    }
}

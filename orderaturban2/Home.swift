//
//  Home.swift
//  orderaturban2
//
//  Created by Robert Kovbasiuk on 01/05/2020.
//  Copyright © 2020 RK. All rights reserved.
//

import SwiftUI



struct Home: View {
     @ObservedObject var appData:RTData
    
    func checkUser(){
        self.appData.fullUserDownload()
        
    }
    var body: some View {
        
        VStack{
        if self.appData.vendorAcc{
            HomeVendor(appData: appData)
        }
        
        else{
            HomeCust(appData: appData)
        }
        }.onAppear(perform: checkUser)
    }
}

//Struct for vendors
struct HomeVendor: View {
    
    @ObservedObject var appData:RTData
    
    var body: some View {
      
        TabView(){
          
        
            
            
            OrderListView(orders: appData.orders)
                .tabItem({
                    
                    Image(systemName:"book.fill")
                        .font(.title)
                    Text("Orders")
                    
                }).tag(0)
            
            Profile()
                .tabItem({
                    
                    Image(systemName:"person.fill")
                        .font(.title)
                    Text("Profile")
                    
                }).tag(1)
        }.accentColor(Color("secGreen"))
        //Text("hello")
    }
}

//home view for Customers...used in content view
struct HomeCust: View {
    
    @ObservedObject var appData:RTData
    
  
    
    var body: some View {
        
        
        VStack {
            
            TabView(){
                CustMenuView(appData: self.appData)
                    .tabItem({
                        
                        Image(systemName:"house.fill")
                            .font(.title)
                        Text("Home")
                        
                    }).tag(0)
                
                NewOrderView(menuItems: Array(self.appData.currOrder.items.keys), count: Array(self.appData.currOrder.items.values))
                    .tabItem({
                        
                        Image(systemName:"cart.fill")
                            .font(.title)
                        Text("Basket")
                        
                    }).tag(1)
                
                
                
                OrderListView(orders: appData.orders)
                    .tabItem({
                        
                        Image(systemName:"book.fill")
                            .font(.title)
                        Text("Orders")
                        
                    }).tag(2)
                
                Profile()
                    .tabItem({
                        
                        Image(systemName:"person.fill")
                            .font(.title)
                        Text("Profile")
                        
                    }).tag(3)
            }.accentColor(Color("secGreen"))
            //Text("hello")
        }
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HomeCust(appData: RTData())
    }
}

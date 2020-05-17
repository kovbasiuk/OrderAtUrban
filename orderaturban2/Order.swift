//
//  Order.swift
//  orderaturban2
//
//  Created by Robert Kovbasiuk on 01/05/2020.
//  Copyright © 2020 RK. All rights reserved.
//

import Foundation
import Firebase
import SwiftUI

//struct for each order
//THE BASKET/NEW ORDER VIEW IS AT THE BOTTOM OF THIS FILE
class Order : ObservableObject, Identifiable {
    
    init(items:[MenuItem:Int], orderID: String){
        
        self.items=items
        self.orderID = orderID
        
    }
    
    //item ordered with quantity of each item
    @Published var items:[MenuItem:Int]
    
    
    @Published var cost = 0.0
    
    var orderID:String?
    
    var userID = Auth.auth().currentUser?.uid
    
    @Published  var readyForPickUp = false
    
    @Published  var completed = false
    
    @Published  var cancelled = false
    

}

//struct to display orders that havent been posted yet, used in Home file in struct HomeView


//NEED TO ADD BUTTON  TO REMOVE FROM ORDER LATER
struct NewOrderView : View {
    
    @EnvironmentObject var session:SessionStore
    
    //  @State var currOrder  = Order(items: [:], orderID: "")
    
    
    
    @State var menuItems=[MenuItem]()
    @State var count=[Int]()
    @State var orderStatus = "No items in this order yet"
    
    func submit(){
        self.session.appData?.sendOrder(order: session.appData!.currOrder)
           self.menuItems = [MenuItem]()
           self.count=[Int]()
           self.orderStatus="Order submitted!"
       }
    
    func getCurrOrder(){
        self.menuItems=Array(((self.session.appData?.currOrder.items.keys)!))
        self.count=Array(((self.session.appData?.currOrder.items.values)!))
     
        
    }
    var body : some View{
        
        Group{
            VStack(spacing: 15){
                Text("Current Order")
                .bold()
                 .foregroundColor(Color("primGreen"))
                
                if menuItems.count != 0 && count.count != 0{
                    
                    
                    
                    List( menuItems.indices){ i in
                        
            
                        Section{
                        HStack(spacing: 15){
                            
                            VStack(alignment: .leading, spacing: 15){
                                
                                
                                Text(self.menuItems[i].name)
                                Text("£"+String(format: "%.2f",self.menuItems[i].price))
                                
                                
                            }
                            Spacer()
                            VStack(alignment: .leading, spacing: 15){
                                
                                
                                
                                Text(" x\(self.count[i])")
                                
                            }
                            
                        }
                        }
                    }
                    //sets text to sum of price field of all elems in [MenuItem]
                    Text("Total: £" + String(format: "%.2f", self.menuItems.reduce(0) { $0 + $1.price * Double((session.appData?.currOrder.items[$1])!) }))
                    
                    
                    //submits order
                    Button(action:{
                        self.submit()
                    }) {
                        Text("Submit Order")
                            .foregroundColor(Color("primGreen"))
                            .bold()
                            
                    }
                    .padding(.bottom, 30)
                    
                }
                else{
                    List{
                        Text(self.orderStatus)
                    }
                }
            }
        }.onAppear(perform: getCurrOrder)
    }
}

struct Order_Previews: PreviewProvider {
    static var previews: some View {
        NewOrderView(menuItems: TestData.testMenuItem, count: TestData.count).environmentObject(SessionStore())
    }
}


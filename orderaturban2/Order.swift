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

//Purpose of this struct is to register details of orders
//Used in: OrderListComponentView, OrderListView, RTData
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
    
    //Possible states for the order, only 1 can be true at a time therefor didSet is needed to switch the others off. Order can be cancelled as long as it hasnt been completed yet. readyForPickUp is the starting point therefor setting it to true doesnt affect other bools as you can still cancel the order at this stage
    @Published  var readyForPickUp = false
    
    @Published  var completed = false {
        
           didSet{
            self.readyForPickUp = false
           }
       }

    
    @Published  var cancelled = false {
           didSet{
            self.readyForPickUp = false
           }
       }

    

}

//

//Purpose of this struct is to display orders that havent been posted yet
//Used in: Home
struct NewOrderView : View {
    
    @EnvironmentObject var session:SessionStore
    
    //  @State var currOrder  = Order(items: [:], orderID: "")
    
    
    //
    @State var menuItems=[MenuItem]()
    @State var count=[Int]()
    
    @State var orderStatus = "No items in this order yet"
    
    //sends order to firestore and resets the values in the arrays
    func submit(){
        self.session.appData?.sendOrder(order: session.appData!.currOrder)
           self.menuItems = [MenuItem]()
           self.count=[Int]()
           self.orderStatus="Order submitted!"
       }
    
    //populates the arrays with the relevant values. Had to use 2 arrays as a dictionary was causing errors
    //Used in: self's body group onAppear()
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
                    
                    
                    //formats list to display items with menu item name on the left, along with the item's price below and quantity on the right
                    
                    List( menuItems.indices){ i in
                        
            
                        Section{
                        HStack(spacing: 15){
                            
                            VStack(alignment: .leading, spacing: 15){
                                
                                //format to 2 decimal places
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


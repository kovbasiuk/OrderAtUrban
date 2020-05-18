//
//  OrderListComponentView.swift
//  orderaturban2
//
//  Created by Robert Kovbasiuk on 01/05/2020.
//  Copyright © 2020 RK. All rights reserved.
//

import SwiftUI

//purpose of struct is to display information about individual orders in the OrderListView containing all orders and their information
//Used in: OrderListView


struct OrderListComponentView: View {
    
    //observed object as order will change in real time
    @ObservedObject var order: Order
    @EnvironmentObject var session:SessionStore
    
    //used to determine the buttons available as both vendor and non vendor accounts use this view
    var vendor:Bool
    
    //state of order
    @State var cancelled: Bool
    @State var completed: Bool
    @State var readyForPickUp: Bool
    
    @State var statusMessage = ""
    
    
    
    //makes randomly generated id shorter
    func orderNumCut(id: String)->String{
        
        
        return String(id.prefix(5))
        
        
    }
    
    //Cancels the order
    //Used in: self's body button
    func Cancel(){
        self.session.appData?.CancellOrder(order: self.order)
        //finds the index of the order in the order array in order to update
        if let index = self.session.appData?.orders.firstIndex(where: { $0.orderID == self.order.orderID }) {
            self.session.appData?.orders[index].cancelled = true
        }
        
        self.cancelled = true
        self.readyForPickUp = false
        self.completed = false
        self.statusMessage = "cancelled"
        print("order cancelled")
        
    }
    //Makes the order ready for pickup
    //Used in: self's body button
    func ReadyForPickUp(){
        self.session.appData?.ReadyForPickUpOrder(order: self.order)
        //finds the index of the order in the order array in order to update
        if let index = self.session.appData?.orders.firstIndex(where: { $0.orderID == self.order.orderID }) {
            self.session.appData?.orders[index].readyForPickUp = true
        }
        
        self.readyForPickUp = true
        self.cancelled = false
        self.completed = false
        
        self.statusMessage = "ready for pickup"
        print("order ready for pickup")
    }
    
    //Completes the order
    //Used in: self's body button
    func Complete(){
        self.session.appData?.CompleteOrder(order: self.order)
        //finds the index of the order in the order array in order to update
        if let index = self.session.appData?.orders.firstIndex(where: { $0.orderID == self.order.orderID }) {
            self.session.appData?.orders[index].completed = true
            
        }
        
        self.completed = true
        self.cancelled = false
        self.readyForPickUp = false
        self.statusMessage = "completed"
        print("order completed")
        
    }
    
    
    
    var body: some View {
        
        VStack {
            
            
            
            Text("Order ID: "+orderNumCut(id: "\(String(describing: order.orderID!))"))
            HStack(spacing: 15){
                
                
                
                VStack(alignment: .leading){
                    ForEach(Array(self.order.items.keys), id: \.name) { item in
                        
                        Text("\(item.name)")
                        
                        
                    }
                    
                }
                
                VStack(alignment: .leading){
                    
                    ForEach(Array(self.order.items.values), id: \.self) { count in
                        
                        Text("x: \(count)")
                    }
                }
            }
            
            //checks booleans and determines text status of roder
            HStack {
                Text("Status: ")
                
                
                //dynamically sets the text and colour based on the status of the order
                Text( self.completed ? "completed" : self.readyForPickUp ? "ready to pick up" : self.cancelled ? "cancelled" : "waiting for update")
                    .foregroundColor(self.completed ? Color(.gray) : self.readyForPickUp ? Color("primGreen") : self.cancelled ? Color(.red) : Color(.black))
                
            }
            .padding(.top, 10)
            HStack{
                //format double to 2 decimal places
                Text("£"+String(format: "%.2f",self.order.cost))
                
                //logic conditions determin what button is displayed
                VStack {
                    if !self.completed && !self.cancelled {
                        
                        
                        
                        Button(action: self.Cancel) {
                            Text("Cancel Order")
                                
                                .padding(5)
                                .background(Color.red)
                                .cornerRadius(20)
                            
                        }
                        .buttonStyle(BorderlessButtonStyle()) //allows to be pressed individually when part of other views
                        
                        
                        //extra options available when the user is a vendor
                        if self.vendor {
                            
                            //if not ready for pickup display button to make it ready for pickup
                            //as its the first step in the completion process
                            
                            if !self.readyForPickUp && !self.completed{
                                Button(action: self.ReadyForPickUp) {
                                    Text("Ready for Pickup")
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                .padding(5)
                                .background(Color("secGreen"))
                                .cornerRadius(20)
                                .padding([.top, .bottom], 10)
                            }
                            
                            //else its the second stage of the order and the option now is to complete
                            if !self.completed && self.readyForPickUp {
                                Button(action: self.Complete ) {
                                    Text("Complete Order")
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                .padding(5)
                                .background(Color("primGreen"))
                                .cornerRadius(20)
                                .padding([.top, .bottom], 10)
                            }
                            
                        }
                    }
                    else{
                        Text("")
                    }
                    
                }
                .foregroundColor(Color.white)
                
            }
            .padding(.top, 10.0)
        }
        
        
    }
}

struct OrderListComponentView_Previews: PreviewProvider {
    static var previews: some View {
        OrderListComponentView(order: TestData.order, vendor: false, cancelled: true, completed: false, readyForPickUp:false).environmentObject(SessionStore())
    }
}

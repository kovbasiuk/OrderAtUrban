//
//  OrderListView.swift
//  orderaturban2
//
//  Created by Robert Kovbasiuk on 02/05/2020.
//  Copyright © 2020 RK. All rights reserved.
//

import SwiftUI

//list of all orders

struct OrderListView: View {
    @EnvironmentObject var session:SessionStore
   var orders : [Order]
    
    var body: some View {

        
         VStack(alignment: .center, spacing: 20) {
            Text("Orders")
                .bold()
                .foregroundColor(Color("primGreen"))
            
            if !orders.isEmpty {
                List(self.orders){ order in
                Spacer()
                OrderListComponentView(order: order, vendor: self.session.appData!.vendorAcc, cancelled: order.cancelled
                    , completed: order.completed, readyForPickUp: order.readyForPickUp)
                     .listRowInsets(EdgeInsets())
                    
                Spacer()
                }
            }
        }
    }
}

struct OrderListView_Previews: PreviewProvider {
    static var previews: some View {
        OrderListView(orders: TestData.orders).environmentObject(SessionStore())
    }
}

//
//  MenuItemDetail.swift
//  orderaturban2
//
//  Created by Robert Kovbasiuk on 01/05/2020.
//  Copyright © 2020 RK. All rights reserved.
//

import SwiftUI
import struct Kingfisher.KFImage
/*
 Struct is to make any adjustments to the image
 */

//need to optimise to use 1 class
struct menuItemDetailIMG: View{
    
    //update to geometry reader in the future
    let menuItem:MenuItem
  
    //method to avoid immatability
    func getItemURL() -> URL {
        return URL(
            string: menuItem.imgURL)!
        
    }
    
    //check kingfisher uisupport for ways to make more efficient
    var body: some View {
        
        
        
        VStack {
            ZStack(alignment: .bottom) {
                //need to sort this out might be because its not in the iage struct
                KFImage(getItemURL())
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3.5)
                    .cornerRadius(5)
                    .shadow(radius: 5)
                
                Rectangle()
                    .padding(.trailing, 20.0)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/10)
                    .cornerRadius(20)
                    .opacity(0.35)
                    .blur(radius: 10)
                
                HStack{
                    VStack(alignment: .leading,spacing: 8){
                        Text(menuItem.name)
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .multilineTextAlignment(.leading)
                        
                        //NEED OTO SORT THE PADDING OUT
                    }.padding(.trailing, 200.0)
                    
                    
                }
                    
                .padding(.bottom, 7)
                
            }
            
        }
        
        
        
        
        
        
        
        
    }
}

//struct shows detail of menu item and option to add to order
//appears from navlink in rows
struct MenuItemDetail: View {
    
    let menuItem:MenuItem
      @EnvironmentObject var session: SessionStore
    
    @State var count=1
    
    @State var calcPrice = 0.0
    
    func getInitPrice(){
        self.calcPrice = menuItem.price
    }
    
    
 
    func addOrder(){
        session.appData!.addToOrder(item: self.menuItem, count: self.count)
        print("item added to current order:  \(self.menuItem) quantity: \(self.count)")
            
    }
    
    var body: some View {
        
        Group{
        VStack {
            menuItemDetailIMG(menuItem: menuItem)
            
            
            Text("\(menuItem.desc)")
                
                .foregroundColor(.primary)
                .font(.body)
                
                .padding(.top, 30.0)

            
            Spacer()
            VStack{
                
                
              
                    
                    HStack {
                        Text("Time to prepare: ")
                        HStack{
                            Text("\(menuItem.prepTime)")
                            Text(menuItem.prepTime>1 ? "minutes" : "minute")
                        }.foregroundColor(Color("primGreen"))
                        
                      
                        
                        
                        
                    }
                    Stepper("Quantity: \(self.count)", onIncrement: {
                                      self.count+=1
                        self.calcPrice = self.menuItem.price * Double(self.count)
                                  },
                                          
                                          onDecrement:{
                                              if self.count != 1{
                                                  self.count-=1
                                                
                                                self.calcPrice = self.menuItem.price * Double(self.count)
                                              }
                                  })
                 
                        .foregroundColor(.primary)
                        
                        .padding(.trailing, 30.0)
                    //.frame(width: UIScreen.main.bounds.width/1.3)
                    .padding(.bottom, 30)
                
                
                Button(action:  {
                    self.addOrder()
                }) {
                    
                    HStack {
                        Spacer()
                        VStack {
                            
                            Text("Add to Order")
                                .foregroundColor(.white)
                               
                                .font(.title)
                            //formats double to 2 decimal places
                            //as it had unneccessarry 0s
                            Text("£"+String(format: "%.2f", self.calcPrice))
                                .foregroundColor(.white)
                                
                                .font(.title)
                        }
                            
                            
                            
                        .cornerRadius(20)
                            
                        .padding(10)
                        
                        Spacer()
                    }
                        
                    .background(Color("primGreen"))
                    
                    
                }
                    
                    
                    
                .cornerRadius(20)
            }
            .frame(width: UIScreen.main.bounds.width/1.3)
            .padding(.bottom, 30)
        }
        .edgesIgnoringSafeArea(.top)
            
        .navigationBarHidden(true)
        
        
        
    }
        .onAppear(perform: self.getInitPrice)
    }
}


struct MenuItemDetail_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemDetail(menuItem:  MenuItem(name: "tea", price: 2.5, imgURL: "https://static.independent.co.uk/s3fs-public/thumbnails/image/2020/04/11/16/istock-1213958021.jpg?w968h681", prepTime: 1, description: "need to find something to write about here", type: "hotDrinks")).environmentObject(SessionStore())
    }
}

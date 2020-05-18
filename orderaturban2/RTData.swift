//
//  RTData.swift
//  orderaturban2
//
//  Created by Robert Kovbasiuk on 01/05/2020.
//  Copyright © 2020 RK. All rights reserved.
//

import Foundation
import Firebase


//purpose of this class is to store data during the run time of the app, it is an ObservableObject because the data will be modified during run time and the the views should be updated updated accordingly when dats from this class is modified
class  RTData : ObservableObject {
    
    
    
    // array of different categories of menu items in CustMenuView
    @Published var categoriesData = [SectionMenuItem]()  //= []
    
    //array of orders
    @Published var orders = [Order]()
    
    //user account type
    @Published var vendorAcc = false
    
    //the order that the user is currently in progress of creating
    @Published var currOrder:Order
    
    init(){
        //when app is first launched, creates an empty order
        self.currOrder = Order(items: [MenuItem:Int](), orderID: UUID().uuidString)
        
        //sets menu items grouped by catgories to categoriesData
        self.getMenu()
        //downloads all relevant data about the user from firestore to determine the content displayed
        self.fullUserDownload()
    }
    
    
    
    //sets menu items grouped by catgories to categoriesData. Downloads data from firestore and groups the full array of menu items by the category type
    func getMenu() {
        let db = Firestore.firestore()
        
        var menuItems = [MenuItem]()
        
        //temp key variable gets all of the same types
        db.collection("menu_items")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot?.documents ?? [] {
                        
                        let data = document.data()
                        menuItems.append(MenuItem(data: data))
                    }
                    
                    //assigns categories data to a dictionary grouped by the tye of menuItems
                    self.categoriesData = Dictionary(grouping: menuItems) { $0.type }.map {
                        SectionMenuItem(type: $0.key, items: $0.value)
                    }
                }
                
        }
    }
    
    
    
    //downloads all relevant data about the user from firestore to determine the content displayed
    //Used in: self, Home
    func fullUserDownload(){
        self.getUserID(completion: { uid in
            
            //checks if the user is a vendor and passes a boolean through after completion
            self.checkVendorAccountStatus(uid: uid) { (isVendorAcc) in
                
                print("vendorAcc: \(self.vendorAcc)")
                
                //if vendorAcc == true then downloads all orders, if vendorAcc == false then onky downloads order which are associated with the user ID.
                self.getRelevantOrders(isVendorAcc: isVendorAcc, uid: uid)
                
                
                
            }
        })
    }
    
    
    //checks firestore if user is a vendor, method called in  selfto determine whether to set orders to getOrdersByUserID or getLiveOrders. Passes through a boolean after completion
    //Used in:  init()
    func checkVendorAccountStatus(uid: String, complation: @escaping (Bool) -> ()) {
        print("Checking if user vendorAcc is true")
        
        let db = Firestore.firestore()
        let docRef:DocumentReference?
        
        
        docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
        
        docRef?.getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data(), let vendorAcc = data["vendorAcc"] as? Bool {
                    
                    self.vendorAcc = vendorAcc
                } else {
                    self.vendorAcc = false
                    
                }
            } else {
                print("Document does not exist")
                self.vendorAcc = false
                
            }
            complation(self.vendorAcc)
        }
    }
    
    //used in function sendOrder in order to achieve concurrency when assigning array of dictionaries to json var. Passes through an array of dictionary type [String:Int] after completion
    //Used in: sendOrder()
    func createFirebaseOrderArr(completion: @escaping ([[String:Int]])->Void){
        if self.currOrder.items.count != 0 {
            
            //gets relevant values from current order's items dictionary
            var result = [[String : Int]]()
            for (key,value) in self.currOrder.items{
                
                result.append([key.name:value])
                
            }
            
            completion(result)
        }
            
        else{
            print("Order Is Empty! Cant send to Firestore")
            return
        }
        
    }
    
    //posts the order to firestore
    //Used in: NewOrderView
    func sendOrder(order: Order) {
        
        
        
        let db = Firestore.firestore()
        
        createFirebaseOrderArr(completion: ({ result in
            
            let ref =  db.collection("orders").document(self.currOrder.orderID!)
            
            
            ref.setData([
                "cancelled":false,
                "completed":false,
                "readyForPickUp":false,
                
                //result is the array of dictionary [String:Int] thats passed through from createFirebaseOrderArr()
                
                "items": result,
                "orderID": ref.documentID,
                "userID": Auth.auth().currentUser?.uid as Any,
                "price": self.currOrder.cost
                
                ])
            { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref.documentID)")
                }
            }
            
        }))
        
        //reset current order after its been sent to firestore
        self.currOrder = Order(items: [MenuItem:Int](), orderID: UUID().uuidString)
        
    }
    
    
    
    
    
    //returns individual element of menuItems as the order data downloaded from firestore only contains the menu item name
    //Used in: getOrdersByUserID()
    func getMenuItem(key: String) -> MenuItem? {
        
        for value in self.categoriesData {
            for item in value.items {
                if item.name == key {
                    return item
                }
            }
        }
        
        return nil
    }
    
    
    
    
    //gets userID in order to be used in fullUserDownload() to achieve concurrency.
    //Used in: fullUserDownload()
    func getUserID(completion: @escaping (String)->Void) {
        if let uid = Auth.auth().currentUser?.uid {
            completion(uid)
        }
    }
    
    //func downloads all orders rather than orders by an individual userID
    // func updates orders from firestore in real time by using SnapshotListener
    //Used in: getRelevantOrders()
    func  getAllLiveOrders(){
        
        let db = Firestore.firestore()
        
        db.collection("orders").addSnapshotListener({
            (snap, err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            
            //gets docunents that have been added/modified/delete
            for doc in snap!.documentChanges{
                
                if !doc.document.data().isEmpty {
                    
                    let data = doc.document.data()
                    
                    //downloads array of dictionary [String:Int] as you cant upload custom structs
                    //String is the menu item name and Int represents the quantity of the item in the order
                    let stringItems = data["items"] as? [[String: Int]] ?? []
                    
                    let orderID = data["orderID"] as? String ?? ""
                    
                    //will be used to store menuitem and its quantity in UpdatedOrder temp var in this method as only the menu item name is downloaded from firestore and the order requires a menu item struct rather just its name field
                    var finalItems=[MenuItem:Int]()
                    
                    
                    //array of maps/dictionaries from firestore order document
                    for arr in stringItems {
                        
                        
                        //always be .first due to firestore order data model
                        //each order document has an array of map [String:Int] and each map represents each item and its quantity in the order
                        if !arr.isEmpty {
                            if let item = self.getMenuItem(key: arr.keys.first!) {
                                finalItems[item] = arr.values.first
                            }
                        }
                    }
                    
                    //once the loop above populates finalItems using the menu item strings downloaded from firestore, an Order instance is able to be created to then be appeneded to self.orders
                    var updatedOrder = Order(items: finalItems, orderID: orderID)
                    
                    //downloads additional info from firestore regarding the order and sets it to updated order
                    if let  cancelled = data["cancelled"] as? Bool, let completed = data["completed"] as? Bool, let readyForPickUp = data["readyForPickUp"] as? Bool, let price = data["price"] as? Double {
                        
                        updatedOrder.cancelled = cancelled
                        updatedOrder.completed = completed
                        updatedOrder.readyForPickUp = readyForPickUp
                        updatedOrder.cost = price
                    }
                    
                    
                    //If statement check what type of change was made in the snapcshot listener
                    
                      //new orders get appended if array doesnt contain the order already
                    if doc.type == .added{
    
                            
                            if !self.orders.contains(where: {$0.orderID == orderID}){
                                
                                self.orders.append(updatedOrder)
                            }
                        
                    }
                    
                    //removed orders get removed from the array, index found using its orderID
                    if doc.type == .removed{
                        if let index = self.orders.firstIndex(where: { $0.orderID == orderID }) {
                            self.orders.remove(at: index)
                        }
                    }
                    
                    //orders with modified fields are found using orderID and replaced using the finalItems array created in this method, orderID will stay the same as before
                    if doc.type == .modified{
                        
                        self.orders[self.orders.firstIndex(where: {$0.orderID == orderID})!]  =  Order(items: finalItems, orderID: orderID)
                        
                    }
                }
                
            }
        })
        
    }
    
    
    
    //retrieves all orders of the user using the string input which will be the user's ID
    // func updates orders from firestore in real time by using SnapshotListener
    //Used in: getRelevantOrders()
    func getOrdersByUserID(id: String){
        
        let db = Firestore.firestore()
        
        //different from getAllLiveOrders() as you can see below, it only reads documents where the userID of the order is equal to the user's ID
        db.collection("orders").whereField("userID", isEqualTo: id).addSnapshotListener({
            (snap, err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            
            
            //listens for changes in firebase
            for doc in snap!.documentChanges{
                print(doc.document.data())
                
                
                if !doc.document.data().isEmpty {
                    
                    let data = doc.document.data()
                    
                    //downloads array of dictionary [String:Int] as you cant upload custom structs
                    //String is the menu item name and Int represents the quantity of the item in the order
                    let stringItems = data["items"] as? [[String: Int]] ?? []
                    
                    let orderID = data["orderID"] as? String ?? ""
                    
                    //will be used to store menuitem and its quantity in UpdatedOrder temp var in this method as only the menu item name is downloaded from firestore and the order requires a menu item struct rather just its name field
                    var finalItems=[MenuItem:Int]()
                    
                    
                    //array of maps/dictionaries from firestore order document
                    for arr in stringItems {
                        
                        
                        //always be .first due to firestore order data model
                        //each order document has an array of map [String:Int] and each map represents each item and its quantity in the order
                        if !arr.isEmpty {
                            if let item = self.getMenuItem(key: arr.keys.first!) {
                                finalItems[item] = arr.values.first
                            }
                        }
                    }
                    
                    //once the loop above populates finalItems using the menu item strings downloaded from firestore, an Order instance is able to be created to then be appeneded to self.orders
                    var updatedOrder = Order(items: finalItems, orderID: orderID)
                    
                    //downloads additional info from firestore regarding the order and sets it to updated order
                    if let  cancelled = data["cancelled"] as? Bool, let completed = data["completed"] as? Bool, let readyForPickUp = data["readyForPickUp"] as? Bool, let price = data["price"] as? Double {
                        
                        updatedOrder.cancelled = cancelled
                        updatedOrder.completed = completed
                        updatedOrder.readyForPickUp = readyForPickUp
                        updatedOrder.cost = price
                    }
                    
                    
                    //If statements check what type of change was made in the snapcshot listener
                    
                    //new orders get appended if array doesnt contain the order already
                    if doc.type == .added{
                        
                        if !self.orders.contains(where: {$0.orderID == orderID}){
                            
                            self.orders.append(updatedOrder)
                        }
                        
                    }
                    
                    //removed orders get removed from the array, index found using its orderID
                    if doc.type == .removed{
                        if let index = self.orders.firstIndex(where: { $0.orderID == orderID }) {
                            self.orders.remove(at: index)
                        }
                    }
                    
                    //orders with modified fields are found using orderID and replaced using the finalItems array created in this method, orderID will stay the same as before
                    if doc.type == .modified{
                        
                        self.orders[self.orders.firstIndex(where: {$0.orderID == orderID})!]  =  Order(items: finalItems, orderID: orderID)
                        
                    }
                }
            }
        })
    }
    
    
    //func to determine which set of orders to download
    //Used in: getRelevantOrders
    func getRelevantOrders(isVendorAcc: Bool, uid: String){
        if isVendorAcc {
            self.getAllLiveOrders()
        } else {
            self.getOrdersByUserID(id: uid)
            
        }
        
    }
    
    
    //Adds menu Item along with its quantity to currOrder
    //Used in: MenuItemDetail
    
    func addToOrder(item: MenuItem, count: Int){
        //checks if currOrder already contains this item if it does then accesses the [MenuItem:Int] "items" dictionary and increments the dictionary value by count
        if self.currOrder.items.contains(where: {$0.key.name == item.name}){
            self.currOrder.items[item]! += count
        }
        else{
            //adds the tuple to the doctionary
            self.currOrder.items[item]=count
            self.currOrder.cost += (item.price*Double(count))
        }
    }
    
    
    //cancells order by updating its firebase values, since the user gets orders in real time rathan than a single download, either getOrdersByUserID() or getAllLiveOrders depending on whether the user is on a vendor account, will update the order array.
    //Used in: OrderListComponentView
    func CancellOrder(order: Order){
        
        
        let db = Firestore.firestore()
        
        
        if let id = order.orderID{
            let orderRef = db.collection("orders").document(id)
            // Set the "capital" field of the city 'DC'
            orderRef.updateData([
                "cancelled": true,
                "completed": false,
                "readyForPickUp":false
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            
        }
    }
    
    
    //completes order by updating its firebase values, since the user gets orders in real time rathan than a single download, either getOrdersByUserID() or getAllLiveOrders depending on whether the user is on a vendor account, will update the order array.
    //Used in: OrderListComponentView
    func CompleteOrder(order: Order){
        let db = Firestore.firestore()
        
        
        if let id = order.orderID{
            let orderRef = db.collection("orders").document(id)
            // Set the "capital" field of the city 'DC'
            orderRef.updateData([
                "cancelled": false,
                "completed": true,
                "readyForPickUp":false
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            
            
        }
    }
    
    
    //sets order to be ready for pickup by updating its firebase values, since the user gets orders in real time rathan than a single download, either getOrdersByUserID() or getAllLiveOrders depending on whether the user is on a vendor account, will update the order array.
    //Used in: OrderListComponentView
    func ReadyForPickUpOrder(order: Order){
        let db = Firestore.firestore()
        
        
        if let id = order.orderID{
            let orderRef = db.collection("orders").document(id)
            // Set the "capital" field of the city 'DC'
            orderRef.updateData([
                "cancelled": false,
                "completed": false,
                "readyForPickUp":true
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            
        }
    }
    
}

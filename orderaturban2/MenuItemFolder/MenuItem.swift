//
//  MenuItem.swift
//  orderaturban2
//
//  Created by Robert Kovbasiuk on 01/05/2020.
//  Copyright © 2020 RK. All rights reserved.
//

import Foundation

//struct used to register menu items downloaded from firestore
struct MenuItem: Identifiable, Hashable {
    
    //random id to satisfy identifiable
    var id = UUID()
    
    let name: String
    let price: Double
    let imgURL: String
    let prepTime: Int
    let desc: String
    let type: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(name: String, price: Double, imgURL: String, prepTime: Int, description: String, type: String) {
        self.name = name
        self.price = price
        self.imgURL = imgURL
        self.prepTime = prepTime
        self.desc = description
        self.type = type
    }
    
    init(data: [String: Any]) {
        name = data["name"] as? String ?? "No Name"
        imgURL = data["imgURL"] as? String ?? "No img URL"
        price = data["price"] as? Double ?? 0
        desc = data["description"] as? String ?? "No description"
        prepTime = data["prepTime"] as? Int ?? 0
        type = data["type"] as? String ?? "Other"
    }
}
    


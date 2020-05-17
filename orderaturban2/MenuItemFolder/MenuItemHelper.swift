//
//  MenuItemHelper.swift
//  orderaturban2
//
//  Created by by Robert Kovbasiuk on 09/05/2020.
//  Copyright © 2020 RK. All rights reserved.
//

import Foundation
import Firebase


struct SectionMenuItem: Identifiable {

    var id = UUID()
    let type: String
    let items: [MenuItem]
    
    func name() -> String {
        switch type {
        case "hotDrinks": return "Hot Drinks"
        case "coldDrinks": return "Cold Drinks"
        case "hotFood": return "Hot Food"
        case "deserts": return "Deserts"
        case "coldFood": return "Cold Food"
        default:
            return "Other"
        }
    }
}

class MenuItemHelper {
    
    static var shared = MenuItemHelper()
    var menuItems=[SectionMenuItem]()

    func getMenu(completion: @escaping (() -> Void)) {
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
                    
                    MenuItemHelper.shared.menuItems = Dictionary(grouping: menuItems) { $0.type }.map {
                        SectionMenuItem(type: $0.key, items: $0.value)
                    }
                }
                completion()
        }
    }
}

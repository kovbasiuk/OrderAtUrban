//
//  TestData.swift
//  orderaturban2
//
//  Created by Robert Kovbasiuk on 01/05/2020.
//  Copyright © 2020 RK. All rights reserved.
//

import Foundation

struct TestData {
    
    
    
    static var x = MenuItem(name: "coffee", price: 1.0, imgURL: "https://static.independent.co.uk/s3fs-public/thumbnails/image/2020/04/11/16/istock-1213958021.jpg?w968h681", prepTime: 1, description: "need to find something to write about herthfthfhfte", type: "hotDrinks")

    static  var x1 = MenuItem(name: "tea", price: 1.5, imgURL: "https://static.independent.co.uk/s3fs-public/thumbnails/image/2020/04/11/16/istock-1213958021.jpg?w968h681", prepTime: 1, description: "need to find something to write about htfhtfhtfhere", type: "hotDrinks")

    static  var x2 = MenuItem(name: "cheese bacon pannini", price: 1.0, imgURL: "https://static.independent.co.uk/s3fs-public/thumbnails/image/2020/04/11/16/istock-1213958021.jpg?w968h681", prepTime: 1, description: "need to find something to write about here", type: "hotDrinks")
    static  var x3 = MenuItem(name: "bread", price: 1.0, imgURL: "https://static.independent.co.uk/s3fs-public/thumbnails/image/2020/04/11/16/istock-1213958021.jpg?w968h681", prepTime: 1, description: "need to find something to write about here", type: "hotDrinks")

    static let  testMenuItem = [x,x1,x2,x3]
    
    var dict = ["items":testMenuItem]
    
    static let count = [1,2,1,1]

    static let order =  Order(items:[x:1,x1:2,x2:1,x3:1], orderID: UUID().uuidString)
    static let order1 = Order(items:[x:1,x1:2,x2:1,x3:1], orderID: UUID().uuidString)
    static let order2 = Order(items:[x:1,x1:2,x2:1,x3:1], orderID: UUID().uuidString)
    static let order3 = Order(items:[x:1,x1:2,x2:1,x3:1], orderID: UUID().uuidString)
    
   static var orders = [order, order1, order2, order3]
    
}

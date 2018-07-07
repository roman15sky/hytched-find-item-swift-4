//
//  Product.swift
//  Hytched
//
//  Created by Admin on 27/06/2018.
//  Copyright © 2018 Elizabeth Dranja. All rights reserved.
//

import Foundation

class Product: NSObject {
    
    var thumbnailImageUrl : String
    var shortDescription : String
    var name : String
    var customerRating : Float
    var numReviews : Int
    var price : Float
    var productUrl : String
    
    init(thumbnailImageUrl:String, shortDescription:String, name:String, customerRating:Float, numReviews:Int, price:Float, productUrl:String) {
        self.thumbnailImageUrl = thumbnailImageUrl
        self.shortDescription = shortDescription
        self.name = name
        self.customerRating = customerRating
        self.numReviews = numReviews
        self.price = price
        self.productUrl = productUrl
    }
    
}

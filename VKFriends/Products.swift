//
//  Products.swift
//  
//
//  Created by Kirill Averyanov on 20/11/2016.
//
//

import Foundation


public struct Products {
    
    public static let BuingFriend = "com.kirillzzy.vkfriends.buingfriend"
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [Products.BuingFriend]
    
    public static let store = IAPHelper(productIds: Products.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}

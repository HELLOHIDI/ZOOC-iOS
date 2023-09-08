//
//  Int+.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/25.
//

import Foundation

extension Int {
    
    var priceTextWithSpacing: String {
        get {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            
            var priceString = numberFormatter.string(for: self) ?? "-1"
            priceString = priceString + " 원"
            return priceString
        }
    }
    
    var priceText: String {
        get {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            
            var priceString = numberFormatter.string(for: self) ?? "-1"
            priceString = priceString + "원"
            return priceString
        }
    }
}

//
//  String+.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/08.
//

import Foundation

extension String {
    
    var hasText: Bool {
        return !isEmpty
    }
    
    func isMoreThan(_ length: Int) -> Bool {
        return self.count > length
    }
    
    func transform() -> AppVersion {
        self.split(separator: ".").map { Int($0) ?? 0 }
    }
}
    

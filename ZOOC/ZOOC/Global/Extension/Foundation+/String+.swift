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
    
      // MARK: - 휴대폰 번호 검증
    public func validatePhone(number: String) -> Bool {
        let regex = "^01([0|1|6|7|8|9])-?([0-9]{3,4})-?([0-9]{4})$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: number)
    }
    
    public var withHypen: String {
        var stringWithHypen: String = self
        
        stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.startIndex, offsetBy: 3))
        stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.endIndex, offsetBy: -4))
        
        return stringWithHypen
      }
    
}
    
extension String {
    func substring(from: Int, to: Int) -> String {
        guard from < count, to >= 0, to - from >= 0 else {
            return ""
        }
        
        // Index 값 획득
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to + 1) // '+1'이 있는 이유: endIndex는 문자열의 마지막 그 다음을 가리키기 때문
        
        // 파싱
        return String(self[startIndex ..< endIndex])
    }
}
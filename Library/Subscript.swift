//
//  Subscript.swift
//  AppDeveloperKit_String
//
//  Created by Scott Carter on 11/25/18.
//  Copyright © 2018 Scott Carter. All rights reserved.
//


// The following methods could potentially clash with another String extension, so
// they are provided as a separate file.


// Can't subscript String with integer range
// https://github.com/apple/swift/blob/b8401e1fde52d95e5a8ce7b043a3c5a3bcf72181/stdlib/public/core/UnavailableStringAPIs.swift.gyb#L15
//
// Swift documentation - Strings and Characters
// https://docs.swift.org/swift-book/LanguageGuide/StringsAndCharacters.html
//


public extension String {
    
    
    subscript (range: CountableClosedRange<Int>) -> String {
        get {
            let start = index(startIndex, offsetBy: range.lowerBound)
            let end = index(startIndex, offsetBy: range.upperBound)
            
            return String(self[start...end])
        }
        set {
            let start = index(startIndex, offsetBy: range.lowerBound)
            let end = index(startIndex, offsetBy: range.upperBound)
            
            self = self.replacingCharacters(in: start...end, with: newValue)
        }
    }
    
    subscript (range: CountableRange<Int>) -> String {
        get {
            let start = index(startIndex, offsetBy: range.lowerBound)
            let end = index(startIndex, offsetBy: range.upperBound)
            
            return String(self[start..<end])
        }
        set {
            let start = index(startIndex, offsetBy: range.lowerBound)
            let end = index(startIndex, offsetBy: range.upperBound)
            
            self = self.replacingCharacters(in: start..<end, with: newValue)
        }
    }
    
    
    subscript(i:Int) -> String {
        get {
            let start = index(startIndex, offsetBy: i)

            return String(self[start...start])
        }
        set {
            let start = index(startIndex, offsetBy: i)
            
            self = replacingCharacters(in: start...start, with: newValue)
        }
    }
    
    
}

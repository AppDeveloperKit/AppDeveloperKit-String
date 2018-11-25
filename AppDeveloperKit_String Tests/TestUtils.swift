//
//  TestUtils.swift
//  AppDeveloperKit_String Tests
//
//  Created by Scott Carter on 11/25/18.
//  Copyright © 2018 Scott Carter. All rights reserved.
//

import Foundation


class TestUtils  {
    
    
    

    class func errorMsg (_ message: String, filePath: String = #file, function: String = #function,  line: Int32 = #line) -> String {
        
        let ns = filePath as NSString;
        let file: String = ns.lastPathComponent as String
        
        let prefix = "\(file) -\(function)(\(line)):"
        
        let msg = "\(prefix) \(message)\n"
        
        return msg
    }
    

    
    
    // Return an array filled out to "count" elements from arr.
    //
    // Truncate length of returned array at count.
    // If number of elements of arr are fewer than count, fill out resulting array with nil.
    //
    class func sizedArray(arr: [String], fillToCount count: Int)-> [String?] {
        
        var elemArr = [String?](repeating: nil, count: count)
        
        for i in 0..<arr.count {
            if i >= count {
                break
            }
            elemArr[i] = arr[i]
        }
        
        return elemArr
    }
    
    
    
    // Array from tuple
    //
    // Reference:
    // https://appventure.me/2015/07/19/tuples-swift-advanced-usage-best-practices/
    //
    class func arrayFromTuple(tuple: Any?) -> [String?] {
        
        // Handle single value tuple that has a nil element.  Comes through as tuple == nil
        if tuple == nil {
            return [nil]
        }
        
        let mirror = Mirror(reflecting: tuple ?? [nil])
        var result: [String?] = []
        
        // Handle single value tuple that has a non-nil element. Comes through as tuple == string value
        if mirror.children.count == 0 {
            if let str = tuple as? String {
                return [str]
            }
            else {
                assertionFailure("Expecting only tuples containing String?")
                return [nil]
            }
        }
        
        for (_, value) in mirror.children {
            result.append(value as? String)
        }
        
        return result
    }
    
}





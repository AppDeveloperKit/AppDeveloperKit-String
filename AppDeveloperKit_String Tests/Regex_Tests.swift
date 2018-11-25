//
//  Regex_Tests.swift
//  AppDeveloperKit_String Tests
//
//  Created by Scott Carter on 11/25/18.
//  Copyright © 2018 Scott Carter. All rights reserved.
//

import XCTest

import AppDeveloperKit_String


class Regex_Tests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }


    // General Note:
    // The goal of Regex testing is just to test the interface to the underlying String extension,
    // since Regex methods are just wrappers.
    //
    // Where applicable:
    //
    // We will test the connection of preMatch, match and postMatch (closure args) by ensuring that
    // they are unique from each other.
    //
    // We will test the connection of flags by ensuring that a flag ("i" or "g") is necessary for a match
    //

    
    
    
    func testBool() {
        
        var result: Bool = Regex.m(str: "A", pattern: "a", flags: "i")
        XCTAssertTrue(result)
        
        result = Regex.m(str: "A", pattern: "a", flags: "")
        XCTAssertFalse(result)
    }
    
    
    func testSubstitution() {
        
        var str = "AB CD"
        let count = Regex.s(str: &str, pattern: "([a-z])([a-z])", replacement: "$2$1", flags: "ig")
        
        XCTAssert(str == "BA DC")
        XCTAssertTrue(count == 2)
    }
    
    
    
    // Test optional and non-optional array result.
    func testArray() {
        
        if let result = checkArrayMatch(s: "5A6", pat: "([a-z])", pre: "5", m: "A", post: "6", arr: ["A"], flags: "ig") {
            XCTFail(result)
            return
        }

        // Leave off the "i" flag to result in no match.  In checkArrayMatch() we will check for nil in optional array result,
        // and empty array in non-optional array result.
        if let result = checkArrayMatch(s: "5AB6", pat: "([a-z])", pre: nil, m: nil, post: nil, arr: [], flags: "g") {
            XCTFail(result)
            return
        }

    }
    
    
    
    // This test will check tuple results (capture groups) ranging in size from 1 - 10 elements.
    //
    // Our test will range from (a) to (a)(b)...(j), ie. 10 iterations of loop below.  For each
    // of these iterations, we will check all 10 possible tuple return results - see checkTupleMatch()
    // method.
    func testTuples() {
        
        let startChar = Unicode.Scalar("a").value
        let endChar = Unicode.Scalar("j").value
        
        var s = ""
        var pat = ""
        var arrUpper: [String] = []
        
        for alpha in startChar...endChar {
            let char = Unicode.Scalar(alpha)!
            let charStr = String(char)
            
            s = s + charStr             // Every iteration adds a new character ab...
            pat = pat + "(\(charStr))"  // (a)(b)..
            arrUpper.append(charStr.uppercased()) // ["A","B",...]
            
            let preMatch = "5"
            let postMatch = "6"
            s = s.uppercased()   // AB...
            let str = "\(preMatch)\(s)\(postMatch)"
                        
            if let result = checkTupleMatch(str: str, pat: pat, pre: preMatch, m: s, post: postMatch, arr: arrUpper, flags: "i") {
                XCTFail(result)
                return
            }
            
            
        }
        
    }
    


    // Return a tuple match with closure results.
    //
    func tupleMatchResult(count: Int, s str: String, pat pattern: String, flags: String) -> (tuple: Any?, preMatch: String?, match: String?, postMatch: String?) {
        var tuple1: (String?)
        var tuple2: (String?, String?)
        var tuple3: (String?, String?, String?)
        var tuple4: (String?, String?, String?, String?)
        var tuple5: (String?, String?, String?, String?, String?)
        var tuple6: (String?, String?, String?, String?, String?, String?)
        var tuple7: (String?, String?, String?, String?, String?, String?, String?)
        var tuple8: (String?, String?, String?, String?, String?, String?, String?, String?)
        var tuple9: (String?, String?, String?, String?, String?, String?, String?, String?, String?)
        var tuple10: (String?, String?, String?, String?, String?, String?, String?, String?, String?, String?)
        
        var tuple: Any?
        
        
        var preMatch: String?
        var match: String?
        var postMatch: String?
        
        
        switch count {
        case 1:
            tuple1 = Regex.m(str: str, pattern: pattern, flags: flags, completion: { (_preMatch,_match,_postMatch) in
                preMatch = _preMatch
                match = _match
                postMatch = _postMatch
            })
            tuple = tuple1
        case 2:
            tuple2 = Regex.m(str: str, pattern: pattern, flags: flags, completion: { (_preMatch,_match,_postMatch) in
                preMatch = _preMatch
                match = _match
                postMatch = _postMatch
            })
            tuple = tuple2
        case 3:
            tuple3 = Regex.m(str: str, pattern: pattern, flags: flags, completion: { (_preMatch,_match,_postMatch) in
                preMatch = _preMatch
                match = _match
                postMatch = _postMatch
            })
            tuple = tuple3
        case 4:
            tuple4 = Regex.m(str: str, pattern: pattern, flags: flags, completion: { (_preMatch,_match,_postMatch) in
                preMatch = _preMatch
                match = _match
                postMatch = _postMatch
            })
            tuple = tuple4
        case 5:
            tuple5 = Regex.m(str: str, pattern: pattern, flags: flags, completion: { (_preMatch,_match,_postMatch) in
                preMatch = _preMatch
                match = _match
                postMatch = _postMatch
            })
            tuple = tuple5
        case 6:
            tuple6 = Regex.m(str: str, pattern: pattern, flags: flags, completion: { (_preMatch,_match,_postMatch) in
                preMatch = _preMatch
                match = _match
                postMatch = _postMatch
            })
            tuple = tuple6
        case 7:
            tuple7 = Regex.m(str: str, pattern: pattern, flags: flags, completion: { (_preMatch,_match,_postMatch) in
                preMatch = _preMatch
                match = _match
                postMatch = _postMatch
            })
            tuple = tuple7
        case 8:
            tuple8 = Regex.m(str: str, pattern: pattern, flags: flags, completion: { (_preMatch,_match,_postMatch) in
                preMatch = _preMatch
                match = _match
                postMatch = _postMatch
            })
            tuple = tuple8
        case 9:
            tuple9 = Regex.m(str: str, pattern: pattern, flags: flags, completion: { (_preMatch,_match,_postMatch) in
                preMatch = _preMatch
                match = _match
                postMatch = _postMatch
            })
            tuple = tuple9
        case 10:
            tuple10 = Regex.m(str: str, pattern: pattern, flags: flags, completion: { (_preMatch,_match,_postMatch) in
                preMatch = _preMatch
                match = _match
                postMatch = _postMatch
            })
            tuple = tuple10
        default:
            assertionFailure("Unhandled tuple")
        }
    
        
        return (tuple, preMatch, match, postMatch)
    }

    
    
    // Check tuple return result with a closure
    func checkTupleMatch(str: String, pat pattern: String, pre preMatch: String?, m match: String?, post postMatch: String?, arr: [String], flags: String) -> String? {
        
        var tupleArr: [String?] = []  // Version of arr that is truncated or filled out with nil as needed.
        var tupleArrResult: [String?] = []
        
        var result: (tuple: Any?, preMatch: String?, match: String?, postMatch: String?)
        
        
        // We support up to 10 return values in a tuple
        for count in 1...10 {
            
            result = tupleMatchResult(count: count, s: str, pat: pattern, flags: flags)
            tupleArrResult = TestUtils.arrayFromTuple(tuple: result.tuple)
            tupleArr = TestUtils.sizedArray(arr: arr, fillToCount: count)
            
            if tupleArrResult != tupleArr {
                return TestUtils.errorMsg("Tuple x \(count) result incorrect.  Expected \(tupleArr)   Got \(tupleArrResult)")
            }
            
            if result.preMatch != preMatch {
                return TestUtils.errorMsg("preMatch result incorrect. Expected \(String(describing: preMatch)) Got \(String(describing: result.preMatch))")
            }
            if result.match != match {
                return TestUtils.errorMsg("match result incorrect. Expected \(String(describing: match)) Got \(String(describing: result.match))")
            }
            if result.postMatch != postMatch {
                return TestUtils.errorMsg("postMatch result incorrect. Expected \(String(describing: postMatch)) Got \(String(describing: result.postMatch))")
            }
            
        }
        
        return nil
    }
    
    

    
    // Check array return result with a closure
    func checkArrayMatch(s str: String, pat pattern: String, pre preMatch: String?, m match: String?, post postMatch: String?, arr: [String], flags: String) -> String? {
        
        var arrResult: [String] = []
        var arrResultOptional: [String]?
        
        var preMatchResult: String?
        var matchResult: String?
        var postMatchResult: String?
        
        
        //
        // Array, closure
        //
        arrResult = Regex.m(str: str, pattern: pattern, flags: flags, completion: { (_preMatch,_match,_postMatch) in
            preMatchResult = _preMatch
            matchResult = _match
            postMatchResult = _postMatch
        })
        
        if preMatchResult != preMatch {
            return TestUtils.errorMsg("preMatch result incorrect. Expected \(String(describing: preMatch)) Got \(String(describing: preMatchResult))")
        }
        if matchResult != match {
            return TestUtils.errorMsg("match result incorrect. Expected \(String(describing: match)) Got \(String(describing: matchResult))")
        }
        if postMatchResult != postMatch {
            return TestUtils.errorMsg("postMatch result incorrect. Expected \(String(describing: postMatch)) Got \(String(describing: postMatchResult))")
        }
        
        if arr != arrResult {
            return TestUtils.errorMsg("Array result incorrect.  Expected \(arr)  Got \(arrResult)")
        }
        
        
        //
        // Optional array, closure
        //
        arrResultOptional = Regex.m(str: str, pattern: pattern, flags: flags, completion: { (_preMatch,_match,_postMatch) in
            preMatchResult = _preMatch
            matchResult = _match
            postMatchResult = _postMatch
        })
        
        
        if preMatchResult != preMatch {
            return TestUtils.errorMsg("preMatch result incorrect.  Expected \(String(describing: preMatch)) Got \(String(describing: preMatchResult))")
        }
        
        
        if matchResult != match {
            return TestUtils.errorMsg("match result incorrect. Expected \(String(describing: match)) Got \(String(describing: matchResult))")
        }
        
        if postMatchResult != postMatch {
            return TestUtils.errorMsg("postMatch result incorrect. Expected \(String(describing: postMatch)) Got \(String(describing: postMatchResult))")
        }
        
        
        if arr.isEmpty {
            if arrResultOptional != nil {
                return TestUtils.errorMsg("Array result not nil")
            }
        }
        else {
            if arr != arrResultOptional {
                return TestUtils.errorMsg("Array result incorrect.  Expected \(arr)  Got \(String(describing: arrResultOptional))")
            }
        }
        
        
        return nil
    }
    

}

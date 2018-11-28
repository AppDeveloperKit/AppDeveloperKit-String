//
//  String_Tests.swift
//  AppDeveloperKit_String Tests
//
//  Created by Scott Carter on 11/25/18.
//  Copyright © 2018 Scott Carter. All rights reserved.
//

import XCTest

import AppDeveloperKit_String

class String_Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    func testSpecial() {
        
        
        // Test case where a capture group is not part of a match.  This has to be handled specially in our library.
        if let result = checkMatch(s: "4", pat: "(a)|(\\S)", pre: "", m: "4", post: "", arr: ["4"]) {
            XCTFail(result)
        }

        if let result = checkMatch(s: "4", pat: "(\\S)|(a)", pre: "", m: "4", post: "", arr: ["4"]) {
            XCTFail(result)
        }
        
        
        // Varying length unicode sequence.
        // Nice unicode article: http://cyrilwei.me/swift/2016/08/31/the-emoji.html
        //
        // Note:  Can't use \S to match a unicode character that is composed of 2 or more values in a sequence.
        //        Use \X to match a a Grapheme Cluster (\S would match one value in the sequence).
        // ⚽︎  "\u{26BD}\u{FE0E}"
        // ♡  "\u{2661}"
        // 😎  "\u{1F60E}"
        // 👨‍❤️‍💋‍👨 "\u{01F468}\u{200D}\u{002764}\u{00FE0F}\u{200D}\u{01F48B}\u{200D}\u{01F468}"
        // 👩‍🚀 "\u{01F469}\u{200D}\u{01F680}"
        //
        
        if let result = checkSubstitution(s: "A⚽︎ X😎", pat: "([a-z])(\\X)", replacement: "$1$2♡$2$1", expected: "A⚽︎♡⚽︎A X😎♡😎X", numReplacements: 2, flags: "ig") {
            XCTFail(result)
        }
        
        
        // Test a ZWJ sequence

        // Won't match against 👩‍🚀
        if let result = checkMatch(s: "😎A👩‍🚀", pat: "(\\X)", pre: "😎", m: "A", post: "👩‍🚀", arr: ["😎","A"], flags: "g") {
            XCTFail(result)
        }

        // Will match 👩‍🚀   Pattern matches single grapheme cluster or ZWJ sequence
        if let result = checkMatch(s: "😎A👩‍🚀", pat: "(\\X(?:\u{200D}\\X)*)", pre: "😎A", m: "👩‍🚀", post: "", arr: ["😎","A","👩‍🚀"], flags: "g") {
            XCTFail(result)
        }

        // Without global flag.
        if let result = checkMatch(s: "😎A👩‍🚀", pat: "(\\X(?:\u{200D}\\X)*)", pre: "", m: "😎", post: "A👩‍🚀", arr: ["😎"], flags: "") {
            XCTFail(result)
        }

        
        // Reverse sequence of mix of types of characters
        let pattern =  String(repeating: "(\\X(?:\u{200D}\\X)*)", count: 4) // Capture groups for 4 Unicode characters
        if let result = checkSubstitution(s: "A👩‍🚀😎👨‍❤️‍💋‍👨", pat: pattern, replacement: "$4$3$2$1", expected: "👨‍❤️‍💋‍👨😎👩‍🚀A", numReplacements: 1, flags: "") {
            XCTFail(result)
        }
        
        
    }
    
    
    
    // Test matching using the "g" global flag.
    func testGlobal() {
        
        // No capture groups - matches only returned in array
        if let result = checkMatch(s: "1b2 3b2 5b6", pat: "b2", pre: "1b2 3", m: "b2", post: " 5b6", arr: ["b2","b2"], flags: "g") {
            XCTFail(result)
        }
        
        // Capture groups returned in array
        if let result = checkMatch(s: "1b2 3b2 5b6", pat: "b(2|6)", pre: "1b2 3b2 5", m: "b6", post: "", arr: ["2","2","6"], flags: "g") {
            XCTFail(result)
        }

        if let result = checkMatch(s: "1b2 3b2 5b6", pat: "(b(2|6))", pre: "1b2 3b2 5", m: "b6", post: "", arr: ["b2", "2", "b2", "2", "b6",  "6"], flags: "g") {
            XCTFail(result)
        }

        if let result = checkMatch(s: "1b2 3b2 5b6", pat: "((b)(2))", pre: "1b2 3", m: "b2", post: " 5b6", arr: ["b2", "b", "2", "b2", "b",  "2"], flags: "g") {
            XCTFail(result)
        }

        // Try a pattern to match words
        if let result = checkMatch(s: "1b2 3b2 5b6", pat: "\\w+", pre: "1b2 3b2 ", m: "5b6", post: "", arr: ["1b2","3b2","5b6"], flags: "g") {
            XCTFail(result)
        }

        // No difference here - capture group same as match.
        if let result = checkMatch(s: "1b2 3b2 5b6", pat: "(\\w+)", pre: "1b2 3b2 ", m: "5b6", post: "", arr: ["1b2","3b2","5b6"], flags: "g") {
            XCTFail(result)
        }

        
    }
    
    
    func testSubstitution() {
        
        if let result = checkSubstitution(s: "", pat: "", replacement: "", expected: "", numReplacements: 0) {
            XCTFail(result)
        }

        if let result = checkSubstitution(s: "abc", pat: "", replacement: "", expected: "abc", numReplacements: 0) {
            XCTFail(result)
        }

        if let result = checkSubstitution(s: "", pat: "abc", replacement: "", expected: "", numReplacements: 0) {
            XCTFail(result)
        }

        if let result = checkSubstitution(s: "a b c", pat: "\\s+", replacement: "", expected: "ab c", numReplacements: 1) {
            XCTFail(result)
        }

        
        // Case sensitive is the default without "i" flag.
        if let result = checkSubstitution(s: "abc", pat: "B", replacement: "X", expected: "abc", numReplacements: 0) {
            XCTFail(result)
        }

        
        
        // Test flags
        //
        if let result = checkSubstitution(s: "a b c", pat: "\\s+", replacement: "", expected: "abc", numReplacements: 2, flags: "g") {
            XCTFail(result)
        }
        
        if let result = checkSubstitution(s: "abc", pat: "B", replacement: "X", expected: "aXc", numReplacements: 1, flags: "i") {
            XCTFail(result)
        }

        if let result = checkSubstitution(s: "abc abc", pat: "B", replacement: "X", expected: "aXc abc", numReplacements: 1, flags: "i") {
            XCTFail(result)
        }

        if let result = checkSubstitution(s: "abc abc", pat: "B", replacement: "X", expected: "aXc aXc", numReplacements: 2, flags: "ig") {
            XCTFail(result)
        }

        
    }
    
    
    func testSubstitutionWithTemplate() {
        
        
        // Include escaped used subpattern match - $2
        if let result = checkSubstitution(s: "ab xy", pat: "(\\w)(\\w)", replacement: "$2-$1-\\$2", expected: "b-a-$2 y-x-$2", numReplacements: 2, flags: "g") {
            XCTFail(result)
        }
        
        // Include unused subpattern match - $3
        if let result = checkSubstitution(s: "ab xy", pat: "(\\w)(\\w)", replacement: "$3-$2-$1-\\$2", expected: "-b-a-$2 -y-x-$2", numReplacements: 2, flags: "g") {
            XCTFail(result)
        }
        
        // Include escaped unused subpattern match - $4
        if let result = checkSubstitution(s: "ab xy", pat: "(\\w)(\\w)", replacement: "\\$4$3-$2-$1-\\$2", expected: "$4-b-a-$2 $4-y-x-$2", numReplacements: 2, flags: "g") {
            XCTFail(result)
        }
        
        
        // Special case: input string contains substring that looks like subpattern match.
        if let result = checkSubstitution(s: "$1", pat: "(\\$\\w)", replacement: "$1-\\$1", expected: "$1-$1", numReplacements: 1, flags: "g") {
            XCTFail(result)
        }
        
        // Special case: Make sure that all substrings in input string that look like subpattern match are handled.
        if let result = checkSubstitution(s: "$1$2", pat: "(\\$\\w\\$\\w)", replacement: "$1", expected: "$1$2", numReplacements: 1, flags: "g") {
            XCTFail(result)
        }
        
    }

    
    
    func checkSubstitution(s str: String, pat pattern: String, replacement: String, expected: String, numReplacements: Int, flags: String = "") -> String? {
        
        var inputStr = str;
        
        var replaced = 0
        
        if flags == "" {
            replaced = inputStr =~ (.S, pattern, replacement)
            
            if inputStr != expected {
                return TestUtils.errorMsg("Got: \(inputStr) Expected: \(expected)")
            }
            
            if replaced != numReplacements {
                return TestUtils.errorMsg("Got \(replaced) replacements  Expected \(numReplacements)")
            }
        }
        
        inputStr = str
        replaced = inputStr =~ (.S, pattern, replacement, flags)
        
        if inputStr != expected {
            return TestUtils.errorMsg("Got: \(inputStr) Expected: \(expected)")
        }
        
        if replaced != numReplacements {
            return TestUtils.errorMsg("Got \(replaced) replacements  Expected \(numReplacements)")
        }
        
        return nil
    }
    
    
    func testBoolMatch() {
        
        if let result = checkBoolMatch(s: "", pat: "", expected: false) {  // Invalid pattern
            XCTFail(result)
        }

        if let result = checkBoolMatch(s: "abc", pat: "", expected: false) {
            XCTFail(result)
        }

        if let result = checkBoolMatch(s: "", pat: "abc", expected: false) {
            XCTFail(result)
        }

        
        if let result = checkBoolMatch(s: "abc", pat: "b", expected: true) {
            XCTFail(result)
        }

        if let result = checkBoolMatch(s: "abc", pat: "B", expected: false) {
            XCTFail(result)
        }

        if let result = checkBoolMatch(s: "abc", pat: "B", expected: true, flags: "i") {
            XCTFail(result)
        }

        
    }
    
    func checkBoolMatch(s str: String, pat pattern: String, expected: Bool, flags: String = "") -> String? {
        
        var result: Bool
        
        if flags == "" {
            result = str =~ (.M, pattern)
            
            if result != expected {
                return TestUtils.errorMsg("Got: \(result) Expected: \(expected)")
            }
        }
        
        result = str =~ (.M, pattern, flags)
        
        if result != expected {
            return TestUtils.errorMsg("Got: \(result) Expected: \(expected)")
        }

        return nil
    }
    

    
    func testBasics() {
        
        // Pattern "" not valid.  Will throw from NSRegularExpression(pattern:options:).  Expecting no match.
        if let result = checkMatch(s: "", pat: "", pre: nil, m: nil, post: nil, arr: []) {
            XCTFail(result)
        }

        // Ditto.
        if let result = checkMatch(s: "abc", pat: "", pre: nil, m: nil, post: nil, arr: []) {
            XCTFail(result)
        }

        // Pattern doesn't match empty string
        if let result = checkMatch(s: "", pat: "abc", pre: nil, m: nil, post: nil, arr: []) {
            XCTFail(result)
        }

        // Pattern does match empty string (m = "")
        if let result = checkMatch(s: "", pat: "\\S*", pre: "", m: "", post: "", arr: []) {
            XCTFail(result)
        }
    }
    
    
    func testCaptureGroups() {
        
        // No capture group matches.
        if let result = checkMatch(s: "abc", pat: "b", pre: "a", m: "b", post: "c", arr: []) {
            XCTFail(result)
        }

        // Capture group matches.
        if let result = checkMatch(s: "abc", pat: "(b)", pre: "a", m: "b", post: "c", arr: ["b"]) {
            XCTFail(result)
        }

        // Nested capture group matches.
        if let result = checkMatch(s: "abcd", pat: "((b)(c))", pre: "a", m: "bc", post: "d", arr: ["bc","b","c"]) {
            XCTFail(result)
        }
        
        // Capture group match.  Empty pre and post match.
        if let result = checkMatch(s: "b", pat: "(b)", pre: "", m: "b", post: "", arr: ["b"]) {
            XCTFail(result)
        }
        
        // No Capture group match.   Match with empty pre and post match.
        if let result = checkMatch(s: "b", pat: "b", pre: "", m: "b", post: "", arr: []) {
            XCTFail(result)
        }
    }
    
    
    // This test checks two items:
    //
    // Tuples:  We support up to 10 capture groups returned as a tuple.
    // Thus our test will range from (a) to (a)(b)...(j), ie. 10 iterations of loop below
    //
    // Flags: Our checkMatch() method checks both arrays and tuples with flags.
    //
    func testTuplesAndFlags() {
        
        let startChar = Unicode.Scalar("a").value
        let endChar = Unicode.Scalar("j").value
        
        var s = ""
        var pat = ""
        var arr: [String] = []
        var arrUpper: [String] = []
        
        for alpha in startChar...endChar {
            let char = Unicode.Scalar(alpha)!
            let str = String(char)
            
            s = s + str             // Every iteration adds a new character ab...
            pat = pat + "(\(str))"  // (a)(b)..
            arr.append(str)         // ["a","b",...]
            arrUpper.append(str.uppercased())
            
            if let result = checkMatch(s: s, pat: pat, pre: "", m: s, post: "", arr: arr) {
                XCTFail(result)
                return
            }

            if let result = checkMatch(s: s, pat: pat, pre: "", m: s, post: "", arr: arr, flags: "i") {
                XCTFail(result)
                return
            }

            if let result = checkMatch(s: s, pat: pat.uppercased(), pre: "", m: s, post: "", arr: arr, flags: "i") {
                XCTFail(result)
                return
            }

            if let result = checkMatch(s: s.uppercased(), pat: pat, pre: "", m: s.uppercased(), post: "", arr: arrUpper, flags: "i") {
                XCTFail(result)
                return
            }

            
        }
        
    }
    
    
    
    // For each check in a given test, we test all of our interfaces.
    func checkMatch(s str: String, pat pattern: String, pre preMatch: String?, m match: String?, post postMatch: String?, arr: [String], flags: String = "") -> String? {
        
        // Array result without closure
        if let result = checkArrayMatch(s: str, pat: pattern,  m: match, arr: arr, flags: flags) {
            return  TestUtils.errorMsg("") + result
        }

        // Array result with closure
        if let result = checkArrayMatch(s: str, pat: pattern, pre: preMatch, m: match, post: postMatch, arr: arr, flags: flags) {
            return  TestUtils.errorMsg("") + result
        }
        
        // Tuple result without closure
        if let result = checkTupleMatch(s: str, pat: pattern, arr: arr, flags: flags) {
            return  TestUtils.errorMsg("") + result
        }

        // Tuple result with closure
        if let result = checkTupleMatch(s: str, pat: pattern, pre: preMatch, m: match, post: postMatch, arr: arr, flags: flags) {
            return  TestUtils.errorMsg("") + result
        }

        return nil
    }
    
    
    
    // Check array return result without a closure
    func checkArrayMatch(s str: String, pat pattern: String, m match: String?, arr: [String], flags: String) -> String? {
        
        var arrResult: [String] = []
        var arrResultOptional: [String]?


        //
        // Array, no closure
        //
        if flags == "" {
            arrResult = str =~ (.M, pattern)
            if arr != arrResult {
                return TestUtils.errorMsg("Array result incorrect.  Expected \(arr)  Got \(arrResult)")
            }
        }

        arrResult = str =~ (.M, pattern, flags)
        if arr != arrResult {
            return TestUtils.errorMsg("Array result incorrect.  Expected \(arr)  Got \(arrResult)")
        }

        
        //
        // Optional array, no closure
        //
        if flags == "" {
            arrResultOptional = str =~ (.M, pattern)
            if match == nil {
                if arrResultOptional != nil {
                    return TestUtils.errorMsg("Array result not nil")
                }
            }
            else {
                if arr != arrResultOptional {
                    return TestUtils.errorMsg("Array result incorrect.  Expected \(arr)  Got \(String(describing: arrResultOptional))")
                }
            }
        }

        arrResultOptional = str =~ (.M, pattern, flags)
        if match == nil {
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
        if flags == "" {
            arrResult = str =~ (.M, pattern, { (_preMatch,_match,_postMatch) in
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
        }

        
        arrResult = str =~ (.M, pattern, flags,{ (_preMatch,_match,_postMatch) in
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
        if flags == "" {
            arrResultOptional = str =~ (.M, pattern, { (_preMatch,_match,_postMatch) in
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
            
            
            if match == nil {
                if arrResultOptional != nil {
                    return TestUtils.errorMsg("Array result not nil")
                }
            }
            else {
                if arr != arrResultOptional {
                    return TestUtils.errorMsg("Array result incorrect.  Expected \(arr)  Got \(String(describing: arrResultOptional))")
                }
            }
        }
        
        
        arrResultOptional = str =~ (.M, pattern, flags, { (_preMatch,_match,_postMatch) in
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
        
        
        if match == nil {
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
    
    
    // Return a tuple match result without closure results.
    //
    // Tuples can not be specified with variadic arguments.  Methods overriding =~ operator must be static
    // and can't use dynamic dispatch. Thus we need to enumerate all cases with individual match statements.
    //
    func tupleMatchResult(count: Int, s str: String, pat pattern: String, flags: String?) -> Any? {
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
        
        if let flags = flags {
            switch count {
            case 1:
                tuple1 = str =~ (.M, pattern, flags)
                tuple = tuple1
            case 2:
                tuple2 = str =~ (.M, pattern, flags)
                tuple = tuple2
            case 3:
                tuple3 = str =~ (.M, pattern, flags)
                tuple = tuple3
            case 4:
                tuple4 = str =~ (.M, pattern, flags)
                tuple = tuple4
            case 5:
                tuple5 = str =~ (.M, pattern, flags)
                tuple = tuple5
            case 6:
                tuple6 = str =~ (.M, pattern, flags)
                tuple = tuple6
            case 7:
                tuple7 = str =~ (.M, pattern, flags)
                tuple = tuple7
            case 8:
                tuple8 = str =~ (.M, pattern, flags)
                tuple = tuple8
            case 9:
                tuple9 = str =~ (.M, pattern, flags)
                tuple = tuple9
            case 10:
                tuple10 = str =~ (.M, pattern, flags)
                tuple = tuple10
            default:
                assertionFailure("Unhandled tuple")
            }
        }
        else {
            switch count {
            case 1:
                tuple1 = str =~ (.M, pattern)
                tuple = tuple1
            case 2:
                tuple2 = str =~ (.M, pattern)
                tuple = tuple2
            case 3:
                tuple3 = str =~ (.M, pattern)
                tuple = tuple3
            case 4:
                tuple4 = str =~ (.M, pattern)
                tuple = tuple4
            case 5:
                tuple5 = str =~ (.M, pattern)
                tuple = tuple5
            case 6:
                tuple6 = str =~ (.M, pattern)
                tuple = tuple6
            case 7:
                tuple7 = str =~ (.M, pattern)
                tuple = tuple7
            case 8:
                tuple8 = str =~ (.M, pattern)
                tuple = tuple8
            case 9:
                tuple9 = str =~ (.M, pattern)
                tuple = tuple9
            case 10:
                tuple10 = str =~ (.M, pattern)
                tuple = tuple10
            default:
                assertionFailure("Unhandled tuple")
            }
        }
        
        return tuple
    }

    
    // Return a tuple match with closure results.
    //
    func tupleMatchResult(count: Int, s str: String, pat pattern: String, flags: String?) -> (tuple: Any?, preMatch: String?, match: String?, postMatch: String?) {
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
        

        if let flags = flags {
            switch count {
            case 1:
                tuple1 = str =~ (.M, pattern, flags,  { (_preMatch,_match,_postMatch) in
                    preMatch = _preMatch
                    match = _match
                    postMatch = _postMatch
                })
                tuple = tuple1
            case 2:
                tuple2 = str =~ (.M, pattern, flags,  { (_preMatch,_match,_postMatch) in
                    preMatch = _preMatch
                    match = _match
                    postMatch = _postMatch
                })
                tuple = tuple2
            case 3:
                tuple3 = str =~ (.M, pattern, flags,  { (_preMatch,_match,_postMatch) in
                    preMatch = _preMatch
                    match = _match
                    postMatch = _postMatch
                })
                tuple = tuple3
            case 4:
                tuple4 = str =~ (.M, pattern, flags,  { (_preMatch,_match,_postMatch) in
                    preMatch = _preMatch
                    match = _match
                    postMatch = _postMatch
                })
                tuple = tuple4
            case 5:
                tuple5 = str =~ (.M, pattern, flags,  { (_preMatch,_match,_postMatch) in
                    preMatch = _preMatch
                    match = _match
                    postMatch = _postMatch
                })
                tuple = tuple5
            case 6:
                tuple6 = str =~ (.M, pattern, flags,  { (_preMatch,_match,_postMatch) in
                    preMatch = _preMatch
                    match = _match
                    postMatch = _postMatch
                })
                tuple = tuple6
            case 7:
                tuple7 = str =~ (.M, pattern, flags,  { (_preMatch,_match,_postMatch) in
                    preMatch = _preMatch
                    match = _match
                    postMatch = _postMatch
                })
                tuple = tuple7
            case 8:
                tuple8 = str =~ (.M, pattern, flags,  { (_preMatch,_match,_postMatch) in
                    preMatch = _preMatch
                    match = _match
                    postMatch = _postMatch
                })
                tuple = tuple8
            case 9:
                tuple9 = str =~ (.M, pattern, flags,  { (_preMatch,_match,_postMatch) in
                    preMatch = _preMatch
                    match = _match
                    postMatch = _postMatch
                })
                tuple = tuple9
            case 10:
                tuple10 = str =~ (.M, pattern, flags,  { (_preMatch,_match,_postMatch) in
                    preMatch = _preMatch
                    match = _match
                    postMatch = _postMatch
                })
                tuple = tuple10
            default:
                assertionFailure("Unhandled tuple")
            }
        }
        else {
            switch count {
            case 1:
                tuple1 = str =~ (.M, pattern,  { (_preMatch,_match,_postMatch) in
                    preMatch = _preMatch
                    match = _match
                    postMatch = _postMatch
                })
                tuple = tuple1
            case 2:
                tuple2 = str =~ (.M, pattern,  { (_preMatch,_match,_postMatch) in
                    preMatch = _preMatch
                    match = _match
                    postMatch = _postMatch
                })
                tuple = tuple2
            case 3:
                tuple3 = str =~ (.M, pattern,  { (_preMatch,_match,_postMatch) in
                    preMatch = _preMatch
                    match = _match
                    postMatch = _postMatch
                })
                tuple = tuple3
            case 4:
                tuple4 = str =~ (.M, pattern,  { (_preMatch,_match,_postMatch) in
                    preMatch = _preMatch
                    match = _match
                    postMatch = _postMatch
                })
                tuple = tuple4
            case 5:
                tuple5 = str =~ (.M, pattern,  { (_preMatch,_match,_postMatch) in
                    preMatch = _preMatch
                    match = _match
                    postMatch = _postMatch
                })
                tuple = tuple5
            case 6:
                tuple6 = str =~ (.M, pattern,  { (_preMatch,_match,_postMatch) in
                    preMatch = _preMatch
                    match = _match
                    postMatch = _postMatch
                })
                tuple = tuple6
            case 7:
                tuple7 = str =~ (.M, pattern,  { (_preMatch,_match,_postMatch) in
                    preMatch = _preMatch
                    match = _match
                    postMatch = _postMatch
                })
                tuple = tuple7
            case 8:
                tuple8 = str =~ (.M, pattern,  { (_preMatch,_match,_postMatch) in
                    preMatch = _preMatch
                    match = _match
                    postMatch = _postMatch
                })
                tuple = tuple8
            case 9:
                tuple9 = str =~ (.M, pattern,  { (_preMatch,_match,_postMatch) in
                    preMatch = _preMatch
                    match = _match
                    postMatch = _postMatch
                })
                tuple = tuple9
            case 10:
                tuple10 = str =~ (.M, pattern,  { (_preMatch,_match,_postMatch) in
                    preMatch = _preMatch
                    match = _match
                    postMatch = _postMatch
                })
                tuple = tuple10
            default:
                assertionFailure("Unhandled tuple")
            }
        }
        
        return (tuple, preMatch, match, postMatch)
    }

    
    // Check tuple return result without a closure
    func checkTupleMatch(s str: String, pat pattern: String, arr: [String], flags: String) -> String? {
        
        var tupleArr: [String?] = []  // Version of arr that is truncated or filled out with nil as needed.
        var tupleArrResult: [String?] = []
        
        var tupleAny: Any?
        
        // We support up to 10 return values in a tuple
        for count in 1...10 {
            
            // We only check the method variety of =~ without flags if flags == ""
            // We indicate this condition to tupleMatchResult() by specifying flags = nil in that call.
            // This will cause tupleMatchResult() to use the variety:  str =~ (.M, pattern)
            if flags == "" {
                tupleAny = tupleMatchResult(count: count, s: str, pat: pattern, flags: nil)
                tupleArrResult = TestUtils.arrayFromTuple(tuple: tupleAny)
                tupleArr = TestUtils.sizedArray(arr: arr, fillToCount: count)
                
                if tupleArrResult != tupleArr {
                    return TestUtils.errorMsg("Tuple x \(count) result incorrect.  Expected \(tupleArr)   Got \(tupleArrResult)")
                }
            }
            
            // We always check the method variety: str =~ (.M, pattern, flags)
            // which is triggered in tupleMatchResult() by passing in a non-nil value for flags arg in that call.
            tupleAny = tupleMatchResult(count: count, s: str, pat: pattern, flags: flags)
            tupleArrResult = TestUtils.arrayFromTuple(tuple: tupleAny)
            tupleArr = TestUtils.sizedArray(arr: arr, fillToCount: count)
            
            if tupleArrResult != tupleArr {
                return TestUtils.errorMsg("Tuple x \(count) result incorrect.  Expected \(tupleArr)   Got \(tupleArrResult)")
            }
            
        }
        
        return nil
    }
    
    
    // Check tuple return result with a closure
    func checkTupleMatch(s str: String, pat pattern: String, pre preMatch: String?, m match: String?, post postMatch: String?, arr: [String], flags: String) -> String? {
        
        var tupleArr: [String?] = []  // Version of arr that is truncated or filled out with nil as needed.
        var tupleArrResult: [String?] = []
        
        var result: (tuple: Any?, preMatch: String?, match: String?, postMatch: String?)
        
        
        
        // We support up to 10 return values in a tuple
        for count in 1...10 {
            
            // We only check the method variety of =~ without flags if flags == ""
            // We indicate this condition to tupleMatchResult() by specifying flags = nil in that call.
            // This will cause tupleMatchResult() to use the variety:  str =~ (.M, pattern)
            if flags == "" {
                result = tupleMatchResult(count: count, s: str, pat: pattern, flags: nil)
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
            
            // We always check the method variety: str =~ (.M, pattern, flags)
            // which is triggered in tupleMatchResult() by passing in a non-nil value for flags arg in that call.
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
    
    
}







//
//  String.swift
//  AppDeveloperKit_String
//
//  Created by Scott Carter on 11/25/18.
//  Copyright © 2018 Scott Carter. All rights reserved.
//

// By including a custom enum type in all tuples (which are part of all overriden operators), we
// practically guarantee that this extension will never conflict with another String extension.
//


// References
//
// Regex tests https://stackoverflow.com/a/15823499/1949877
//
// Perl Regex tests (see for example pat.t) https://perl5.git.perl.org/perl.git/tree/HEAD:/t/re
//


infix operator =~



public extension String {
    
    
    enum Substition {
        case S
    }
    
    enum Match {
        case M
    }
    
    
    // resultArr contents depend on whether global flag is present and if there are any capture groups.
    //
    // No global flag present
    // ======================
    // No capture groups: resultArr is empty
    // Capture groups:    Contains all capture groups for first match.
    //
    //
    // Global flag present
    // ======================
    // No capture groups: Contains all matches
    // Capture groups:    Contains all capture groups for all matches.
    //
    private typealias MatchesResultType = (matchCount: Int, resultArr: Array<String>?, resultRangeArr: Array<Range<String.Index>>, preMatch: String?, match: String?, postMatch: String?)


    private typealias SubstitutionResultType = (substitutionCount: Int, resultStr: String)
    

    
    // MARK: Substitution methods.
    
    // Changes input string in place.
    //
    
    
    // No flags - defaults to flags = ""
    static func =~ ( inputStr: inout String, control: (operation: Substition, pattern: String, replacement: String)) -> Int {
        return inputStr =~ (.S,control.pattern, control.replacement, "")
    }
    
    
    // Flags supported
    static func =~ ( inputStr: inout String, control: (operation: Substition, pattern: String, replacement: String, flags: String)) -> Int {
        
       let substitutionResult = substitute(inputStr: inputStr, pattern: control.pattern, replacement: control.replacement, flags: control.flags)
        
        inputStr = substitutionResult.resultStr
        
        return substitutionResult.substitutionCount
        
    }
    
    
    
    // MARK: Methods to return capture group matching as a tuple.

    
    
    // MARK: Capture group matching to tuple x 1 method
    static func =~ (inputStr: String, control: (operation: Match, pattern: String, flags: String)) -> (String?) {
        let elemArr = arrayOfMatches(inputStr: inputStr, pattern: control.pattern, flags: control.flags, count: 1)
        return (elemArr[0])
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String)) -> (String?) {
        return inputStr =~ (control.operation, control.pattern, "")
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String, flags: String, completion: (_ preMatch:String?, _ match: String?, _ postMatch: String?)->())) -> (String?) {
        let matchResult = getMatches(inputStr: inputStr, pattern: control.pattern, flags: control.flags)
        control.completion(matchResult.preMatch, matchResult.match, matchResult.postMatch)
        
        let elemArr = arrayOfMatches(matchResult: matchResult, count: 1)
        return (elemArr[0])
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String, completion: (_ preMatch:String?, _ match: String?, _ postMatch: String?)->())) -> (String?) {
        return inputStr =~ (control.operation, control.pattern, "", control.completion)
    }
    
    
    
    // MARK: Capture group matching to tuple x 2 method
    static func =~ (inputStr: String, control: (operation: Match, pattern: String, flags: String)) -> (String?, String?) {
        let elemArr = arrayOfMatches(inputStr: inputStr, pattern: control.pattern, flags: control.flags, count: 2)
        return (elemArr[0],elemArr[1])
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String)) -> (String?, String?) {
        return inputStr =~ (control.operation, control.pattern, "")
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String, flags: String, completion: (_ preMatch:String?, _ match: String?, _ postMatch: String?)->())) -> (String?, String?) {
        let matchResult = getMatches(inputStr: inputStr, pattern: control.pattern, flags: control.flags)
        control.completion(matchResult.preMatch, matchResult.match, matchResult.postMatch)
        
        let elemArr = arrayOfMatches(matchResult: matchResult, count: 2)
        return (elemArr[0],elemArr[1])
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String, completion: (_ preMatch:String?, _ match: String?, _ postMatch: String?)->())) -> (String?, String?) {
        return inputStr =~ (control.operation, control.pattern, "", control.completion)
    }

    
    
    // MARK: Capture group matching to tuple x 3 method
    static func =~ (inputStr: String, control: (operation: Match, pattern: String, flags: String)) -> (String?, String?, String?) {
        let elemArr = arrayOfMatches(inputStr: inputStr, pattern: control.pattern, flags: control.flags, count: 3)
        return (elemArr[0],elemArr[1], elemArr[2])
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String)) -> (String?, String?, String?) {
        return inputStr =~ (control.operation, control.pattern, "")
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String, flags: String, completion: (_ preMatch:String?, _ match: String?, _ postMatch: String?)->())) -> (String?, String?, String?) {
        let matchResult = getMatches(inputStr: inputStr, pattern: control.pattern, flags: control.flags)
        control.completion(matchResult.preMatch, matchResult.match, matchResult.postMatch)
        
        let elemArr = arrayOfMatches(matchResult: matchResult, count: 3)
        return (elemArr[0],elemArr[1],elemArr[2])
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String, completion: (_ preMatch:String?, _ match: String?, _ postMatch: String?)->())) -> (String?, String?, String?) {
        return inputStr =~ (control.operation, control.pattern, "", control.completion)
    }
    
    
    
    // MARK: Capture group matching to tuple x 4 method
    static func =~ (inputStr: String, control: (operation: Match, pattern: String, flags: String)) -> (String?, String?, String?, String?) {
        let elemArr = arrayOfMatches(inputStr: inputStr, pattern: control.pattern, flags: control.flags, count: 4)
        return (elemArr[0],elemArr[1], elemArr[2], elemArr[3])
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String)) -> (String?, String?, String?, String?) {
        return inputStr =~ (control.operation, control.pattern, "")
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String, flags: String, completion: (_ preMatch:String?, _ match: String?, _ postMatch: String?)->())) -> (String?, String?, String?, String?) {
        let matchResult = getMatches(inputStr: inputStr, pattern: control.pattern, flags: control.flags)
        control.completion(matchResult.preMatch, matchResult.match, matchResult.postMatch)
        
        let elemArr = arrayOfMatches(matchResult: matchResult, count: 4)
        return (elemArr[0],elemArr[1], elemArr[2], elemArr[3])
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String, completion: (_ preMatch:String?, _ match: String?, _ postMatch: String?)->())) -> (String?, String?, String?, String?) {
        return inputStr =~ (control.operation, control.pattern, "", control.completion)
    }
    
    
    
    // MARK: Capture group matching to tuple x 5 method
    static func =~ (inputStr: String, control: (operation: Match, pattern: String, flags: String)) -> (String?, String?, String?, String?, String?) {
        let elemArr = arrayOfMatches(inputStr: inputStr, pattern: control.pattern, flags: control.flags, count: 5)
        return (elemArr[0],elemArr[1], elemArr[2], elemArr[3], elemArr[4])
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String)) -> (String?, String?, String?, String?, String?) {
        return inputStr =~ (control.operation, control.pattern, "")
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String, flags: String, completion: (_ preMatch:String?, _ match: String?, _ postMatch: String?)->())) -> (String?, String?, String?, String?, String?) {
        let matchResult = getMatches(inputStr: inputStr, pattern: control.pattern, flags: control.flags)
        control.completion(matchResult.preMatch, matchResult.match, matchResult.postMatch)
        
        let elemArr = arrayOfMatches(matchResult: matchResult, count: 5)

        return (elemArr[0],elemArr[1], elemArr[2], elemArr[3], elemArr[4])
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String, completion: (_ preMatch:String?, _ match: String?, _ postMatch: String?)->())) -> (String?, String?, String?, String?, String?) {
        return inputStr =~ (control.operation, control.pattern, "", control.completion)
    }
    
    
    
    // MARK: Capture group matching to tuple x 6 method
    static func =~ (inputStr: String, control: (operation: Match, pattern: String, flags: String)) -> (String?, String?, String?, String?, String?, String?) {
        let elemArr = arrayOfMatches(inputStr: inputStr, pattern: control.pattern, flags: control.flags, count: 6)
        return (elemArr[0],elemArr[1], elemArr[2], elemArr[3],elemArr[4], elemArr[5])
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String)) -> (String?, String?, String?, String?, String?, String?) {
        return inputStr =~ (control.operation, control.pattern, "")
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String, flags: String, completion: (_ preMatch:String?, _ match: String?, _ postMatch: String?)->())) -> (String?, String?, String?, String?, String?, String?) {
        let matchResult = getMatches(inputStr: inputStr, pattern: control.pattern, flags: control.flags)
        control.completion(matchResult.preMatch, matchResult.match, matchResult.postMatch)
        
        let elemArr = arrayOfMatches(matchResult: matchResult, count: 6)

        return (elemArr[0],elemArr[1], elemArr[2], elemArr[3],elemArr[4], elemArr[5])
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String, completion: (_ preMatch:String?, _ match: String?, _ postMatch: String?)->())) -> (String?, String?, String?, String?, String?, String?) {
        return inputStr =~ (control.operation, control.pattern, "", control.completion)
    }
    
    
    
    // MARK: Capture group matching to tuple x 7 method
    static func =~ (inputStr: String, control: (operation: Match, pattern: String, flags: String)) -> (String?, String?, String?, String?, String?, String?, String?) {
        let elemArr = arrayOfMatches(inputStr: inputStr, pattern: control.pattern, flags: control.flags, count: 7)
        return (elemArr[0],elemArr[1], elemArr[2], elemArr[3],elemArr[4], elemArr[5], elemArr[6])
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String)) -> (String?, String?, String?, String?, String?, String?, String?) {
        return inputStr =~ (control.operation, control.pattern, "")
    }
    
    static func =~ (inputStr: String, control: (operation: Match, pattern: String, flags: String, completion: (_ preMatch:String?, _ match: String?, _ postMatch: String?)->())) -> (String?, String?, String?, String?, String?, String?, String?) {
        let matchResult = getMatches(inputStr: inputStr, pattern: control.pattern, flags: control.flags)
        control.completion(matchResult.preMatch, matchResult.match, matchResult.postMatch)
        
        let elemArr = arrayOfMatches(matchResult: matchResult, count: 7)
        return (elemArr[0],elemArr[1], elemArr[2], elemArr[3],elemArr[4], elemArr[5], elemArr[6])
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String, completion: (_ preMatch:String?, _ match: String?, _ postMatch: String?)->())) -> (String?, String?, String?, String?, String?, String?, String?) {
        return inputStr =~ (control.operation, control.pattern, "", control.completion)
    }
    
    
    
    // MARK: Capture group matching to tuple x 8 method
    static func =~ (inputStr: String, control: (operation: Match, pattern: String, flags: String)) -> (String?, String?, String?, String?, String?, String?, String?, String?) {
        let elemArr = arrayOfMatches(inputStr: inputStr, pattern: control.pattern, flags: control.flags, count: 8)
        return (elemArr[0],elemArr[1], elemArr[2], elemArr[3],elemArr[4], elemArr[5],elemArr[6], elemArr[7])
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String)) -> (String?, String?, String?, String?, String?, String?, String?, String?) {
        return inputStr =~ (control.operation, control.pattern, "")
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String, flags: String, completion: (_ preMatch:String?, _ match: String?, _ postMatch: String?)->())) -> (String?, String?, String?, String?, String?, String?, String?, String?) {
        let matchResult = getMatches(inputStr: inputStr, pattern: control.pattern, flags: control.flags)
        control.completion(matchResult.preMatch, matchResult.match, matchResult.postMatch)
        
        let elemArr = arrayOfMatches(matchResult: matchResult, count: 8)
        return (elemArr[0],elemArr[1], elemArr[2], elemArr[3],elemArr[4], elemArr[5],elemArr[6], elemArr[7])
    }
    
    static func =~ (inputStr: String, control: (operation: Match, pattern: String, completion: (_ preMatch:String?, _ match: String?, _ postMatch: String?)->())) -> (String?, String?, String?, String?, String?, String?, String?, String?) {
        return inputStr =~ (control.operation, control.pattern, "", control.completion)
    }

    
    
    // MARK: Capture group matching to tuple x 9 method
    static func =~ (inputStr: String, control: (operation: Match, pattern: String, flags: String)) -> (String?, String?, String?, String?, String?, String?, String?, String?, String?) {
        let elemArr = arrayOfMatches(inputStr: inputStr, pattern: control.pattern, flags: control.flags, count: 9)
        return (elemArr[0],elemArr[1], elemArr[2], elemArr[3],elemArr[4], elemArr[5], elemArr[6],elemArr[7], elemArr[8])
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String)) -> (String?, String?, String?, String?, String?, String?, String?, String?, String?) {
        return inputStr =~ (control.operation, control.pattern, "")
    }
    
    static func =~ (inputStr: String, control: (operation: Match, pattern: String, flags: String, completion: (_ preMatch:String?, _ match: String?, _ postMatch: String?)->())) -> (String?, String?, String?, String?, String?, String?, String?, String?, String?) {
        let matchResult = getMatches(inputStr: inputStr, pattern: control.pattern, flags: control.flags)
        control.completion(matchResult.preMatch, matchResult.match, matchResult.postMatch)
        
        let elemArr = arrayOfMatches(matchResult: matchResult, count: 9)
        return (elemArr[0],elemArr[1], elemArr[2], elemArr[3],elemArr[4], elemArr[5], elemArr[6],elemArr[7], elemArr[8])
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String, completion: (_ preMatch:String?, _ match: String?, _ postMatch: String?)->())) -> (String?, String?, String?, String?, String?, String?, String?, String?, String?) {
        return inputStr =~ (control.operation, control.pattern, "", control.completion)
    }
    
    
    
    // MARK: Capture group matching to tuple x 10 method
    static func =~ (inputStr: String, control: (operation: Match, pattern: String, flags: String)) -> (String?, String?, String?, String?, String?, String?, String?, String?, String?, String?) {
        let elemArr = arrayOfMatches(inputStr: inputStr, pattern: control.pattern, flags: control.flags, count: 10)
        return (elemArr[0],elemArr[1], elemArr[2], elemArr[3],elemArr[4], elemArr[5],elemArr[6], elemArr[7], elemArr[8],elemArr[9])
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String)) -> (String?, String?, String?, String?, String?, String?, String?, String?, String?, String?) {
        return inputStr =~ (control.operation, control.pattern, "")
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String, flags: String, completion: (_ preMatch:String?, _ match: String?, _ postMatch: String?)->())) -> (String?, String?, String?, String?, String?, String?, String?, String?, String?, String?) {
        let matchResult = getMatches(inputStr: inputStr, pattern: control.pattern, flags: control.flags)
        control.completion(matchResult.preMatch, matchResult.match, matchResult.postMatch)
        
        let elemArr = arrayOfMatches(matchResult: matchResult, count: 10)
        return (elemArr[0],elemArr[1], elemArr[2], elemArr[3],elemArr[4], elemArr[5],elemArr[6], elemArr[7], elemArr[8],elemArr[9])
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String, completion: (_ preMatch:String?, _ match: String?, _ postMatch: String?)->())) -> (String?, String?, String?, String?, String?, String?, String?, String?, String?, String?) {
        return inputStr =~ (control.operation, control.pattern, "", control.completion)
    }
    
    

    // MARK: Get capture group matches filled out to "count" elements.
    //
    // Call Capture group matching to array method, but truncate length of match array at count.
    // If number of matches are fewer than count, fill out resulting array with nil.
    private static func arrayOfMatches (inputStr: String, pattern: String, flags: String, count: Int) -> [String?] {
        
        var elemArr = [String?](repeating: nil, count: count)
        
        let matchResult = getMatches(inputStr: inputStr, pattern: pattern, flags: flags)
        
        let resultArr: [String] = matchResult.resultArr ?? []
        
        for i in 0..<resultArr.count {
            if i >= count {
                break
            }
            elemArr[i] = resultArr[i]
        }
        
        return elemArr
    }

    
    // Another version of getCaptureGroupMatches where we already have a matchResult
    private static func arrayOfMatches (matchResult: MatchesResultType, count: Int) -> [String?] {
        
        var elemArr = [String?](repeating: nil, count: count)
        
        let resultArr: [String] = matchResult.resultArr ?? []
        
        for i in 0..<resultArr.count {
            if i >= count {
                break
            }
            elemArr[i] = resultArr[i]
        }
        
        return elemArr
    }

    
    
    
    // MARK: Capture group matching to array method
    //
    
    // Optional array returned.  If result is nil, no matches were found.
    static func =~ (inputStr: String, control: (operation: Match, pattern: String, flags: String)) -> Array<String>? {
        let matchResult = getMatches(inputStr: inputStr, pattern: control.pattern, flags: control.flags)
        
        return matchResult.resultArr
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String)) -> Array<String>? {
        let matchResult = getMatches(inputStr: inputStr, pattern: control.pattern, flags: "")
        
        return matchResult.resultArr
    }

    
    // Non-optional array returned.  Result does not indicate if any matches found (only capture group result).
    static func =~ (inputStr: String, control: (operation: Match, pattern: String, flags: String)) -> Array<String> {
        let matchResult = getMatches(inputStr: inputStr, pattern: control.pattern, flags: control.flags)
        
        return matchResult.resultArr ?? []
    }
    
    static func =~ (inputStr: String, control: (operation: Match, pattern: String)) -> Array<String> {
        let matchResult = getMatches(inputStr: inputStr, pattern: control.pattern, flags: "")
        
        return matchResult.resultArr ?? []
    }

    
    
    // MARK: Return capture groups as array and preMatch, match, postMath in closure
    //
    
    // Optional capture group array returned. A nil return value is used to indicate no matches.
    static func =~ (inputStr: String, control: (operation: Match, pattern: String, flags: String, completion: (_ preMatch:String?, _ match: String?, _ postMatch: String?)->() )) -> Array<String>? {
        
        let matchResult = getMatches(inputStr: inputStr, pattern: control.pattern, flags: control.flags)
        
        control.completion(matchResult.preMatch, matchResult.match, matchResult.postMatch)
        
        return matchResult.resultArr
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String, completion: (_ preMatch:String?, _ match: String?, _ postMatch: String?)->() )) -> Array<String>? {
        
        let matchResult = getMatches(inputStr: inputStr, pattern: control.pattern, flags: "")
        
        control.completion(matchResult.preMatch, matchResult.match, matchResult.postMatch)
        
        return matchResult.resultArr
    }

    
    // Non-optional capture group array returned. Result does not indicate if any matches found (only capture group result).
    //
    // Why non non-optional preMatch,match,postMatch here?
    // Because any of them could be "" or no have match and we need a way to distinguish.
    //
    // For the capture group array result, it isn't an issue to return non-optional.  We either have zero or more capture group matches.
    static func =~ (inputStr: String, control: (operation: Match, pattern: String, flags: String, completion: (_ preMatch:String?, _ match: String?, _ postMatch: String?)->())) -> Array<String> {
        
        let matchResult = getMatches(inputStr: inputStr, pattern: control.pattern, flags: control.flags)
        
        control.completion(matchResult.preMatch, matchResult.match, matchResult.postMatch)
        
        return matchResult.resultArr ?? []
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String, completion: (_ preMatch:String?, _ match: String?, _ postMatch: String?)->())) -> Array<String> {
        
        let matchResult = getMatches(inputStr: inputStr, pattern: control.pattern, flags: "")
        
        control.completion(matchResult.preMatch, matchResult.match, matchResult.postMatch)
        
        return matchResult.resultArr ?? []
    }

    
    
    // MARK: Matching to Bool method
    //
    static func =~ (inputStr: String, control: (operation: Match, pattern: String, flags: String)) -> Bool {
        let matchResult = getMatches(inputStr: inputStr, pattern: control.pattern, flags: control.flags)
        
        return matchResult.match != nil
    }

    static func =~ (inputStr: String, control: (operation: Match, pattern: String)) -> Bool {
        let matchResult = getMatches(inputStr: inputStr, pattern: control.pattern, flags: "")
        
        return matchResult.match != nil
    }

    
    
    // MARK: Main match method.
    //
    // Provide an array of matches.
    
    private static func getMatches (inputStr: String, pattern: String, flags: String) -> MatchesResultType {
        
        // (matchCount: Int, resultArr: Array<String>?, resultRangeArr: Array<Range<String.Index>>, preMatch: String?, match: String?, postMatch: String?)
        
        
        let emptyResult: MatchesResultType = (0, nil, [], nil,nil,nil)

        var result = emptyResult
        
        
        var foundCaseInsensitiveFlag: Bool = false
        var foundGlobalFlag: Bool = false
        
        // Validate flags if supplied
        if flags != "" {
            foundCaseInsensitiveFlag = flags =~ (.M, "i")
            foundGlobalFlag = flags =~ (.M, "g")
        }
        
        
        
        var regex: NSRegularExpression
        
        // If the pattern is not valid (for example "") then just return a nil tuple.
        do {
            if foundCaseInsensitiveFlag {
                regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            }
            else {
                regex = try NSRegularExpression(pattern: pattern, options: [])
            }
        }
        catch {
            return emptyResult
        }
        
        let inputStrRange = inputStr.startIndex..<inputStr.endIndex
        
        let inputStrRange_ns = NSRange(inputStrRange, in: inputStr)
        
        let matches = regex.matches(in: inputStr, options: [], range: inputStrRange_ns)
        
        if matches.count == 0 {
            return emptyResult
        }
        
        result.matchCount = matches.count
        
        
        // Input string can have multiple matches against pattern.  Use just the first one unless
        // global flag was found.
        //
        
        let matchesToProcess = foundGlobalFlag ? matches.count : 1;
        
        for matchesIndex in 0..<matchesToProcess {
            
            let numberOfRanges = matches[matchesIndex].numberOfRanges
            
            for rangeIndex in 0..<numberOfRanges {
                let range = matches[matchesIndex].range(at: rangeIndex)
                
                
                // Handle the case where a capture group is not part of a match.
                //
                // Per the documentation on NSRegularExpression:
                // "However, for some regular expressions some capture groups may or may not participate
                // in a given match. If a given capture group does not participate in a given match,
                // then [result rangeAtIndex:idx] will return {NSNotFound, 0}."
                //
                // How to test this?  Ex:
                //  let s1 = "4"
                //  let p1 = "(a)|(\\S)"
                //  let b1: [String]? = s1 =~ (.M, p1)
                //
                if range.location == NSNotFound {
                    continue
                }
                
                
                // When finding startIdx,endIdx of match (String.Index) we can't use something such as:
                // let endIdx =  inputStr.index(inputStr.startIndex, offsetBy: range.location + range.length)
                //
                // For a unicode character such as 😎 the range.length is greater than 1 and our calculation of
                // endIdx would fail (and can cause exception of referencing past the range's endIndex).
                //
                // Instead we will use Range() method and get indices from the bounds.
                //
                // Note that not all NSRange's can be converted to Range though.
                // Consider for example the string "👩‍🚀" ("\u{01F469}\u{200D}\u{01F680}") and pattern "(\\X)" and flags "g"
                // This will produce 3 matches with ranges  {0, 2} {2, 1} and {3, 2}.  These ranges
                // will result in nil return value from Range().   What we probably wanted instead was the pattern
                // (\\X(?:\u{200D}\\X)*)
                //
                // Nice answer and related answer around the use of Range() to convert NSRange:
                // https://stackoverflow.com/a/30404532/1949877
                guard let matchRange =  Range(range, in: inputStr) else {
                    continue
                }
                
                let startIdx =  matchRange.lowerBound  //inputStr.index(inputStr.startIndex, offsetBy: range.location)
                let endIdx =   matchRange.upperBound  //inputStr.index(inputStr.startIndex, offsetBy: range.location + range.length)
                
                let match = inputStr[startIdx..<endIdx]
                
                // Consider the following examples:
                // inputStr = "ab2 cb2"    pattern "((b)(2))"
                // matchesToProcess = 2  For each match we have:
                //
                // rangeIndex    match
                // 0             b2  (overall match)
                // 1             b2  (outside capture group)
                // 2             b
                // 3             2
                //
                // inputStr = "ab2 cb2"    pattern "b2"
                // matchesToProcess = 2  For each match we have:
                //
                // rangeIndex    match
                // 0             b2 (overall match)
                //
                
                
                
                // First element in range is the overall match of regular expression
                if rangeIndex == 0 {
                    
                    // If we have a match, then resultArr should not be nil.
                    // It might remain empty though if we don't have any capture groups,
                    // and are not recording matches to this array due to global flag.
                    if result.resultArr == nil {
                        result.resultArr = []
                    }
                    
                    result.match = String(match)
                    
                    // Prematch
                    result.preMatch = String(inputStr[inputStr.startIndex..<startIdx])
                    
                    // Postmatch
                    result.postMatch = String(inputStr[endIdx..<inputStr.endIndex])
                    
                    // If we have no capture groups AND the global flag is in effect, then
                    // record the matches to match array.
                    if (numberOfRanges == 1) && foundGlobalFlag {
                        result.resultRangeArr.append(startIdx..<endIdx)
                        
                        result.resultArr?.append(String(match))
                    }
                    
                }
                    // Other elements in range are the capture groups
                else {
                    result.resultRangeArr.append(startIdx..<endIdx)
                    
                    result.resultArr?.append(String(match))
                }
            }
            
        }
        
        return result
    }
    
    
    
    // MARK: Main substitute method.
    //
    
    private static func substitute (inputStr: String, pattern: String, replacement: String, flags: String) -> SubstitutionResultType {
        
        // (substitutionCount: Int, resultStr: String)
        
        let emptyResult: SubstitutionResultType = (0, inputStr)
        
        var result = emptyResult
        
        
        var foundCaseInsensitiveFlag: Bool = false
        var foundGlobalFlag: Bool = false
        
        // Validate flags if supplied
        if flags != "" {
            foundCaseInsensitiveFlag = flags =~ (.M, "i")
            foundGlobalFlag = flags =~ (.M, "g")
        }
        
        
        var regex: NSRegularExpression
        
        // If the pattern is not valid (for example "") then just return the default result
        do {
            if foundCaseInsensitiveFlag {
                regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            }
            else {
                regex = try NSRegularExpression(pattern: pattern, options: [])
            }
        }
        catch {
            return emptyResult
        }
        
        
        // Note:  Can't form an NSRange such as NSRange(location: 0, length: inputStr.count)
        //
        // Why?
        //
        // Using inputStr.count is not correct for a string such as 😎😎
        // inputStr.count = 2 and the range would only include one of the characters!
        
        let inputStrRange = inputStr.startIndex..<inputStr.endIndex
        
        let inputStrRange_ns = NSRange(inputStrRange, in: inputStr)
        
        let matches = regex.matches(in: inputStr, options: [], range: inputStrRange_ns)

        if matches.count == 0 {
            return emptyResult
        }
        
        
        // Input string can have multiple matches against pattern.  Use just the first one unless
        // global flag was found.
        let matchesToProcess = foundGlobalFlag ? matches.count : 1;
        
        result.substitutionCount = matchesToProcess
        
        
        if foundGlobalFlag {
            
            result.resultStr = regex.stringByReplacingMatches(in: inputStr, options: [], range: inputStrRange_ns, withTemplate: replacement)
            
            return result
        }
        
        // We are only processing the first match since foundGlobalFlag = false
        let match = matches[0]
        
        let newMatchStr = regex.replacementString(for: match, in: inputStr, offset: 0, template: replacement)

        guard let range =  Range(match.range, in: inputStr) else {
            return emptyResult
        }
        
        result.resultStr = inputStr.replacingCharacters(in: range, with: newMatchStr)
        
        return result
    }
    
    
    
    

    
    
    
}

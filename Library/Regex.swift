//
//  Regex.swift
//  AppDeveloperKit_String
//
//  Created by Scott Carter on 11/25/18.
//  Copyright © 2018 Scott Carter. All rights reserved.
//



public class Regex {
    
    // Tuple x 1
    public static func m(str: String, pattern: String, flags: String, completion: @escaping (_ preMatch:String?, _ match: String?, _ postMatch: String?)->()) -> (String?) {
        return str =~ (.M, pattern, flags, { (_preMatch,_match,_postMatch) in
            completion(_preMatch, _match, _postMatch)
        })
    }

    // Tuple x 2
    public static func m(str: String, pattern: String, flags: String, completion: @escaping (_ preMatch:String?, _ match: String?, _ postMatch: String?)->()) -> (String?, String?) {
        return str =~ (.M, pattern, flags, { (_preMatch,_match,_postMatch) in
            completion(_preMatch, _match, _postMatch)
        })
    }

    // Tuple x 3
    public static func m(str: String, pattern: String, flags: String, completion: @escaping (_ preMatch:String?, _ match: String?, _ postMatch: String?)->()) -> (String?, String?, String?) {
        return str =~ (.M, pattern, flags, { (_preMatch,_match,_postMatch) in
            completion(_preMatch, _match, _postMatch)
        })
    }

    // Tuple x 4
    public static func m(str: String, pattern: String, flags: String, completion: @escaping (_ preMatch:String?, _ match: String?, _ postMatch: String?)->()) -> (String?, String?, String?, String?) {
        return str =~ (.M, pattern, flags, { (_preMatch,_match,_postMatch) in
            completion(_preMatch, _match, _postMatch)
        })
    }

    // Tuple x 5
    public static func m(str: String, pattern: String, flags: String, completion: @escaping (_ preMatch:String?, _ match: String?, _ postMatch: String?)->()) -> (String?, String?, String?, String?, String?) {
        return str =~ (.M, pattern, flags, { (_preMatch,_match,_postMatch) in
            completion(_preMatch, _match, _postMatch)
        })
    }

    // Tuple x 6
    public static func m(str: String, pattern: String, flags: String, completion: @escaping (_ preMatch:String?, _ match: String?, _ postMatch: String?)->()) -> (String?, String?, String?, String?, String?, String?) {
        return str =~ (.M, pattern, flags, { (_preMatch,_match,_postMatch) in
            completion(_preMatch, _match, _postMatch)
        })
    }

    // Tuple x 7
    public static func m(str: String, pattern: String, flags: String, completion: @escaping (_ preMatch:String?, _ match: String?, _ postMatch: String?)->()) -> (String?, String?, String?, String?, String?, String?, String?) {
        return str =~ (.M, pattern, flags, { (_preMatch,_match,_postMatch) in
            completion(_preMatch, _match, _postMatch)
        })
    }

    // Tuple x 8
    public static func m(str: String, pattern: String, flags: String, completion: @escaping (_ preMatch:String?, _ match: String?, _ postMatch: String?)->()) -> (String?, String?, String?, String?, String?, String?, String?, String?) {
        return str =~ (.M, pattern, flags, { (_preMatch,_match,_postMatch) in
            completion(_preMatch, _match, _postMatch)
        })
    }

    // Tuple x 9
    public static func m(str: String, pattern: String, flags: String, completion: @escaping (_ preMatch:String?, _ match: String?, _ postMatch: String?)->()) -> (String?, String?, String?, String?, String?, String?, String?, String?, String?) {
        return str =~ (.M, pattern, flags, { (_preMatch,_match,_postMatch) in
            completion(_preMatch, _match, _postMatch)
        })
    }

    // Tuple x 10
    public static func m(str: String, pattern: String, flags: String, completion: @escaping (_ preMatch:String?, _ match: String?, _ postMatch: String?)->()) -> (String?, String?, String?, String?, String?, String?, String?, String?, String?, String?) {
        return str =~ (.M, pattern, flags, { (_preMatch,_match,_postMatch) in
            completion(_preMatch, _match, _postMatch)
        })
    }

    // Optional Array returned
    public static func m(str: String, pattern: String, flags: String, completion: @escaping (_ preMatch:String?, _ match: String?, _ postMatch: String?)->()) -> Array<String>? {
       return str =~ (.M, pattern, flags, { (_preMatch,_match,_postMatch) in
            completion(_preMatch, _match, _postMatch)
        })
    }

    // Non optional array returned
    public static func m(str: String, pattern: String, flags: String, completion: @escaping (_ preMatch:String?, _ match: String?, _ postMatch: String?)->()) -> Array<String> {
        return str =~ (.M, pattern, flags, { (_preMatch,_match,_postMatch) in
            completion(_preMatch, _match, _postMatch)
        })
    }


    // Bool result
    public static func m(str: String, pattern: String, flags: String) -> Bool {
        return str =~ (.M, pattern, flags)
    }
    
    
    // Substitutions
    public static func s(str: inout String, pattern: String, replacement: String, flags: String) -> Int {
        return str =~ (.S, pattern, replacement, flags)
    }
    
}



import UIKit

import AppDeveloperKit_String


// ================================
// AppDeveloperKit_String Overview
// ================================
//
// - Perl inspired matches and substitutions (String Extension) using =~ operator.
// - Regex wrapper class for more typical method interface.
// - Subscripting by index, Range and ClosedRange (String Extension).
// - Comprehensive unit tests for interfaces.
//

// Perl
// my ($d1,$d2) = "A56B" =~ m/(\d)(\d)/;    // ("5","6")
// $` = "A"
// $& = "56"
// $' = "B"

var (d1,d2) = "A56B" =~ (.M,"(\\d)(\\d)", { (preMatch, match, postMatch) in  // ("5","6")
    preMatch // A
    match    // 56
    postMatch // B
})


// Perl
// my @arr = "A56B" =~ m/(\d)(\d)/;    // ["5","6"]

var arr1: [String] = "A56B" =~ (.M,"(\\d)(\\d)")   // ["5", "6"]


// Perl
// my $str = "WX YZ";
// my $count = $str =~ s/(\w)(\w)/$2$1/g;   // $count = 2, $str = "XW ZY"

var str = "WX YZ"
let count = str =~ (.S,"(\\w)(\\w)","$2$1","g") // count = 2, str = "XW ZY"



// =========================
// Installation
// =========================
//

// Cocoapod installation - grab all components or pick and choose:
//
// # All components
// pod 'SC-String'
//
//
// # Perl inspired matching/substitutions using =~ using String extension.
// # Virtually no chance of conflict with other library string extensions.
// pod 'SC-String/String'
//
// # Wrapper class around String extensions.  Depends on and will load SC-String/String.
// pod 'SC-String/Regex'
//
// # String subscripting using String extension.
// pod 'SC-String/Subscript'
//



// =========================
// Substitutions
// =========================
//



// In-place substitution using a pattern and replacement with template.  Returns count of subsitutions made.
str = "XY"
str =~ (.S,"(\\w)(\\w)","$2$1") // 1   str = YX


// Variant using a flags argument.  Supported flags: "g" - global, "i" - case insensitive.
// Flags may appear in any order. Characters other then "g", "i" are ignored.
str = "XY ZW"
str =~ (.S, "(\\w)(\\w)","$2$1", "g") // 2  str = YX WZ


// An alternate interface using the Regex class.
str = "XY"
Regex.s(str: &str, pattern: "([a-z])([a-z])", replacement: "$2$1", flags: "i") // 1  str = YX


// =========================
// Matching
// =========================


// Tuple return for capture groups
// ------------------------------

// A tuple with from 1 - 10 arguments supported
str = "0123456789"
var (a,b,c,d,e,f,g,h,i,j) = str =~ (.M,"(\\w)(\\w)")  // (0, 1, nil, ... nil)


// With Flags argument
str = "XY"
(a,b) = str =~ (.M,"([a-z])([a-z])", "i")  // ("X", "Y")


// Completion block additionally provides preMatch, match and postMatch results
// Only grab the capture groups you need.
str = "4XY5"
(a) = str =~ (.M,"([A-Z])([A-Z])", { (preMatch, match, postMatch) in  // ("X")
    preMatch // 4
    match    // XY
    postMatch // 5
})



// With flags support
str = "4XY5"
(a) = str =~ (.M,"([a-z])([a-z])", "i", { (preMatch, match, postMatch) in  // ("X")
    preMatch // 4
    match    // XY
    postMatch // 5
})



// Global flag example with capture groups.
str = "-12 34 56-"
(a,b,c,d,e,f) = str =~ (.M,"(\\d)(\\d)", "g", { (preMatch, match, postMatch) in // ("1","2","3","4","5","6")
    preMatch // -12 34
    match    // 56
    postMatch // -
})


// Global flag without capture groups will return the matches.
str = "-123456-"
(a,b,c) = str =~ (.M,"\\d\\d", "g", { (preMatch, match, postMatch) in // ("12","34","56")
    preMatch // -1234
    match    // 56
    postMatch // -
})



// An alternate interface using the Regex class.
str = "4XY5"
(a,b) = Regex.m(str: str, pattern: "([a-z])([a-z])", flags: "i", completion: { (preMatch, match, postMatch) in // ("X","Y")
    preMatch // 4
    match    // XY
    postMatch // 5
})


// Array return for capture groups
// ------------------------------

str = "XY"
var arrOpt: [String]? = str =~ (.M,"(\\d)") // nil - signifies no matches.

arrOpt = str =~ (.M,"(\\w)") // ["X"]


// Take your pick: Optional or non-optional array return value.
var arr: [String] = str =~ (.M,"(\\d)") // []


// With or without flags
arr = str =~ (.M,"([a-z])", "ig") // ["X", "Y"]


// Completion handler available.
str = "4XY5"
arr = str =~ (.M,"([a-z])", "gi", { (preMatch, match, postMatch) in   //  ["X","Y"]
    preMatch // 4
    match    // Y
    postMatch // 5
})


// An alternate interface using the Regex class.
arr = Regex.m(str: str, pattern: "([a-z])", flags: "ig", completion: { (preMatch, match, postMatch) in   //  ["X","Y"]
    preMatch // 4
    match    // Y
    postMatch // 5
})




// Boolean result
// ------------------------------

str = "XY"
var result: Bool = str =~ (.M,"\\d") // false

// With flags
result = str =~ (.M,"[a-z]", "i")  // true


// An alternate interface using the Regex class.
result = Regex.m(str: str, pattern: "[a-z]", flags: "i") // true



// =========================
// Special Cases
// =========================

// Unicode characters are supported.

// Need to use a character expression that matches a grapheme cluster
str = "😎"  // "\u{1F60E}"
result = str =~ (.M,"(\\X)")  // true


// A ZWJ sequence needs special handling.  A single \X will not match.
str = "👩‍🚀"  // "\u{01F469}\u{200D}\u{01F680}"
result = str =~ (.M,"(\\X)")  // false


// Instead we need to account for a possible Zero Width Joiner (ZWJ) code point \u{200D}
// Here is a nice relevant article: http://cyrilwei.me/swift/2016/08/31/the-emoji.html
//
result = str =~ (.M,"(\\X(?:\u{200D}\\X)*)")  // true


// =========================
// String subscripting
// =========================

// Subscripting by index, Range and ClosedRange.
// Unicode supported.

str = "A😎B👩‍🚀CDE"

str[1] // 😎
str[2] // B
str[3] // 👩‍🚀

str[1..<4] // 😎B👩‍🚀

str[1...4] // 😎B👩‍🚀C



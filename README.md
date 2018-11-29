
# AppDeveloperKit-String


## Swift String utilities

## Overview

AppDeveloperKit-String is a Swift String library that provides support for subscripting and easy to use regular expression matching and substitutions.

- [x] Perl inspired matches and substitutions
	- [x] Implementation as String Extension
	- [x] `=~` operator support
	- [x] Optional alternative interface using Regex wrapper class
	- [x] Unicode characters supported including ZWJ sequences to combine elements 👩‍🚀
- [x] Flexible matching
	- [x] Support for global and case-insensitive flags
	- [x] Template support
	- [x] Match output as capture groups or Bool result
	- [x] Capture groups can be returned as tuple or array
	- [x] Prematch, match and postmatch provided in closure.
- [x] Subscripting by index, Range and ClosedRange
- [x] Comprehensive unit tests for interfaces


## Installation via Cocoapods

Add one of the following options to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html):


**Recommended: Install all the components of AppDeveloperKit-String**
```rb
pod 'AppDeveloperKit-String'
```

**Minimal installation**<br/>
In the event of a module conflict with the Regex wrapper class, you can choose to only add matching and substitution support for =~ operator, along with subscripting support:
```rb
pod 'AppDeveloperKit-String/String'
pod 'AppDeveloperKit-String/Subscript'
```

**Dependencies**<br/>
Integrate your dependencies using frameworks by adding `use_frameworks!` to your Podfile. Then run `pod install`.


## Documentation

See [Documentation.playground](https://github.com/AppDeveloperKit/AppDeveloperKit-String/blob/master/Documentation.playground/Contents.swift) for a complete specification of AppDeveloperKit-String presented as a Swift playground.

There is also a [PDF version](https://github.com/AppDeveloperKit/AppDeveloperKit-String/blob/master/Documentation.pdf) available, though the export process from the playground does result in a somewhat large font size.


## Match Examples


Capture groups returned as a tuple.  Closure provides prematch, match and postmatch.
```swift
var (d1,d2) = "A56B" =~ (.M,"(\\d)(\\d)", { (preMatch, match, postMatch) in 
    preMatch // A
    match    // 56
    postMatch // B
})
 // ("5","6")
 
```
If you only need the capture groups, you can simplify to:

```swift
var (d1,d2) = "A56B" =~ (.M,"(\\d)(\\d)")
```

Same capture groups returned as array:
```swift
var arr: [String] = "A56B" =~ (.M,"(\\d)(\\d)")  
```

Array can be an Optional if you wish (nil indicates no match):
```swift
var arr: [String]? = "A56B" =~ (.M,"(\\d)(\\d)")  
```

Tuple or array result, with or without a closure, also supports global "g" and/or case-insensitive "i" flags.   Flags argument comes after the pattern (and before optional closure).
```swift
var arr: [String] = "4XY5" =~ (.M,"([a-z])", "gi", { (preMatch, match, postMatch) in   
    preMatch // 4
    match    // Y
    postMatch // 5
})
//  ["X","Y"]
```

An alternate interface using the Regex class (also available for tuple, Bool result)
```swift
var arr: [String]  = Regex.m(str: "4XY5", pattern: "([a-z])", flags: "ig", completion: { (preMatch, match, postMatch) in  
    preMatch
    match    
    postMatch 
})
```

Bool result indicates a match
```swift
var result1: Bool = "XY" =~ (.M,"\\d") // false

// With flags argument
var result2: Bool = "XY" =~ (.M,"[a-z]", "i")  // true
```

## Substitution Examples

In-place substitution using a pattern and replacement with template.  Returns count of subsitutions made.
```swift
var str = "XY"
let count = str =~ (.S,"(\\w)(\\w)","$2$1") // 1   str = YX

// With flags argument
str = "XY ZW"
let count = str =~ (.S, "(\\w)(\\w)","$2$1", "g") // 2  str = YX WZ
```

An alternate interface using the Regex class
```swift
str = "XY"
let count = Regex.s(str: &str, pattern: "([a-z])([a-z])", replacement: "$2$1", flags: "i") // 1  str = YX
```

## Subscripting Examples

Subscripting by index, Range and ClosedRange.  Unicode supported.

```swift
str = "A😎B👩‍🚀CDE"

str[1] // 😎
str[2] // B
str[3] // 👩‍🚀

str[1..<4] // 😎B👩‍🚀

str[1...4] // 😎B👩‍🚀C
```




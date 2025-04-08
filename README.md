# TryRegex

Build your Swift Regex - How to implement regular expressions in Swift

## Overview

This repository contains sample code from my talk at try! Swift 2025. You can learn how regular expressions work by building your own tiny regular expression engine with limited specifications.

The talk is titled "Build your own regex engine" and was presented at try! Swift 2025 in Tokyo, Japan. The slides are available on iCloud.
[You can read the slides here](https://www.icloud.com/keynote/05cS1btc22VKpxnUiYTI7w0pQ#Build_your_own_regex_engine).

The code is written in Swift and is designed to be simple and easy to understand. The goal is to help you learn how regular expressions work under the hood.

## Three Fondamental Operations of Regex

These three operations are the foundation of regular expressions. By combining these operations, you can create complex patterns to match strings.

- Concatenation: This operation allows you to match a sequence of characters in a specific order. For example, the regex `abc` matches the string "abc".
- Alternation: This operation allows you to match one of several possible patterns. For example, the regex `a|b` matches either "a" or "b".
- Repetition: This operation allows you to match a pattern zero or more times. For example, the regex `a*` matches the string "aaa", "aa", "a", or "" (an empty string).

All other syntax of regex can be implemented using these three operations. For example, the regex `a?` can be implemented as `a*|ε`, where ε is the empty string. The regex `a+` can be implemented as `aa*`, where `a*` matches zero or more occurrences of "a". The regex `[a-z]` can be implemented as `a|b|c|...|z`, where each letter is separated by the alternation operator `|`.

## How to Use

```swift
let regex = Regex<String>(_regexString: "a|b|c")
let input = "a"

if let result = regex.firstMatch(in: input) {
    print("Matched! \(result)")
} else {
    print("Not matched.")
}
```

This code creates a regex object with the pattern "abc" and checks if the string "abc" matches the regex. If it does, it prints "Matched!", otherwise it prints "Not matched.".

## Specifications

This repository contains two projects. The project in the [01 directory](https://github.com/kishikawakatsumi/TryRegex/tree/main/01/TryRegex) is a regular expression engine that implements the following minimal specifications.

### 01. Minimal Implementation

The first implementation is a minimal regex engine that supports the following features:

- Concatenation
- Alternation `|`
- Repetition `*`
- Grouping `()`

### 02. Optional and Plus

The second implementation is an extension of the first one, adding support for optional and plus operators. The following features are added:

The project in the [02 directory](https://github.com/kishikawakatsumi/TryRegex/tree/main/02/TryRegex) is a regular expression engine that implements the following additional specifications.

- Optional `?`
- One or more `+`

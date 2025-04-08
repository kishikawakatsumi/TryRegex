import Testing
@testable import RegexParser
@testable import StringProcessing

@Test func testMatch01() throws {
  let pattern = "a"
  let input = "cab"

  let start = input.index(input.startIndex, offsetBy: 1)
  let end = input.index(input.startIndex, offsetBy: 2)
  let range = start..<end

  let regex = Regex<String>(_regexString: pattern)
  let result = try regex.firstMatch(in: input)

  let match = try #require(result)

  #expect(match.range == range)
  #expect(input[match.range] == "a")
}

@Test func testMatch02() throws {
  let pattern = "a"
  let input = "ccab"

  let start = input.index(input.startIndex, offsetBy: 2)
  let end = input.index(input.startIndex, offsetBy: 3)
  let range = start..<end

  let regex = Regex<String>(_regexString: pattern)
  let result = try regex.firstMatch(in: input)

  let match = try #require(result)

  #expect(match.range == range)
  #expect(input[match.range] == "a")
}

@Test func testMatch03() throws {
  let pattern = "ab"
  let input = "ccab"

  let start = input.index(input.startIndex, offsetBy: 2)
  let end = input.index(input.startIndex, offsetBy: 4)
  let range = start..<end

  let regex = Regex<String>(_regexString: pattern)
  let result = try regex.firstMatch(in: input)

  let match = try #require(result)

  #expect(match.range == range)
  #expect(input[match.range] == "ab")
}

@Test func testMatch04() throws {
  let pattern = "e|a"
  let input = "ccab"

  let start = input.index(input.startIndex, offsetBy: 2)
  let end = input.index(input.startIndex, offsetBy: 3)
  let range = start..<end

  let regex = Regex<String>(_regexString: pattern)
  let result = try regex.firstMatch(in: input)

  let match = try #require(result)

  #expect(match.range == range)
  #expect(input[match.range] == "a")
}

@Test func testMatch05() throws {
  let pattern = "a*"
  let input = "ccaab"

  let start = input.index(input.startIndex, offsetBy: 0)
  let end = input.index(input.startIndex, offsetBy: 0)
  let range = start..<end

  let regex = Regex<String>(_regexString: pattern)
  let result = try regex.firstMatch(in: input)

  let match = try #require(result)

  #expect(match.range == range)
  #expect(input[match.range] == "")
}

@Test func testMatch06() throws {
  let pattern = "aa*"
  let input = "ccaaab"

  let start = input.index(input.startIndex, offsetBy: 2)
  let end = input.index(input.startIndex, offsetBy: 5)
  let range = start..<end

  let regex = Regex<String>(_regexString: pattern)
  let result = try regex.firstMatch(in: input)

  let match = try #require(result)

  #expect(match.range == range)
  #expect(input[match.range] == "aaa")
}

@Test func testMatch07() throws {
  let pattern = "(|a)"
  let input = "ccaab"

  let start = input.index(input.startIndex, offsetBy: 0)
  let end = input.index(input.startIndex, offsetBy: 0)
  let range = start..<end

  let regex = Regex<String>(_regexString: pattern)
  let result = try regex.firstMatch(in: input)

  let match = try #require(result)

  #expect(match.range == range)
  #expect(input[match.range] == "")
}

@Test func testMatch08() throws {
  let pattern = "(ab)"
  let input = "ccaab"

  let start = input.index(input.startIndex, offsetBy: 3)
  let end = input.index(input.startIndex, offsetBy: 5)
  let range = start..<end

  let regex = Regex<String>(_regexString: pattern)
  let result = try regex.firstMatch(in: input)

  let match = try #require(result)

  #expect(match.range == range)
  #expect(input[match.range] == "ab")
}

@Test func testMatch09() throws {
  let pattern = "(ab)"
  let input = "ccaabe"

  let start = input.index(input.startIndex, offsetBy: 3)
  let end = input.index(input.startIndex, offsetBy: 5)
  let range = start..<end

  let regex = Regex<String>(_regexString: pattern)
  let result = try regex.firstMatch(in: input)

  let match = try #require(result)

 #expect(match.range == range)
  #expect(input[match.range] == "ab")
}

@Test func testMatch10() throws {
  let pattern = "(ab)|(bc)"
  let input = "ccabce"

  let start = input.index(input.startIndex, offsetBy: 2)
  let end = input.index(input.startIndex, offsetBy: 4)
  let range = start..<end

  let regex = Regex<String>(_regexString: pattern)
  let result = try regex.firstMatch(in: input)

  let match = try #require(result)

  #expect(match.range == range)
  #expect(input[match.range] == "ab")
}

@Test func testMatch11() throws {
  let pattern = "(ab)|(bc)"
  let input = "ccebce"

  let start = input.index(input.startIndex, offsetBy: 3)
  let end = input.index(input.startIndex, offsetBy: 5)
  let range = start..<end

  let regex = Regex<String>(_regexString: pattern)
  let result = try regex.firstMatch(in: input)

  let match = try #require(result)

  #expect(match.range == range)
  #expect(input[match.range] == "bc")
}

@Test func testMatch12() throws {
  let pattern = "Bob|Robert"
  let input = "Robert"

  let start = input.index(input.startIndex, offsetBy: 0)
  let end = input.index(input.startIndex, offsetBy: 6)
  let range = start..<end

  let regex = Regex<String>(_regexString: pattern)
  let result = try regex.firstMatch(in: input)

  let match = try #require(result)

  #expect(match.range == range)
  #expect(input[match.range] == "Robert")
}

@Test func testMatch13() throws {
  let pattern = "Bob|Robert"
  let input = "Bob"

  let start = input.index(input.startIndex, offsetBy: 0)
  let end = input.index(input.startIndex, offsetBy: 3)
  let range = start..<end

  let regex = Regex<String>(_regexString: pattern)
  let result = try regex.firstMatch(in: input)

  let match = try #require(result)

  #expect(match.range == range)
  #expect(input[match.range] == "Bob")
}

@Test func testMatch14() throws {
  let pattern = "gr(a|e)y"
  let input = "grey"

  let start = input.index(input.startIndex, offsetBy: 0)
  let end = input.index(input.startIndex, offsetBy: 4)
  let range = start..<end

  let regex = Regex<String>(_regexString: pattern)
  let result = try regex.firstMatch(in: input)

  let match = try #require(result)

  #expect(match.range == range)
  #expect(input[match.range] == "grey")
}

@Test func testMatch16() throws {
  let pattern = "cat"
  let input = "The dragging belly indicates your cat is too fat"

  let start = input.index(input.startIndex, offsetBy: 23)
  let end = input.index(input.startIndex, offsetBy: 26)
  let range = start..<end

  let regex = Regex<String>(_regexString: pattern)
  let result = try regex.firstMatch(in: input)

  let match = try #require(result)

  #expect(match.range == range)
  #expect(input[match.range] == "cat")
}

@Test func testMatch17() throws {
  let pattern = "fat|cat|belly|your"
  let input = "The dragging belly indicates your cat is too fat"

  let start = input.index(input.startIndex, offsetBy: 13)
  let end = input.index(input.startIndex, offsetBy: 18)
  let range = start..<end

  let regex = Regex<String>(_regexString: pattern)
  let result = try regex.firstMatch(in: input)

  let match = try #require(result)

  #expect(match.range == range)
  #expect(input[match.range] == "belly")
}

@Test func testMatch18() throws {
  let pattern = "a(|b)c"
  let inputs = ["abc", "ac"]

  for input in inputs {
    let range = input.startIndex..<input.endIndex

    let regex = Regex<String>(_regexString: pattern)
    let result = try regex.firstMatch(in: input)

    let match = try #require(result)

    #expect(match.range == range)
    #expect(input[match.range] == input)
  }
}

@Test func testMatch19() throws {
  let pattern = "a(|b)c"
  let input = "abc"

  let start = input.index(input.startIndex, offsetBy: 0)
  let end = input.index(input.startIndex, offsetBy: 3)
  let range = start..<end

  let regex = Regex<String>(_regexString: pattern)
  let result = try regex.firstMatch(in: input)

  let match = try #require(result)

  #expect(match.range == range)
  #expect(input[match.range] == "abc")
}

@Test func testMatch20() throws {
  let pattern = "a*"
  let input = "aaaaa"

  let start = input.index(input.startIndex, offsetBy: 0)
  let end = input.index(input.startIndex, offsetBy: 5)
  let range = start..<end

  let regex = Regex<String>(_regexString: pattern)
  let result = try regex.firstMatch(in: input)

  let match = try #require(result)

  #expect(match.range == range)
  #expect(input[match.range] == "aaaaa")
}

@Test func testMatch21() throws {
  let pattern = "a+"
  let input = "ccaa+b"

  let start = input.index(input.startIndex, offsetBy: 3)
  let end = input.index(input.startIndex, offsetBy: 5)
  let range = start..<end

  let regex = Regex<String>(_regexString: pattern)
  let result = try regex.firstMatch(in: input)

  let match = try #require(result)

  #expect(match.range == range)
  #expect(input[match.range] == "a+")
}

@Test func testMatch22() throws {
  let pattern = "a?"
  let input = "cca?ab"

  let start = input.index(input.startIndex, offsetBy: 2)
  let end = input.index(input.startIndex, offsetBy: 4)
  let range = start..<end

  let regex = Regex<String>(_regexString: pattern)
  let result = try regex.firstMatch(in: input)

  let match = try #require(result)

  #expect(match.range == range)
  #expect(input[match.range] == "a?")
}

@Test func testMatch23() throws {
  let pattern = "a(a)*"
  let input = "ccaaab"

  let start = input.index(input.startIndex, offsetBy: 2)
  let end = input.index(input.startIndex, offsetBy: 5)
  let range = start..<end

  let regex = Regex<String>(_regexString: pattern)
  let result = try regex.firstMatch(in: input)

  let match = try #require(result)

  #expect(match.range == range)
  #expect(input[match.range] == "aaa")
}

@Test func testNotMatch01() throws {
  let pattern = "a"
  let input = "bb"

  let regex = Regex<String>(_regexString: pattern)
  let match = try regex.firstMatch(in: input)

  #expect(match == nil)
}

@Test func testNotMatch02() throws {
  let pattern = "ab?c"
  let input = "abbc"

  let regex = Regex<String>(_regexString: pattern)
  let match = try regex.firstMatch(in: input)

  #expect(match == nil)
}

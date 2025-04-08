public struct Source {
  var input: Input
  var bounds: Range<Input.Index>

  init(_ str: Input) {
    self.input = str
    self.bounds = str.startIndex..<str.endIndex
  }
}

extension Source {
  public typealias Input = String
  public typealias Char  = Character
}

extension Source {
  var _slice: Input.SubSequence { input[bounds] }

  var isEmpty: Bool { _slice.isEmpty }

  func peek() -> Char? { _slice.first }

  @discardableResult
  mutating func tryAdvance(_ n: Int = 1) -> Bool {
    guard n > 0, let newLower = _slice.index(
      bounds.lowerBound, offsetBy: n, limitedBy: bounds.upperBound
    )
    else {
      return false
    }
    self.bounds = newLower..<bounds.upperBound
    return true
  }
}

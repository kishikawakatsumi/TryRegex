internal import RegexParser

extension Regex {
  public struct Match {
    public let range: Range<String.Index>
  }
}

extension Regex {
  public func firstMatch(in string: String) throws -> Regex<Output>.Match? {
    let bounds = string.startIndex..<string.endIndex
    return try Executor.firstMatch(
      self.program.loweredProgram,
      string,
      subjectBounds: bounds,
      searchBounds: bounds
    )
  }
}

extension String {
  func characterAndEnd(
    at pos: String.Index, limitedBy end: String.Index
  ) -> (Character, String.Index)? {
    guard pos < end else { return nil }
    let next = index(after: pos)
    if next <= end {
      return (self[pos], next)
    }

    let substr = self[pos..<end]
    return substr.isEmpty ? nil : (substr.first!, substr.endIndex)
  }
}

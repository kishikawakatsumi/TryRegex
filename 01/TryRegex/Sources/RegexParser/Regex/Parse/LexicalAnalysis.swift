extension Parser {
  typealias Char = Source.Char
}

extension Parser {
  mutating func tryEating<T>(
    _ body: (inout Self) -> T?
  ) -> T? {
    guard let result = body(&self) else {
      return nil
    }
    return result
  }
}

extension Parser {
  typealias Quant = AST.Quantification

  @discardableResult
  mutating func expect(_ c: Character) -> Bool {
    guard tryEat(c) else {
      return false
    }
    return true
  }

  func peek() -> Char? { src.peek() }

  mutating func advance(_ n: Int = 1) {
    guard src.tryAdvance(n) else {
      fatalError("Advancing beyond end!")
    }
  }

  mutating func tryEat() -> Char? {
    guard let char = peek() else { return nil }
    advance()
    return char
  }

  mutating func tryEat(_ c: Char) -> Bool {
    guard peek() == c else { return false }
    advance()
    return true
  }
}

extension Parser {
  mutating func lexQuantifier() -> Quant.Amount? {
    tryEating { p in
      let amt: Quant.Amount? = {
        if p.tryEat("*") { return .zeroOrMore }
        return nil
      }()
      guard let amt = amt else { return nil }

      return amt
    }
  }

  mutating func lexGroupStart() -> AST.Group.Kind? {
    tryEating { p in
      guard p.tryEat("(") else { return nil }
      return .capture
    }
  }

  mutating func lexAtom() -> AST.Atom? {
    if src.isEmpty { return nil }
    if (peek() == ")" || peek() == "|") { return nil }

    guard let char = tryEat() else {
      fatalError("Unexpected end of input")
    }

    return AST.Atom(.char(char))
  }
}

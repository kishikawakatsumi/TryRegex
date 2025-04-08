struct Parser {
  var src: Source

  init(_ src: Source) {
    self.src = src
  }
}

extension Parser {
  mutating func parse() -> AST {
    let ast = parseNode()

    if !src.isEmpty {
      if tryEat(")") {
        fatalError("closing ')' does not balance any groups openings")
      } else {
        fatalError("Unhandled termination condition")
      }
    }

    return .init(ast)
  }

  mutating func parseNode() -> AST.Node {
    if src.isEmpty {
      return .empty(.init())
    }

    var result = [parseConcatenation()]
    while true {
      guard tryEat("|") else { break }
      result.append(parseConcatenation())
    }

    if result.count == 1 {
      return result[0]
    }

    return .alternation(.init(result))
  }

  mutating func parseConcatenation() -> AST.Node {
    var result = [AST.Node]()

    while true {
      if src.isEmpty {
        break
      }
      if peek() == "|" || peek() == ")" {
        break
      }

      if let operand = parseQuantifierOperand() {
        if let amt = lexQuantifier() {
          result.append(
            .quantification(.init(amt, operand))
          )
        } else {
          result.append(operand)
        }
        continue
      }

      fatalError("Should have parsed at least an atom")
      break
    }
    guard !result.isEmpty else {
      return .empty(.init())
    }
    if result.count == 1 {
      return result[0]
    }

    return .concatenation(.init(result))
  }

  mutating func parseGroupBody(
    _ kind: AST.Group.Kind
  ) -> AST.Group {
    let child = parseNode()
    expect(")")
    return .init(kind, child)
  }

  mutating func parseQuantifierOperand() -> AST.Node? {
    if let kind = lexGroupStart() {
      return .group(parseGroupBody(kind))
    }

    if let atom = lexAtom() {
      return .atom(atom)
    }

    return nil
  }
}

public func parse<S: StringProtocol>(_ regex: S) -> AST where S.SubSequence == Substring {
  let source = Source(String(regex))
  var parser = Parser(source)
  return parser.parse()
}

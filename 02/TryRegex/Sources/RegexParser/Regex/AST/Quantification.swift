extension AST {
  public struct Quantification {
    public let amount: Amount
    public let child: AST.Node

    public init(_ amount: Amount, _ child: AST.Node) {
      self.amount = amount
      self.child = child
    }

    public enum Amount: Hashable {
      case zeroOrMore // *
      case oneOrMore  // +
      case zeroOrOne  // ?
    }
  }
}

extension AST.Quantification.Amount {
  public var bounds: (atLeast: Int?, atMost: Int?) {
    switch self {
    case .zeroOrMore: return (0, nil)
    case .oneOrMore:  return (1, nil)
    case .zeroOrOne:  return (0, 1)
    }
  }
}

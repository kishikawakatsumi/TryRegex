public struct AST {
  public var root: AST.Node

  public init(_ root: AST.Node) {
    self.root = root
  }
}

extension AST {
  public indirect enum Node {
    case alternation(Alternation)
    case concatenation(Concatenation)
    case group(Group)
    case quantification(Quantification)
    case atom(Atom)
    case empty(Empty)
  }
}

extension AST {
  public struct Alternation {
    public let children: [AST.Node]

    public init(_ mems: [AST.Node]) {
      self.children = mems
    }
  }

  public struct Concatenation {
    public let children: [AST.Node]

    public init(_ mems: [AST.Node]) {
      self.children = mems
    }
  }

  public struct Empty {}
}

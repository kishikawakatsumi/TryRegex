extension AST {
  public struct Group {
    public let kind: Kind
    public let child: AST.Node

    public init(_ kind: Kind, _ child: AST.Node) {
      self.kind = kind
      self.child = child
    }

    public enum Kind {
      case capture
    }
  }
}

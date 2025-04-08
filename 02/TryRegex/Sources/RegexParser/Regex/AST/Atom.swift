extension AST {
  public struct Atom {
    public let kind: Kind

    public init(_ k: Kind) {
      self.kind = k
    }

    public enum Kind {
      case char(Character)
    }
  }
}

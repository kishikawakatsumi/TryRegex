internal import RegexParser

public struct DSLTree {
  var root: Node

  init(_ r: Node) {
    self.root = r
  }
}

extension DSLTree {
  indirect enum Node {
    case orderedChoice([Node])

    case concatenation([Node])

    case capture(Node)

    case quantification(
      _AST.QuantificationAmount,
      Node
    )

    case atom(Atom)
    
    case empty
  }
}

extension DSLTree {
  public enum Atom {
    case char(Character)
  }
}

extension DSLTree {
  public enum _AST {
    public struct QuantificationAmount {
      internal var ast: AST.Quantification.Amount

      public static var zeroOrMore: Self {
        .init(ast: .zeroOrMore)
      }
      public static var oneOrMore: Self {
        .init(ast: .oneOrMore)
      }
      public static var zeroOrOne: Self {
        .init(ast: .zeroOrOne)
      }
    }

    public struct ASTNode {
      internal var ast: AST.Node
    }

    public struct Atom {
      internal var ast: AST.Atom
    }
  }
}

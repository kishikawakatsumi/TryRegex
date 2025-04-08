internal import RegexParser

extension AST {
  var dslTree: DSLTree {
    return DSLTree(root.dslTreeNode)
  }
}

extension AST.Node {
  var dslTreeNode: DSLTree.Node {
    func convert() throws -> DSLTree.Node {
      switch self {
      case let .alternation(v):
        let children = v.children.map(\.dslTreeNode)
        return .orderedChoice(children)

      case let .concatenation(v):
        return .concatenation(v.children.map(\.dslTreeNode))

      case let .group(v):
        let child = v.child.dslTreeNode
        switch v.kind {
        case .capture:
          return .capture(child)
        }
      case let .quantification(v):
        let child = v.child.dslTreeNode
        return .quantification(
          .init(ast: v.amount), child)

      case let .atom(v):
        switch v.kind {
        default:
          return .atom(v.dslTreeAtom)
        }

      case .empty(_):
        return .empty
      }
    }

    let converted = try! convert()
    return converted
  }
}

extension AST.Atom {
  var dslTreeAtom: DSLTree.Atom {
    switch self.kind {
    case let .char(c): return .char(c)
    }
  }
}

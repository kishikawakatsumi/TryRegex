internal import RegexParser

public struct Regex<Output> {
  let program: Program

  init(ast: AST) {
    self.program = Program(ast: ast)
  }
  init(ast: AST.Node) {
    self.program = Program(
      ast: .init(ast)
    )
  }

  @usableFromInline
  init(_regexString pattern: String) {
    self.init(ast: parse(pattern))
  }
}

extension Regex {
  internal final class Program {
    let tree: DSLTree

    var loweredProgram: MEProgram {
      let compiledProgram = try! Compiler(tree: tree).emit()
      return compiledProgram
    }

    init(ast: AST) {
      self.tree = ast.dslTree
    }

    init(tree: DSLTree) {
      self.tree = tree
    }
  }
}

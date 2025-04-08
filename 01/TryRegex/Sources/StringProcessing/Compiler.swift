internal import RegexParser

class Compiler {
  let tree: DSLTree

  init(ast: AST) {
    self.tree = ast.dslTree
  }

  init(tree: DSLTree) {
    self.tree = tree
  }

  __consuming func emit() throws -> MEProgram {
    var codegen = ByteCodeGen()
    return try codegen.emitRoot(tree.root)
  }
}

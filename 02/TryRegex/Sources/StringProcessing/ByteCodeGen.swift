internal import RegexParser

extension Compiler {
  struct ByteCodeGen {
    var builder = MEProgram.Builder()
  }
}

extension Compiler.ByteCodeGen {
  mutating func emitRoot(_ root: DSLTree.Node) throws -> MEProgram {
    try emitNode(root)
    builder.buildAccept()

    return try builder.assemble()
  }
}

fileprivate extension Compiler.ByteCodeGen {
  mutating func emitAtom(_ a: DSLTree.Atom) throws {
    switch a {
    case let .char(c):
      emitCharacter(c)
    }
  }

  mutating func emitCharacter(_ c: Character) {
    builder.buildMatch(c)
  }

  mutating func emitAlternationGen<C: BidirectionalCollection>(
    _ elements: C,
    withBacktracking: Bool,
    _ body: (inout Compiler.ByteCodeGen, C.Element) throws -> Void
  ) rethrows {
    let done = builder.makeAddress()
    for element in elements.dropLast() {
      let next = builder.makeAddress()
      builder.buildSave(next)
      try body(&self, element)
      builder.buildBranch(to: done)
      builder.label(next)
    }
    try body(&self, elements.last!)
    builder.label(done)
  }

  mutating func emitAlternation(
    _ children: [DSLTree.Node]
  ) throws {
    try emitAlternationGen(children, withBacktracking: true) {
      try $0.emitNode($1)
    }
  }

  mutating func emitConcatenationComponent(
    _ node: DSLTree.Node
  ) throws {
    try emitNode(node)
  }

  mutating func emitQuantification(
    _ amount: AST.Quantification.Amount,
    _ child: DSLTree.Node
  ) throws {
    let (low, high) = amount.bounds
    guard let low = low else {
      fatalError("Must have a lower bound")
    }

    let maxExtraTrips: Int?
    if let h = high {
      maxExtraTrips = h - low
    } else {
      maxExtraTrips = nil
    }
    let minTrips = low

    let minTripsControl = builder.makeAddress()
    let loopBody = builder.makeAddress()
    let exitPolicy = builder.makeAddress()
    let exit = builder.makeAddress()

    let maxExtraTripsReg: IntRegister?
    if (maxExtraTrips ?? 0) > 0 {
      maxExtraTripsReg = builder.makeIntRegister(
        initialValue: maxExtraTrips!
      )
    } else {
      maxExtraTripsReg = nil
    }

    builder.label(minTripsControl)
    switch minTrips {
    case 0: builder.buildBranch(to: exitPolicy)
    default: break
    }

    builder.label(loopBody)
    try emitNode(child)

    builder.label(exitPolicy)

    switch maxExtraTrips {
    case nil:
      break
    case 0:
      builder.buildBranch(to: exit)
    default:
      builder.buildCondBranch(to: exit, ifZeroElseDecrement: maxExtraTripsReg!)
    }

    builder.buildSplit(to: loopBody, saving: exit)
    builder.label(exit)
  }

  mutating func emitConcatenation(_ children: [DSLTree.Node]) throws {
    for child in children {
      try emitConcatenationComponent(child)
    }
  }

  mutating func emitNode(_ node: DSLTree.Node) throws {
    switch node {
    case let .orderedChoice(children):
      try emitAlternation(children)

    case let .concatenation(children):
      try emitConcatenation(children)

    case .capture(let child):
      try emitNode(child)

    case let .quantification(amt, child):
      try emitQuantification(amt.ast, child)

    case let .atom(a):
      try emitAtom(a)

    case .empty:
      return
    }
  }
}

struct Instruction {
  let opcode: Instruction.OpCode
  let payload: Instruction.Payload

  init(_ opcode: Instruction.OpCode) {
    self.init(opcode, .none)
  }

  init(_ opcode: Instruction.OpCode, _ payload: Instruction.Payload) {
    self.opcode = opcode
    self.payload = payload
  }
}

extension Instruction {
  enum OpCode: UInt64 {
    case invalid = 0

    case moveImmediate

    case branch

    case condBranchZeroElseDecrement

    case match

    case save

    case splitSaving

    case accept
  }
}

extension Instruction {
  var destructure: (opcode: OpCode, payload: Payload) {
    get { (opcode, payload) }
    set { self = Self(opcode, payload) }
  }
}

enum State {
  case inProgress
  case fail
  case accept
}

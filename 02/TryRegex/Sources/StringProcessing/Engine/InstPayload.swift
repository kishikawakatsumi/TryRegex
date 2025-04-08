extension Instruction {
  enum Payload {
    case none
    case int(Int)
    case element(Character)
    case addr(InstructionAddress)
    case pairedImmediateInt(UInt64, Int)
    case pairedAddrInt(InstructionAddress, Int)
    case pairedAddrAddr(InstructionAddress, InstructionAddress)
  }
}

extension Instruction.Payload {
  init(int: Int) {
    self = .int(int)
  }
  var int: Int {
    guard case .int(let value) = self else {
      fatalError("Payload is not an operand.")
    }
    return value
  }

  init(element: Character) {
    self = .element(element)
  }
  var elementPayload: Character {
    guard case .element(let element) = self else {
      fatalError("Payload is not an operand.")
    }
    return element
  }

  init(addr: InstructionAddress) {
    self = .addr(addr)
  }
  var addr: InstructionAddress {
    guard case .addr(let addr) = self else {
      fatalError("Payload is not an address.")
    }
    return addr
  }

  init(immediate: UInt64, int: IntRegister) {
    self = .pairedImmediateInt(immediate, int)
  }
  var pairedImmediateInt: (UInt64, IntRegister) {
    guard case .pairedImmediateInt(let i, let r) = self else {
      fatalError("Payload is not an address pair.")
    }
    return (i, r)
  }

  init(addr: InstructionAddress, int: Int) {
    self = .pairedAddrInt(addr, int)
  }
  var pairedAddrInt: (InstructionAddress, Int) {
    guard case .pairedAddrInt(let addr, let i) = self else {
      fatalError("Payload is not an address pair.")
    }
    return (addr, i)
  }

  init(addr: InstructionAddress, addr2: InstructionAddress) {
    self = .pairedAddrAddr(addr, addr2)
  }
  var pairedAddrAddr: (InstructionAddress, InstructionAddress) {
    guard case .pairedAddrAddr(let a1, let a2) = self else {
      fatalError("Payload is not an address pair.")
    }
    return (a1, a2)
  }
}

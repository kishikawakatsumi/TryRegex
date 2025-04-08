internal import RegexParser // For errors

typealias InstructionAddress = Int

extension MEProgram {
  struct Builder {
    var instructions: [Instruction] = []

    var elements = Array<Input.Element>()

    var addressTokens: [InstructionAddress?] = []
    var addressFixups: [(InstructionAddress, AddressFixup)] = []

    var nextIntRegister = IntRegister(0)
  }
}

extension MEProgram.Builder {
  struct AddressFixup {
    var first: AddressToken
    var second: AddressToken? = nil
    
    init(_ a: AddressToken) { self.first = a }
    init(_ a: AddressToken, _ b: AddressToken) {
      self.first = a
      self.second = b
    }
  }
}

extension MEProgram.Builder {
  mutating func buildBranch(to t: AddressToken) {
    instructions.append(.init(.branch))
    fixup(to: t)
  }

  mutating func buildSave(_ t: AddressToken) {
    instructions.append(.init(.save))
    fixup(to: t)
  }

  mutating func buildSplit(
    to: AddressToken, saving: AddressToken
  ) {
    instructions.append(.init(.splitSaving))
    fixup(to: (to, saving))
  }

  mutating func buildMatch(_ e: Character) {
    instructions.append(.init(.match, .init(element: e)))
  }

  mutating func buildAccept() {
    instructions.append(.init(.accept))
  }

  mutating func assemble() throws -> MEProgram {
    var instructions = instructions
    for (instAddr, tok) in addressFixups {
      let inst = instructions[instAddr]
      let addr = addressTokens[tok.first]!
      let payload: Instruction.Payload

      switch inst.opcode {
      case .branch, .save:
        payload = .init(addr: addr)
      case .splitSaving:
        guard let fix2 = tok.second else {
          fatalError()
        }
        let saving = addressTokens[fix2]!
        payload = .init(addr: addr, addr2: saving)
      default:
        fatalError()
      }

      instructions[instAddr] = .init(inst.opcode, payload)
    }

    let regs = Processor.Registers(
      numInts: nextIntRegister
    )

    let program = MEProgram(
      instructions: instructions,
      registers: regs
    )
    return program
  }
}

extension MEProgram.Builder {
  enum _AddressToken {}
  typealias AddressToken = Int

  mutating func makeAddress() -> AddressToken {
    defer { addressTokens.append(nil) }
    return AddressToken(addressTokens.count)
  }

  mutating func label(_ t: AddressToken) {
    addressTokens[t] = InstructionAddress(instructions.count)
  }

  mutating func fixup(to t: AddressToken) {
    assert(!instructions.isEmpty)
    addressFixups.append(
      (InstructionAddress(instructions.endIndex - 1), .init(t)))
  }

  mutating func fixup(to ts: (AddressToken, AddressToken)) {
    assert(!instructions.isEmpty)
    addressFixups.append((
      InstructionAddress(instructions.endIndex - 1),
      .init(ts.0, ts.1)))
  }
}

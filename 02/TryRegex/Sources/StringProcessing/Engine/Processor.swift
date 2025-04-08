internal import RegexParser

struct Controller: Equatable {
  var pc: Int

  mutating func step() {
    pc += 1
  }
}

struct Processor {
  typealias Input = String
  typealias Element = Input.Element

  let input: Input
  let subjectBounds: Range<Position>
  let instructions: [Instruction]

  var searchBounds: Range<Position>
  var currentPosition: Position
  var controller: Controller
  var registers: Registers
  var savePoints: [SavePoint] = []
  var state: State = .inProgress
}

extension Processor {
  typealias Position = Input.Index

  var start: Position { searchBounds.lowerBound }
  var end: Position { searchBounds.upperBound }
}

extension Processor {
  init(
    program: MEProgram,
    input: Input,
    subjectBounds: Range<Position>,
    searchBounds: Range<Position>
  ) {
    self.controller = Controller(pc: 0)
    self.instructions = program.instructions
    self.input = input
    self.subjectBounds = subjectBounds
    self.searchBounds = searchBounds

    self.currentPosition = searchBounds.lowerBound

    self.registers = program.registers
  }

  mutating func reset(
    currentPosition: Position,
    searchBounds: Range<Position>
  ) {
    self.currentPosition = currentPosition
    self.searchBounds = searchBounds

    self.controller = Controller(pc: 0)

    if !self.savePoints.isEmpty {
      self.savePoints.removeAll(keepingCapacity: true)
    }

    self.state = .inProgress
  }
}

extension Processor {
  func fetch() -> (Instruction.OpCode, Instruction.Payload) {
    instructions[controller.pc].destructure
  }

  mutating func match(_ e: Element) -> Bool {
    guard let next = input.match(
      e,
      at: currentPosition,
      limitedBy: end
    ) else {
      signalFailure()
      return false
    }
    
    currentPosition = next
    return true
  }

  mutating func signalFailure(preservingCaptures: Bool = false) {
    guard !savePoints.isEmpty else {
      state = .fail
      return
    }

    let (pc, pos) = savePoints.removeLast().destructure

    controller.pc = pc
    currentPosition = pos ?? currentPosition
  }

  mutating func tryAccept() {
    state = .accept
  }

  mutating func cycle() {
    let (opcode, payload) = fetch()
    switch opcode {
    case .invalid:
      fatalError("Invalid program")

    case .moveImmediate:
      let (imm, reg) = payload.pairedImmediateInt
      let int = Int(truncatingIfNeeded: imm)

      registers[reg] = int
      controller.step()

    case .branch:
      controller.pc = payload.addr

    case .condBranchZeroElseDecrement:
      let (addr, int) = payload.pairedAddrInt
      if registers[int] == 0 {
        controller.pc = addr
      } else {
        registers[int] -= 1
        controller.step()
      }

    case .save:
      let resumeAddr = payload.addr
      let sp = makeSavePoint(resumingAt: resumeAddr)
      savePoints.append(sp)
      controller.step()

    case .splitSaving:
      let (nextPC, resumeAddr) = payload.pairedAddrAddr
      let sp = makeSavePoint(resumingAt: resumeAddr)
      savePoints.append(sp)
      controller.pc = nextPC

    case .accept:
      tryAccept()

    case .match:
      let element = payload.elementPayload
      if match(element) {
        controller.step()
      }
    }
  }
}

extension String {
  func match(
    _ char: Character,
    at pos: Index,
    limitedBy end: String.Index
  ) -> Index? {
    guard let (stringChar, next) = characterAndEnd(at: pos, limitedBy: end) else { return nil }
    guard stringChar == char else { return nil }

    return next
  }
}

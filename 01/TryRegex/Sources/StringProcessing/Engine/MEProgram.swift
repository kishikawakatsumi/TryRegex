internal import RegexParser

struct MEProgram {
  typealias Input = String

  var instructions: [Instruction]
  var registers: Processor.Registers
}

extension Processor {
  struct SavePoint {
    var pc: InstructionAddress
    var pos: Position?

    var destructure: (
      pc: InstructionAddress,
      pos: Position?
    ) {
      return (pc, pos)
    }
  }

  func makeSavePoint(
    resumingAt pc: InstructionAddress
  ) -> SavePoint {
    SavePoint(
      pc: pc,
      pos: currentPosition
    )
  }
}

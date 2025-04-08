internal import RegexParser

typealias IntRegister = Int

extension Processor {
  struct Registers {
    var isDirty = false
    var ints: [Int]

    init(
      isDirty: Bool = false,
      numInts: Int
    ) {
      self.isDirty = isDirty
      self.ints = Array(repeating: 0, count: numInts)
    }
  }
}

extension Processor.Registers {
  typealias Input = String

  subscript(_ i: IntRegister) -> Int {
    get { ints[i] }
    set {
      isDirty = true
      ints[i] = newValue
    }
  }
}

extension Processor.Registers {
  mutating func reset() {
    guard isDirty else {
      return
    }
    self.ints._setAll(to: 0)
  }
}

extension MutableCollection {
  mutating func _setAll(to e: Element) {
    for idx in self.indices {
      self[idx] = e
    }
  }
}

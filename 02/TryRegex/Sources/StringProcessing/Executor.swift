internal import RegexParser

enum Executor<Output> {
  static func firstMatch(
    _ program: MEProgram,
    _ input: String,
    subjectBounds: Range<String.Index>,
    searchBounds: Range<String.Index>
  ) throws -> Regex<Output>.Match? {
    var cpu = Processor(
      program: program,
      input: input,
      subjectBounds: subjectBounds,
      searchBounds: searchBounds
    )
    return try Executor._firstMatch(
      program,
      using: &cpu
    )
  }

  static func _firstMatch(
    _ program: MEProgram,
    using cpu: inout Processor
  ) throws -> Regex<Output>.Match? {
    var low = cpu.searchBounds.lowerBound
    let high = cpu.searchBounds.upperBound
    while true {
      if let m = try Executor._run(program, &cpu) {
        return m
      }

      if low == high {
        return nil
      }

      cpu.input.unicodeScalars.formIndex(after: &low)

      guard low <= high else {
        return nil
      }

      cpu.reset(currentPosition: low, searchBounds: cpu.searchBounds)
    }
  }
}

extension Executor {
  static func _run(
    _ program: MEProgram,
    _ input: String,
    subjectBounds: Range<String.Index>,
    searchBounds: Range<String.Index>
  ) throws -> Regex<Output>.Match? {
    var cpu = Processor(
      program: program,
      input: input,
      subjectBounds: subjectBounds,
      searchBounds: searchBounds
    )
    return try _run(program, &cpu)
  }

  static func _run(
    _ program: MEProgram,
    _ cpu: inout Processor
  ) throws -> Regex<Output>.Match? {
    let startPosition = cpu.currentPosition
    guard let endIdx = try cpu.run() else {
      return nil
    }

    let range = startPosition..<endIdx
    return .init(range: range)
  }
}

extension Processor {
  fileprivate mutating func run() throws -> Input.Index? {
    if self.state == .fail {
      return nil
    }

    while true {
      switch self.state {
      case .accept:
        return self.currentPosition
      case .fail:
        return nil
      case .inProgress:
        self.cycle()
      }
    }
  }
}

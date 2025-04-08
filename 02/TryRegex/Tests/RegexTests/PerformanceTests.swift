import Foundation
import Testing

@Suite("Performance tests", .serialized)
struct PerformanceTests {
  @Suite("Swift Regex performance tests")
  struct SwiftRegexPerformanceTests {
    @Test("Factor out required components from the front of alternation")
    func alternation() async throws {
      let text = """
      The theory that the mathematician proposed about the threshold of the universe was both innovative and controversial.
      """

      let pattern1 = #/this|that|the/#
      let pattern2 = #/th(is|at|e)/#

      let iterations = 10_000

      measureTime(label: "Pattern1 (this|that|the)") {
        for _ in 0..<iterations {
          _ = text.matches(of: pattern1)
        }
      }

      measureTime(label: "Pattern2 (th(is|at|e))") {
        for _ in 0..<iterations {
          _ = text.matches(of: pattern2)
        }
      }
    }

    @Test("Factor out required components from quantifiers")
    func quantification() async throws {
      let text = """
      struct A<T>{
        let v: T
      }
      <<<<<<< HEAD
      func f(a: A<A<A<A<A<A<A<A<A<A<A<A<A<A<A<A<A<A<A<A<A<A<String>>>>>>>>>>>>>>>>>>>>>>){
      =======
      func f(a: A<String>){
      >>>>>>> develop
        print(a)
      }
      """

      // Swift Regex（Swift 5.7 以降）でパターンを定義
      let pattern1 = #/>* develop/#
      let pattern2 = #/>>>>>>> develop/#

      // 何回マッチ処理を実行するか
      let iterations = 10_000

      measureTime(label: "Pattern1 >* develop") {
        for _ in 0..<iterations {
          _ = text.matches(of: pattern1)
        }
      }

      measureTime(label: "Pattern2 >>>>>>> develop") {
        for _ in 0..<iterations {
          _ = text.matches(of: pattern2)
        }
      }
    }
  }

  @Suite("NSRegularExpression performance tests")
  struct NSRegularExpressionPerformanceTests {
    @Test("Factor out required components from the front of alternation")
    func alternation() async throws {
      let text = """
      The theory that the mathematician proposed about the threshold of the universe was both innovative and controversial.
      """

      let pattern1 = "this|that|the"
      let pattern2 = "th(is|at|e)"

      let regex1 = try NSRegularExpression(pattern: pattern1)
      let regex2 = try NSRegularExpression(pattern: pattern2)

      let iterations = 10_000

      measureTime(label: "Pattern1 (this|that|the)") {
        for _ in 0..<iterations {
          let range = NSRange(text.startIndex..<text.endIndex, in: text)
          _ = regex1.matches(in: text, options: [], range: range)
        }
      }

      measureTime(label: "Pattern2 (th(is|at|e))") {
        for _ in 0..<iterations {
          let range = NSRange(text.startIndex..<text.endIndex, in: text)
          _ = regex2.matches(in: text, options: [], range: range)
        }
      }
    }

    @Test("Factor out required components from quantifiers")
    func quantification() async throws {
      let text = """
      struct A<T>{
        let v: T
      }
      <<<<<<< HEAD
      func f(a: A<A<A<A<A<A<A<A<A<A<A<A<A<A<A<A<A<A<A<A<A<A<String>>>>>>>>>>>>>>>>>>>>>>){
      =======
      func f(a: A<String>){
      >>>>>>> develop
        print(a)
      }
      """

      let pattern1 = ">* develop"
      let pattern2 = ">>>>>>> develop"

      let regex1 = try NSRegularExpression(pattern: pattern1)
      let regex2 = try NSRegularExpression(pattern: pattern2)

      let iterations = 10_000

      measureTime(label: "Pattern1 >* develop") {
        for _ in 0..<iterations {
          let range = NSRange(text.startIndex..<text.endIndex, in: text)
          _ = regex1.matches(in: text, options: [], range: range)
        }
      }

      measureTime(label: "Pattern2 >>>>>>> develop") {
        for _ in 0..<iterations {
          let range = NSRange(text.startIndex..<text.endIndex, in: text)
          _ = regex2.matches(in: text, options: [], range: range)
        }
      }
    }
  }
}

func measureTime(label: String, block: () -> Void) {
  let start = CFAbsoluteTimeGetCurrent()
  block()
  let end = CFAbsoluteTimeGetCurrent()
  let diff = end - start
  print("\(label) took \(diff) seconds.")
}

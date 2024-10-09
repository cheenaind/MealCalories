import Foundation

protocol DateContent: Codable {
  var sectionDate: Date { get }
}

struct DateSection<T> {
  public let date: Date
  public var content: [T]
}

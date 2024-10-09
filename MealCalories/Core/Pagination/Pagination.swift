protocol Pagination: Codable {
    associatedtype Content: Codable
    var items: [Content] { get }
    var hasNext: Bool { get }
}


import Foundation

public struct Artist: Equatable, Hashable, Codable {
    public let id: UUID
    
    public let name: String
    public let birthday: Date
    
    public init(
        id: UUID,
        name: String,
        birthday: Date
    ) {
        self.id = id
        self.name = name
        self.birthday = birthday
    }
}

public extension Artist {
    static let sampleArtistID0: UUID = .init()
    static let sampleArtistID1: UUID = .init()
    
    static let sample0: Self = .init(
        id: sampleArtistID0,
        name: "Sample Artist 0",
        birthday: Date()
    )
    
    static let sample1: Self = .init(
        id: sampleArtistID1,
        name: "Sample Artist 1",
        birthday: Date()
    )
}

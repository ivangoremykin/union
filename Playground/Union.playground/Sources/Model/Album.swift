import Foundation

public struct Album: Equatable, Hashable, Codable {
    public let id: UUID
    
    public let title: String
    public let releaseDate: Date
    
    public let artistID: UUID
}

public extension Album {
    static let sampleAlbumID0: UUID = .init()
    static let sampleAlbumID1: UUID = .init()
    static let sampleAlbumID2: UUID = .init()
    
    static let sample0: Self = .init(
        id: sampleAlbumID0,
        title: "Sample Album 0",
        releaseDate: Date(),
        artistID: Artist.sampleArtistID0
    )
    
    static let sample1: Self = .init(
        id: sampleAlbumID1,
        title: "Sample Album 1",
        releaseDate: Date(),
        artistID: Artist.sampleArtistID0
    )
    
    static let sample2: Self = .init(
        id: sampleAlbumID2,
        title: "Sample Album 2",
        releaseDate: Date(),
        artistID: Artist.sampleArtistID1
    )
}

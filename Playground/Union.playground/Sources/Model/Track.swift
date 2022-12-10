import Foundation

public struct Track: Equatable, Hashable, Codable {
    public let id: UUID
    
    public let title: String
    public let duration: Double
    
    public let artistID: UUID
    public let albumID: UUID
}

public extension Track {
    static let sampleTrackID0: UUID = .init()
    static let sampleTrackID1: UUID = .init()
    static let sampleTrackID2: UUID = .init()
    static let sampleTrackID3: UUID = .init()
    static let sampleTrackID4: UUID = .init()
    static let sampleTrackID5: UUID = .init()
    static let sampleTrackID6: UUID = .init()
    
    static let sample0: Self = .init(
        id: sampleTrackID0,
        title: "Sample Track 0",
        duration: 180,
        artistID: Artist.sampleArtistID0,
        albumID: Album.sampleAlbumID0
    )
    
    static let sample1: Self = .init(
        id: sampleTrackID1,
        title: "Sample Track 1",
        duration: 181,
        artistID: Artist.sampleArtistID0,
        albumID: Album.sampleAlbumID0
    )
    
    static let sample2: Self = .init(
        id: sampleTrackID2,
        title: "Sample Track 2",
        duration: 182,
        artistID: Artist.sampleArtistID0,
        albumID: Album.sampleAlbumID0
    )
    
    static let sample3: Self = .init(
        id: sampleTrackID3,
        title: "Sample Track 3",
        duration: 183,
        artistID: Artist.sampleArtistID0,
        albumID: Album.sampleAlbumID1
    )
    
    static let sample4: Self = .init(
        id: sampleTrackID4,
        title: "Sample Track 4",
        duration: 184,
        artistID: Artist.sampleArtistID0,
        albumID: Album.sampleAlbumID1
    )
    
    static let sample5: Self = .init(
        id: sampleTrackID5,
        title: "Sample Track 5",
        duration: 185,
        artistID: Artist.sampleArtistID1,
        albumID: Album.sampleAlbumID2
    )
    
    static let sample6: Self = .init(
        id: sampleTrackID6,
        title: "Sample Track 6",
        duration: 186,
        artistID: Artist.sampleArtistID1,
        albumID: Album.sampleAlbumID2
    )
}

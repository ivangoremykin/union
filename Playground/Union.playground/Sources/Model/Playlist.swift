import Foundation

public struct Playlist: Equatable, Hashable, Codable {
    public let id: UUID
    
    let title: String
    
    let trackIDs: [UUID]
}

public extension Playlist {
    static let samplePlaylistID0: UUID = .init()

    static let sample0: Playlist = .init(
        id: samplePlaylistID0,
        title: "Sample Playlist 0",
        trackIDs: [
            Track.sampleTrackID0,
            Track.sampleTrackID1,
            Track.sampleTrackID2,
            Track.sampleTrackID3,
            Track.sampleTrackID4,
            Track.sampleTrackID5,
            Track.sampleTrackID6
        ]
    )
}

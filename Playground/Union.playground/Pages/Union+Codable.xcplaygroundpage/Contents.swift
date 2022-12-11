/*:
 An example for an article [Adding Codable conformance to Union with Metaprogramming](https://dev.to/ivangoremykin/adding-codable-conformance-to-union-with-metaprogramming-4k08-temp-slug-1197351).
 
 [Table of Contents](Table%20of%20Contents) · [Previous](@previous)
****
# Encoding and decoding Union
*/
//:## Adding UnionIdentifiable conformance
import Foundation

extension Album: UnionIdentifiable {
    public static var unionTypeID: UnionTypeID { "album" }
}

extension Artist: UnionIdentifiable {
    public static var unionTypeID: UnionTypeID { "artist" }
}

extension Playlist: UnionIdentifiable {
    public static var unionTypeID: UnionTypeID { "playlist" }
}
//:## Encode
let sample: [U2<Album, Playlist>] = [
    .init(Album.sample0),
    .init(Album.sample1),
    .init(Album.sample2),
    .init(Playlist.sample0)
]

let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted

let encodedSample = try encoder.encode(sample)
print(
    String(data: encodedSample, encoding: .utf8) ?? ""
)
//:## Decode
let decoder = JSONDecoder()

let decodedSample = try decoder.decode(
    [U2<Album, Playlist>].self,
    from: encodedSample
)

sample == decodedSample
//:## Decode as Union of larger size
let arrayOfU2: [U2<Album, Playlist>] = try decoder.decode(
    [U2<Album, Playlist>].self,
    from: encodedSample
)

let arrayOfU3 = try decoder.decode(
    [U3<Album, Playlist, Artist>].self,
    from: encodedSample
)

arrayOfU2.compactMap0() == arrayOfU3.compactMap0()
arrayOfU2.compactMap1() == arrayOfU3.compactMap1()

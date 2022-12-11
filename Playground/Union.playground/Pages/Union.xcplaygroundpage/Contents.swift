/*:
 An example for an article [Adding Union to Swift with Metaprogramming](https://dev.to/ivangoremykin/adding-union-to-swift-with-metaprogramming-510d-temp-slug-2422196).
 
 [Table of Contents](Table%20of%20Contents) · [Previous](@previous) · [Next](@next)
****
# Using a Union
*/
import Foundation

// MARK: Initialisation
let downloadableItem: U2<Artist, Album> = .init(Artist.sample0)
let recentlyViewedItem: U3<Artist, Album, Playlist> = .init(Playlist.sample0)

// MARK: Getters
let artist = downloadableItem.item0
let album = downloadableItem.item1

let playlist = recentlyViewedItem.item2

// MARK: Setters
var selectedItem: U3<Artist, Album, Playlist> = .init(Artist.sample0)
selectedItem.set(Artist.sample1)
selectedItem.set(Album.sample2)

// MARK: Compact Map
let recentlyViewedItems: [U3<Artist, Album, Playlist>] = [
    .init(Artist.sample0),
    .init(Artist.sample1),
    .init(Album.sample0),
    .init(Album.sample1),
    .init(Album.sample2),
    .init(Playlist.sample0),
]

let artists = recentlyViewedItems.compactMap0()
let albums = recentlyViewedItems.compactMap1()
let playlists = recentlyViewedItems.compactMap2()

// MARK: Equatable
selectedItem.set(Album.sample0)

selectedItem == U3<Artist, Album, Playlist>(Album.sample0)
selectedItem == Album.sample0

selectedItem == U3<Artist, Album, Playlist>(Album.sample1)
selectedItem == Album.sample1

selectedItem == U3<Artist, Album, Playlist>(Artist.sample0)
selectedItem == Artist.sample0

U3<Artist, Album, Playlist>(Album.sample0) == selectedItem
Album.sample0 == selectedItem

U3<Artist, Album, Playlist>(Album.sample1) == selectedItem
Album.sample1 == selectedItem

U3<Artist, Album, Playlist>(Artist.sample0) == selectedItem
Artist.sample0 == selectedItem

// MARK: Hashable
var listenCount: [U2<Album, Playlist>: Int] = [:]
listenCount[U2(Album.sample0)] = 12
listenCount[U2(Playlist.sample0)] = 6

// MARK: CaseIterable
enum NetworkError: Error, CaseIterable {
   case noInternetConnection
   case authenticationFailed
   case decodingFailed
}
 
enum StorageError: Error, CaseIterable {
   case diskFull
   case fileAlreadyExists
}
 
for networkError in NetworkError.allCases {
    U2<NetworkError, StorageError>.allCases.contains(U2(networkError))
}

for storageError in StorageError.allCases {
    U2<NetworkError, StorageError>.allCases.contains(U2(storageError))
}

// MARK: Sendable
struct Container<Value: Sendable> {
    let value: Value
}

let container = Container(
    value: U3<Artist, Album, Playlist>(Artist.sample0)
)

// MARK: CustomStringConvertible
selectedItem.set(Playlist.sample0)
selectedItem.description

selectedItem.set(Artist.sample1)
selectedItem.description

// MARK: CustomDebugStringConvertible
selectedItem.set(Album.sample2)
selectedItem.debugDescription

selectedItem.set(Artist.sample1)
selectedItem.debugDescription

// MARK: Error
let lastError: U2<NetworkError, StorageError> = .init(.diskFull)
lastError.innerError
lastError.localizedDescription

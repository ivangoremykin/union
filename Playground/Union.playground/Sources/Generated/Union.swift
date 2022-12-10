import Foundation

// MARK: - Union2

public enum Union2<Item0, Item1> {
    case item0(Item0)
    case item1(Item1)
}

public typealias U2 = Union2

// MARK: Initializers
extension Union2 {
    public init(_ item0: Item0) {
        self = .item0(item0)
    }
    
    public init(_ item1: Item1) {
        self = .item1(item1)
    }
}

// MARK: Getters
extension Union2 {
    public var item0: Item0? {
        if case let .item0(item0) = self {
            return item0
        }
        
        return nil
    }
    
    public var item1: Item1? {
        if case let .item1(item1) = self {
            return item1
        }
        
        return nil
    }
}

// MARK: Setters
extension Union2 {
    public mutating func set(_ item0: Item0) {
        self = .init(item0)
    }
    
    public mutating func set(_ item1: Item1) {
        self = .init(item1)
    }
}

// MARK: Map
extension Union2 {
    public func map0<Transformed0>(_ transform: (Item0) throws -> Transformed0) rethrows -> Union2<Transformed0, Item1> {
        switch self {
        case .item0(let item0):
            return .init(try transform(item0))
        
        case .item1(let item1):
            return .init(item1)
        }
    }
    
    public func map1<Transformed1>(_ transform: (Item1) throws -> Transformed1) rethrows -> Union2<Item0, Transformed1> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(try transform(item1))
        }
    }
}

// MARK: Flat Map
extension Union2 {
    public func flatMap0<Transformed0>(_ transform: (Item0) throws -> Union2<Transformed0, Item1>) rethrows -> Union2<Transformed0, Item1> {
        switch self {
        case .item0(let item0):
            return try transform(item0)
        
        case .item1(let item1):
            return .init(item1)
        }
    }
    
    public func flatMap1<Transformed1>(_ transform: (Item1) throws -> Union2<Item0, Transformed1>) rethrows -> Union2<Item0, Transformed1> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return try transform(item1)
        }
    }
}

// MARK: Compact Map
extension Sequence where Element: Union2Protocol {
    public func compactMap0() -> [Element.Item0] {
        return compactMap { $0.item0 }
    }
    
    public func compactMap1() -> [Element.Item1] {
        return compactMap { $0.item1 }
    }
}

public protocol Union2Protocol {
    associatedtype Item0
    associatedtype Item1
    
    var item0: Item0? { get }
    var item1: Item1? { get }
}

extension Union2: Union2Protocol {
}

// MARK: Equatable
extension Union2: Equatable where Item0: Equatable, Item1: Equatable {
    public static func ==(_ union: Self, _ item0: Item0) -> Bool {
        return union.item0 == item0
    }
    
    public static func ==(_ union: Self, _ item1: Item1) -> Bool {
        return union.item1 == item1
    }
    
    public static func ==(_ item0: Item0, _ union: Self) -> Bool {
        return union.item0 == item0
    }
    
    public static func ==(_ item1: Item1, _ union: Self) -> Bool {
        return union.item1 == item1
    }
}

// MARK: Hashable
extension Union2: Hashable where Item0: Hashable, Item1: Hashable {
}

// MARK: Encodable
extension Union2: Encodable where Item0: Encodable & UnionIdentifiable, Item1: Encodable & UnionIdentifiable {
    public func encode(to encoder: Encoder) throws {
        var unionContainer = encoder.container(keyedBy: UnionCodingKey.self)
        
        try unionContainer.encode(unionTypeID, forKey: .unionTypeID)
        try unionContainer.encode(innerEncodable, forKey: .wrappedValue)
    }
    
    private var unionTypeID: UnionTypeID {
        switch self {
        case .item0:
            return Item0.unionTypeID
        
        case .item1:
            return Item1.unionTypeID
        }
    }
    
    private var innerEncodable: Encodable {
        switch self {
        case .item0(let item0):
            return item0
        
        case .item1(let item1):
            return item1
        }
    }
}

// MARK: Decodable
extension Union2: Decodable where Item0: Decodable & UnionIdentifiable, Item1: Decodable & UnionIdentifiable {
    public init(from decoder: Decoder) throws {
        let unionContainer = try decoder.container(keyedBy: UnionCodingKey.self)
        
        let unionTypeID = try unionContainer.decode(UnionTypeID.self, forKey: .unionTypeID)
        
        switch unionTypeID {
        case Item0.unionTypeID:
            self = .item0(try unionContainer.decode(Item0.self, forKey: .wrappedValue))
        
        case Item1.unionTypeID:
            self = .item1(try unionContainer.decode(Item1.self, forKey: .wrappedValue))
        
        default:
            throw UnionDecodingError.unknownUnionTypeID(unionTypeID)
        }
    }
}

// MARK: CaseIterable
extension Union2: CaseIterable where Item0: CaseIterable, Item1: CaseIterable {
    public static var allCases: [Self] {
        return Item0.allCases.map { .init($0) } + Item1.allCases.map { .init($0) }
    }
}

// MARK: Sendable
extension Union2: Sendable where Item0: Sendable, Item1: Sendable {
}

// MARK: CustomStringConvertible
extension Union2: CustomStringConvertible {
    public var description: String {
        switch self {
        case .item0(let item0):
            return "Union2.item0(\(item0))"
        
        case .item1(let item1):
            return "Union2.item1(\(item1))"
        }
    }
}

// MARK: CustomDebugStringConvertible
extension Union2: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .item0(let item0):
            return "Union2.item0(\(item0))"
        
        case .item1(let item1):
            return "Union2.item1(\(item1))"
        }
    }
}

// MARK: Error
extension Union2: Error where Item0: Error, Item1: Error {
    public var innerError: Error {
        switch self {
        case .item0(let item0):
            return item0
        
        case .item1(let item1):
            return item1
        }
    }
    
    public var localizedDescription: String {
        return innerError.localizedDescription
    }
}

// MARK: - Union3

public enum Union3<Item0, Item1, Item2> {
    case item0(Item0)
    case item1(Item1)
    case item2(Item2)
}

public typealias U3 = Union3

// MARK: Initializers
extension Union3 {
    public init(_ item0: Item0) {
        self = .item0(item0)
    }
    
    public init(_ item1: Item1) {
        self = .item1(item1)
    }
    
    public init(_ item2: Item2) {
        self = .item2(item2)
    }
}

// MARK: Getters
extension Union3 {
    public var item0: Item0? {
        if case let .item0(item0) = self {
            return item0
        }
        
        return nil
    }
    
    public var item1: Item1? {
        if case let .item1(item1) = self {
            return item1
        }
        
        return nil
    }
    
    public var item2: Item2? {
        if case let .item2(item2) = self {
            return item2
        }
        
        return nil
    }
}

// MARK: Setters
extension Union3 {
    public mutating func set(_ item0: Item0) {
        self = .init(item0)
    }
    
    public mutating func set(_ item1: Item1) {
        self = .init(item1)
    }
    
    public mutating func set(_ item2: Item2) {
        self = .init(item2)
    }
}

// MARK: Map
extension Union3 {
    public func map0<Transformed0>(_ transform: (Item0) throws -> Transformed0) rethrows -> Union3<Transformed0, Item1, Item2> {
        switch self {
        case .item0(let item0):
            return .init(try transform(item0))
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        }
    }
    
    public func map1<Transformed1>(_ transform: (Item1) throws -> Transformed1) rethrows -> Union3<Item0, Transformed1, Item2> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(try transform(item1))
        
        case .item2(let item2):
            return .init(item2)
        }
    }
    
    public func map2<Transformed2>(_ transform: (Item2) throws -> Transformed2) rethrows -> Union3<Item0, Item1, Transformed2> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(try transform(item2))
        }
    }
}

// MARK: Flat Map
extension Union3 {
    public func flatMap0<Transformed0>(_ transform: (Item0) throws -> Union3<Transformed0, Item1, Item2>) rethrows -> Union3<Transformed0, Item1, Item2> {
        switch self {
        case .item0(let item0):
            return try transform(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        }
    }
    
    public func flatMap1<Transformed1>(_ transform: (Item1) throws -> Union3<Item0, Transformed1, Item2>) rethrows -> Union3<Item0, Transformed1, Item2> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return try transform(item1)
        
        case .item2(let item2):
            return .init(item2)
        }
    }
    
    public func flatMap2<Transformed2>(_ transform: (Item2) throws -> Union3<Item0, Item1, Transformed2>) rethrows -> Union3<Item0, Item1, Transformed2> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return try transform(item2)
        }
    }
}

// MARK: Compact Map
extension Sequence where Element: Union3Protocol {
    public func compactMap0() -> [Element.Item0] {
        return compactMap { $0.item0 }
    }
    
    public func compactMap1() -> [Element.Item1] {
        return compactMap { $0.item1 }
    }
    
    public func compactMap2() -> [Element.Item2] {
        return compactMap { $0.item2 }
    }
}

public protocol Union3Protocol {
    associatedtype Item0
    associatedtype Item1
    associatedtype Item2
    
    var item0: Item0? { get }
    var item1: Item1? { get }
    var item2: Item2? { get }
}

extension Union3: Union3Protocol {
}

// MARK: Equatable
extension Union3: Equatable where Item0: Equatable, Item1: Equatable, Item2: Equatable {
    public static func ==(_ union: Self, _ item0: Item0) -> Bool {
        return union.item0 == item0
    }
    
    public static func ==(_ union: Self, _ item1: Item1) -> Bool {
        return union.item1 == item1
    }
    
    public static func ==(_ union: Self, _ item2: Item2) -> Bool {
        return union.item2 == item2
    }
    
    public static func ==(_ item0: Item0, _ union: Self) -> Bool {
        return union.item0 == item0
    }
    
    public static func ==(_ item1: Item1, _ union: Self) -> Bool {
        return union.item1 == item1
    }
    
    public static func ==(_ item2: Item2, _ union: Self) -> Bool {
        return union.item2 == item2
    }
}

// MARK: Hashable
extension Union3: Hashable where Item0: Hashable, Item1: Hashable, Item2: Hashable {
}

// MARK: Encodable
extension Union3: Encodable where Item0: Encodable & UnionIdentifiable, Item1: Encodable & UnionIdentifiable, Item2: Encodable & UnionIdentifiable {
    public func encode(to encoder: Encoder) throws {
        var unionContainer = encoder.container(keyedBy: UnionCodingKey.self)
        
        try unionContainer.encode(unionTypeID, forKey: .unionTypeID)
        try unionContainer.encode(innerEncodable, forKey: .wrappedValue)
    }
    
    private var unionTypeID: UnionTypeID {
        switch self {
        case .item0:
            return Item0.unionTypeID
        
        case .item1:
            return Item1.unionTypeID
        
        case .item2:
            return Item2.unionTypeID
        }
    }
    
    private var innerEncodable: Encodable {
        switch self {
        case .item0(let item0):
            return item0
        
        case .item1(let item1):
            return item1
        
        case .item2(let item2):
            return item2
        }
    }
}

// MARK: Decodable
extension Union3: Decodable where Item0: Decodable & UnionIdentifiable, Item1: Decodable & UnionIdentifiable, Item2: Decodable & UnionIdentifiable {
    public init(from decoder: Decoder) throws {
        let unionContainer = try decoder.container(keyedBy: UnionCodingKey.self)
        
        let unionTypeID = try unionContainer.decode(UnionTypeID.self, forKey: .unionTypeID)
        
        switch unionTypeID {
        case Item0.unionTypeID:
            self = .item0(try unionContainer.decode(Item0.self, forKey: .wrappedValue))
        
        case Item1.unionTypeID:
            self = .item1(try unionContainer.decode(Item1.self, forKey: .wrappedValue))
        
        case Item2.unionTypeID:
            self = .item2(try unionContainer.decode(Item2.self, forKey: .wrappedValue))
        
        default:
            throw UnionDecodingError.unknownUnionTypeID(unionTypeID)
        }
    }
}

// MARK: CaseIterable
extension Union3: CaseIterable where Item0: CaseIterable, Item1: CaseIterable, Item2: CaseIterable {
    public static var allCases: [Self] {
        return Item0.allCases.map { .init($0) } + Item1.allCases.map { .init($0) } + Item2.allCases.map { .init($0) }
    }
}

// MARK: Sendable
extension Union3: Sendable where Item0: Sendable, Item1: Sendable, Item2: Sendable {
}

// MARK: CustomStringConvertible
extension Union3: CustomStringConvertible {
    public var description: String {
        switch self {
        case .item0(let item0):
            return "Union3.item0(\(item0))"
        
        case .item1(let item1):
            return "Union3.item1(\(item1))"
        
        case .item2(let item2):
            return "Union3.item2(\(item2))"
        }
    }
}

// MARK: CustomDebugStringConvertible
extension Union3: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .item0(let item0):
            return "Union3.item0(\(item0))"
        
        case .item1(let item1):
            return "Union3.item1(\(item1))"
        
        case .item2(let item2):
            return "Union3.item2(\(item2))"
        }
    }
}

// MARK: Error
extension Union3: Error where Item0: Error, Item1: Error, Item2: Error {
    public var innerError: Error {
        switch self {
        case .item0(let item0):
            return item0
        
        case .item1(let item1):
            return item1
        
        case .item2(let item2):
            return item2
        }
    }
    
    public var localizedDescription: String {
        return innerError.localizedDescription
    }
}

// MARK: - Union4

public enum Union4<Item0, Item1, Item2, Item3> {
    case item0(Item0)
    case item1(Item1)
    case item2(Item2)
    case item3(Item3)
}

public typealias U4 = Union4

// MARK: Initializers
extension Union4 {
    public init(_ item0: Item0) {
        self = .item0(item0)
    }
    
    public init(_ item1: Item1) {
        self = .item1(item1)
    }
    
    public init(_ item2: Item2) {
        self = .item2(item2)
    }
    
    public init(_ item3: Item3) {
        self = .item3(item3)
    }
}

// MARK: Getters
extension Union4 {
    public var item0: Item0? {
        if case let .item0(item0) = self {
            return item0
        }
        
        return nil
    }
    
    public var item1: Item1? {
        if case let .item1(item1) = self {
            return item1
        }
        
        return nil
    }
    
    public var item2: Item2? {
        if case let .item2(item2) = self {
            return item2
        }
        
        return nil
    }
    
    public var item3: Item3? {
        if case let .item3(item3) = self {
            return item3
        }
        
        return nil
    }
}

// MARK: Setters
extension Union4 {
    public mutating func set(_ item0: Item0) {
        self = .init(item0)
    }
    
    public mutating func set(_ item1: Item1) {
        self = .init(item1)
    }
    
    public mutating func set(_ item2: Item2) {
        self = .init(item2)
    }
    
    public mutating func set(_ item3: Item3) {
        self = .init(item3)
    }
}

// MARK: Map
extension Union4 {
    public func map0<Transformed0>(_ transform: (Item0) throws -> Transformed0) rethrows -> Union4<Transformed0, Item1, Item2, Item3> {
        switch self {
        case .item0(let item0):
            return .init(try transform(item0))
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        }
    }
    
    public func map1<Transformed1>(_ transform: (Item1) throws -> Transformed1) rethrows -> Union4<Item0, Transformed1, Item2, Item3> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(try transform(item1))
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        }
    }
    
    public func map2<Transformed2>(_ transform: (Item2) throws -> Transformed2) rethrows -> Union4<Item0, Item1, Transformed2, Item3> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(try transform(item2))
        
        case .item3(let item3):
            return .init(item3)
        }
    }
    
    public func map3<Transformed3>(_ transform: (Item3) throws -> Transformed3) rethrows -> Union4<Item0, Item1, Item2, Transformed3> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(try transform(item3))
        }
    }
}

// MARK: Flat Map
extension Union4 {
    public func flatMap0<Transformed0>(_ transform: (Item0) throws -> Union4<Transformed0, Item1, Item2, Item3>) rethrows -> Union4<Transformed0, Item1, Item2, Item3> {
        switch self {
        case .item0(let item0):
            return try transform(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        }
    }
    
    public func flatMap1<Transformed1>(_ transform: (Item1) throws -> Union4<Item0, Transformed1, Item2, Item3>) rethrows -> Union4<Item0, Transformed1, Item2, Item3> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return try transform(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        }
    }
    
    public func flatMap2<Transformed2>(_ transform: (Item2) throws -> Union4<Item0, Item1, Transformed2, Item3>) rethrows -> Union4<Item0, Item1, Transformed2, Item3> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return try transform(item2)
        
        case .item3(let item3):
            return .init(item3)
        }
    }
    
    public func flatMap3<Transformed3>(_ transform: (Item3) throws -> Union4<Item0, Item1, Item2, Transformed3>) rethrows -> Union4<Item0, Item1, Item2, Transformed3> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return try transform(item3)
        }
    }
}

// MARK: Compact Map
extension Sequence where Element: Union4Protocol {
    public func compactMap0() -> [Element.Item0] {
        return compactMap { $0.item0 }
    }
    
    public func compactMap1() -> [Element.Item1] {
        return compactMap { $0.item1 }
    }
    
    public func compactMap2() -> [Element.Item2] {
        return compactMap { $0.item2 }
    }
    
    public func compactMap3() -> [Element.Item3] {
        return compactMap { $0.item3 }
    }
}

public protocol Union4Protocol {
    associatedtype Item0
    associatedtype Item1
    associatedtype Item2
    associatedtype Item3
    
    var item0: Item0? { get }
    var item1: Item1? { get }
    var item2: Item2? { get }
    var item3: Item3? { get }
}

extension Union4: Union4Protocol {
}

// MARK: Equatable
extension Union4: Equatable where Item0: Equatable, Item1: Equatable, Item2: Equatable, Item3: Equatable {
    public static func ==(_ union: Self, _ item0: Item0) -> Bool {
        return union.item0 == item0
    }
    
    public static func ==(_ union: Self, _ item1: Item1) -> Bool {
        return union.item1 == item1
    }
    
    public static func ==(_ union: Self, _ item2: Item2) -> Bool {
        return union.item2 == item2
    }
    
    public static func ==(_ union: Self, _ item3: Item3) -> Bool {
        return union.item3 == item3
    }
    
    public static func ==(_ item0: Item0, _ union: Self) -> Bool {
        return union.item0 == item0
    }
    
    public static func ==(_ item1: Item1, _ union: Self) -> Bool {
        return union.item1 == item1
    }
    
    public static func ==(_ item2: Item2, _ union: Self) -> Bool {
        return union.item2 == item2
    }
    
    public static func ==(_ item3: Item3, _ union: Self) -> Bool {
        return union.item3 == item3
    }
}

// MARK: Hashable
extension Union4: Hashable where Item0: Hashable, Item1: Hashable, Item2: Hashable, Item3: Hashable {
}

// MARK: Encodable
extension Union4: Encodable where Item0: Encodable & UnionIdentifiable, Item1: Encodable & UnionIdentifiable, Item2: Encodable & UnionIdentifiable, Item3: Encodable & UnionIdentifiable {
    public func encode(to encoder: Encoder) throws {
        var unionContainer = encoder.container(keyedBy: UnionCodingKey.self)
        
        try unionContainer.encode(unionTypeID, forKey: .unionTypeID)
        try unionContainer.encode(innerEncodable, forKey: .wrappedValue)
    }
    
    private var unionTypeID: UnionTypeID {
        switch self {
        case .item0:
            return Item0.unionTypeID
        
        case .item1:
            return Item1.unionTypeID
        
        case .item2:
            return Item2.unionTypeID
        
        case .item3:
            return Item3.unionTypeID
        }
    }
    
    private var innerEncodable: Encodable {
        switch self {
        case .item0(let item0):
            return item0
        
        case .item1(let item1):
            return item1
        
        case .item2(let item2):
            return item2
        
        case .item3(let item3):
            return item3
        }
    }
}

// MARK: Decodable
extension Union4: Decodable where Item0: Decodable & UnionIdentifiable, Item1: Decodable & UnionIdentifiable, Item2: Decodable & UnionIdentifiable, Item3: Decodable & UnionIdentifiable {
    public init(from decoder: Decoder) throws {
        let unionContainer = try decoder.container(keyedBy: UnionCodingKey.self)
        
        let unionTypeID = try unionContainer.decode(UnionTypeID.self, forKey: .unionTypeID)
        
        switch unionTypeID {
        case Item0.unionTypeID:
            self = .item0(try unionContainer.decode(Item0.self, forKey: .wrappedValue))
        
        case Item1.unionTypeID:
            self = .item1(try unionContainer.decode(Item1.self, forKey: .wrappedValue))
        
        case Item2.unionTypeID:
            self = .item2(try unionContainer.decode(Item2.self, forKey: .wrappedValue))
        
        case Item3.unionTypeID:
            self = .item3(try unionContainer.decode(Item3.self, forKey: .wrappedValue))
        
        default:
            throw UnionDecodingError.unknownUnionTypeID(unionTypeID)
        }
    }
}

// MARK: CaseIterable
extension Union4: CaseIterable where Item0: CaseIterable, Item1: CaseIterable, Item2: CaseIterable, Item3: CaseIterable {
    public static var allCases: [Self] {
        return Item0.allCases.map { .init($0) } + Item1.allCases.map { .init($0) } + Item2.allCases.map { .init($0) } + Item3.allCases.map { .init($0) }
    }
}

// MARK: Sendable
extension Union4: Sendable where Item0: Sendable, Item1: Sendable, Item2: Sendable, Item3: Sendable {
}

// MARK: CustomStringConvertible
extension Union4: CustomStringConvertible {
    public var description: String {
        switch self {
        case .item0(let item0):
            return "Union4.item0(\(item0))"
        
        case .item1(let item1):
            return "Union4.item1(\(item1))"
        
        case .item2(let item2):
            return "Union4.item2(\(item2))"
        
        case .item3(let item3):
            return "Union4.item3(\(item3))"
        }
    }
}

// MARK: CustomDebugStringConvertible
extension Union4: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .item0(let item0):
            return "Union4.item0(\(item0))"
        
        case .item1(let item1):
            return "Union4.item1(\(item1))"
        
        case .item2(let item2):
            return "Union4.item2(\(item2))"
        
        case .item3(let item3):
            return "Union4.item3(\(item3))"
        }
    }
}

// MARK: Error
extension Union4: Error where Item0: Error, Item1: Error, Item2: Error, Item3: Error {
    public var innerError: Error {
        switch self {
        case .item0(let item0):
            return item0
        
        case .item1(let item1):
            return item1
        
        case .item2(let item2):
            return item2
        
        case .item3(let item3):
            return item3
        }
    }
    
    public var localizedDescription: String {
        return innerError.localizedDescription
    }
}

// MARK: - Union5

public enum Union5<Item0, Item1, Item2, Item3, Item4> {
    case item0(Item0)
    case item1(Item1)
    case item2(Item2)
    case item3(Item3)
    case item4(Item4)
}

public typealias U5 = Union5

// MARK: Initializers
extension Union5 {
    public init(_ item0: Item0) {
        self = .item0(item0)
    }
    
    public init(_ item1: Item1) {
        self = .item1(item1)
    }
    
    public init(_ item2: Item2) {
        self = .item2(item2)
    }
    
    public init(_ item3: Item3) {
        self = .item3(item3)
    }
    
    public init(_ item4: Item4) {
        self = .item4(item4)
    }
}

// MARK: Getters
extension Union5 {
    public var item0: Item0? {
        if case let .item0(item0) = self {
            return item0
        }
        
        return nil
    }
    
    public var item1: Item1? {
        if case let .item1(item1) = self {
            return item1
        }
        
        return nil
    }
    
    public var item2: Item2? {
        if case let .item2(item2) = self {
            return item2
        }
        
        return nil
    }
    
    public var item3: Item3? {
        if case let .item3(item3) = self {
            return item3
        }
        
        return nil
    }
    
    public var item4: Item4? {
        if case let .item4(item4) = self {
            return item4
        }
        
        return nil
    }
}

// MARK: Setters
extension Union5 {
    public mutating func set(_ item0: Item0) {
        self = .init(item0)
    }
    
    public mutating func set(_ item1: Item1) {
        self = .init(item1)
    }
    
    public mutating func set(_ item2: Item2) {
        self = .init(item2)
    }
    
    public mutating func set(_ item3: Item3) {
        self = .init(item3)
    }
    
    public mutating func set(_ item4: Item4) {
        self = .init(item4)
    }
}

// MARK: Map
extension Union5 {
    public func map0<Transformed0>(_ transform: (Item0) throws -> Transformed0) rethrows -> Union5<Transformed0, Item1, Item2, Item3, Item4> {
        switch self {
        case .item0(let item0):
            return .init(try transform(item0))
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        }
    }
    
    public func map1<Transformed1>(_ transform: (Item1) throws -> Transformed1) rethrows -> Union5<Item0, Transformed1, Item2, Item3, Item4> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(try transform(item1))
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        }
    }
    
    public func map2<Transformed2>(_ transform: (Item2) throws -> Transformed2) rethrows -> Union5<Item0, Item1, Transformed2, Item3, Item4> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(try transform(item2))
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        }
    }
    
    public func map3<Transformed3>(_ transform: (Item3) throws -> Transformed3) rethrows -> Union5<Item0, Item1, Item2, Transformed3, Item4> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(try transform(item3))
        
        case .item4(let item4):
            return .init(item4)
        }
    }
    
    public func map4<Transformed4>(_ transform: (Item4) throws -> Transformed4) rethrows -> Union5<Item0, Item1, Item2, Item3, Transformed4> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(try transform(item4))
        }
    }
}

// MARK: Flat Map
extension Union5 {
    public func flatMap0<Transformed0>(_ transform: (Item0) throws -> Union5<Transformed0, Item1, Item2, Item3, Item4>) rethrows -> Union5<Transformed0, Item1, Item2, Item3, Item4> {
        switch self {
        case .item0(let item0):
            return try transform(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        }
    }
    
    public func flatMap1<Transformed1>(_ transform: (Item1) throws -> Union5<Item0, Transformed1, Item2, Item3, Item4>) rethrows -> Union5<Item0, Transformed1, Item2, Item3, Item4> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return try transform(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        }
    }
    
    public func flatMap2<Transformed2>(_ transform: (Item2) throws -> Union5<Item0, Item1, Transformed2, Item3, Item4>) rethrows -> Union5<Item0, Item1, Transformed2, Item3, Item4> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return try transform(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        }
    }
    
    public func flatMap3<Transformed3>(_ transform: (Item3) throws -> Union5<Item0, Item1, Item2, Transformed3, Item4>) rethrows -> Union5<Item0, Item1, Item2, Transformed3, Item4> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return try transform(item3)
        
        case .item4(let item4):
            return .init(item4)
        }
    }
    
    public func flatMap4<Transformed4>(_ transform: (Item4) throws -> Union5<Item0, Item1, Item2, Item3, Transformed4>) rethrows -> Union5<Item0, Item1, Item2, Item3, Transformed4> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return try transform(item4)
        }
    }
}

// MARK: Compact Map
extension Sequence where Element: Union5Protocol {
    public func compactMap0() -> [Element.Item0] {
        return compactMap { $0.item0 }
    }
    
    public func compactMap1() -> [Element.Item1] {
        return compactMap { $0.item1 }
    }
    
    public func compactMap2() -> [Element.Item2] {
        return compactMap { $0.item2 }
    }
    
    public func compactMap3() -> [Element.Item3] {
        return compactMap { $0.item3 }
    }
    
    public func compactMap4() -> [Element.Item4] {
        return compactMap { $0.item4 }
    }
}

public protocol Union5Protocol {
    associatedtype Item0
    associatedtype Item1
    associatedtype Item2
    associatedtype Item3
    associatedtype Item4
    
    var item0: Item0? { get }
    var item1: Item1? { get }
    var item2: Item2? { get }
    var item3: Item3? { get }
    var item4: Item4? { get }
}

extension Union5: Union5Protocol {
}

// MARK: Equatable
extension Union5: Equatable where Item0: Equatable, Item1: Equatable, Item2: Equatable, Item3: Equatable, Item4: Equatable {
    public static func ==(_ union: Self, _ item0: Item0) -> Bool {
        return union.item0 == item0
    }
    
    public static func ==(_ union: Self, _ item1: Item1) -> Bool {
        return union.item1 == item1
    }
    
    public static func ==(_ union: Self, _ item2: Item2) -> Bool {
        return union.item2 == item2
    }
    
    public static func ==(_ union: Self, _ item3: Item3) -> Bool {
        return union.item3 == item3
    }
    
    public static func ==(_ union: Self, _ item4: Item4) -> Bool {
        return union.item4 == item4
    }
    
    public static func ==(_ item0: Item0, _ union: Self) -> Bool {
        return union.item0 == item0
    }
    
    public static func ==(_ item1: Item1, _ union: Self) -> Bool {
        return union.item1 == item1
    }
    
    public static func ==(_ item2: Item2, _ union: Self) -> Bool {
        return union.item2 == item2
    }
    
    public static func ==(_ item3: Item3, _ union: Self) -> Bool {
        return union.item3 == item3
    }
    
    public static func ==(_ item4: Item4, _ union: Self) -> Bool {
        return union.item4 == item4
    }
}

// MARK: Hashable
extension Union5: Hashable where Item0: Hashable, Item1: Hashable, Item2: Hashable, Item3: Hashable, Item4: Hashable {
}

// MARK: Encodable
extension Union5: Encodable where Item0: Encodable & UnionIdentifiable, Item1: Encodable & UnionIdentifiable, Item2: Encodable & UnionIdentifiable, Item3: Encodable & UnionIdentifiable, Item4: Encodable & UnionIdentifiable {
    public func encode(to encoder: Encoder) throws {
        var unionContainer = encoder.container(keyedBy: UnionCodingKey.self)
        
        try unionContainer.encode(unionTypeID, forKey: .unionTypeID)
        try unionContainer.encode(innerEncodable, forKey: .wrappedValue)
    }
    
    private var unionTypeID: UnionTypeID {
        switch self {
        case .item0:
            return Item0.unionTypeID
        
        case .item1:
            return Item1.unionTypeID
        
        case .item2:
            return Item2.unionTypeID
        
        case .item3:
            return Item3.unionTypeID
        
        case .item4:
            return Item4.unionTypeID
        }
    }
    
    private var innerEncodable: Encodable {
        switch self {
        case .item0(let item0):
            return item0
        
        case .item1(let item1):
            return item1
        
        case .item2(let item2):
            return item2
        
        case .item3(let item3):
            return item3
        
        case .item4(let item4):
            return item4
        }
    }
}

// MARK: Decodable
extension Union5: Decodable where Item0: Decodable & UnionIdentifiable, Item1: Decodable & UnionIdentifiable, Item2: Decodable & UnionIdentifiable, Item3: Decodable & UnionIdentifiable, Item4: Decodable & UnionIdentifiable {
    public init(from decoder: Decoder) throws {
        let unionContainer = try decoder.container(keyedBy: UnionCodingKey.self)
        
        let unionTypeID = try unionContainer.decode(UnionTypeID.self, forKey: .unionTypeID)
        
        switch unionTypeID {
        case Item0.unionTypeID:
            self = .item0(try unionContainer.decode(Item0.self, forKey: .wrappedValue))
        
        case Item1.unionTypeID:
            self = .item1(try unionContainer.decode(Item1.self, forKey: .wrappedValue))
        
        case Item2.unionTypeID:
            self = .item2(try unionContainer.decode(Item2.self, forKey: .wrappedValue))
        
        case Item3.unionTypeID:
            self = .item3(try unionContainer.decode(Item3.self, forKey: .wrappedValue))
        
        case Item4.unionTypeID:
            self = .item4(try unionContainer.decode(Item4.self, forKey: .wrappedValue))
        
        default:
            throw UnionDecodingError.unknownUnionTypeID(unionTypeID)
        }
    }
}

// MARK: CaseIterable
extension Union5: CaseIterable where Item0: CaseIterable, Item1: CaseIterable, Item2: CaseIterable, Item3: CaseIterable, Item4: CaseIterable {
    public static var allCases: [Self] {
        return Item0.allCases.map { .init($0) } + Item1.allCases.map { .init($0) } + Item2.allCases.map { .init($0) } + Item3.allCases.map { .init($0) } + Item4.allCases.map { .init($0) }
    }
}

// MARK: Sendable
extension Union5: Sendable where Item0: Sendable, Item1: Sendable, Item2: Sendable, Item3: Sendable, Item4: Sendable {
}

// MARK: CustomStringConvertible
extension Union5: CustomStringConvertible {
    public var description: String {
        switch self {
        case .item0(let item0):
            return "Union5.item0(\(item0))"
        
        case .item1(let item1):
            return "Union5.item1(\(item1))"
        
        case .item2(let item2):
            return "Union5.item2(\(item2))"
        
        case .item3(let item3):
            return "Union5.item3(\(item3))"
        
        case .item4(let item4):
            return "Union5.item4(\(item4))"
        }
    }
}

// MARK: CustomDebugStringConvertible
extension Union5: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .item0(let item0):
            return "Union5.item0(\(item0))"
        
        case .item1(let item1):
            return "Union5.item1(\(item1))"
        
        case .item2(let item2):
            return "Union5.item2(\(item2))"
        
        case .item3(let item3):
            return "Union5.item3(\(item3))"
        
        case .item4(let item4):
            return "Union5.item4(\(item4))"
        }
    }
}

// MARK: Error
extension Union5: Error where Item0: Error, Item1: Error, Item2: Error, Item3: Error, Item4: Error {
    public var innerError: Error {
        switch self {
        case .item0(let item0):
            return item0
        
        case .item1(let item1):
            return item1
        
        case .item2(let item2):
            return item2
        
        case .item3(let item3):
            return item3
        
        case .item4(let item4):
            return item4
        }
    }
    
    public var localizedDescription: String {
        return innerError.localizedDescription
    }
}

// MARK: - Union6

public enum Union6<Item0, Item1, Item2, Item3, Item4, Item5> {
    case item0(Item0)
    case item1(Item1)
    case item2(Item2)
    case item3(Item3)
    case item4(Item4)
    case item5(Item5)
}

public typealias U6 = Union6

// MARK: Initializers
extension Union6 {
    public init(_ item0: Item0) {
        self = .item0(item0)
    }
    
    public init(_ item1: Item1) {
        self = .item1(item1)
    }
    
    public init(_ item2: Item2) {
        self = .item2(item2)
    }
    
    public init(_ item3: Item3) {
        self = .item3(item3)
    }
    
    public init(_ item4: Item4) {
        self = .item4(item4)
    }
    
    public init(_ item5: Item5) {
        self = .item5(item5)
    }
}

// MARK: Getters
extension Union6 {
    public var item0: Item0? {
        if case let .item0(item0) = self {
            return item0
        }
        
        return nil
    }
    
    public var item1: Item1? {
        if case let .item1(item1) = self {
            return item1
        }
        
        return nil
    }
    
    public var item2: Item2? {
        if case let .item2(item2) = self {
            return item2
        }
        
        return nil
    }
    
    public var item3: Item3? {
        if case let .item3(item3) = self {
            return item3
        }
        
        return nil
    }
    
    public var item4: Item4? {
        if case let .item4(item4) = self {
            return item4
        }
        
        return nil
    }
    
    public var item5: Item5? {
        if case let .item5(item5) = self {
            return item5
        }
        
        return nil
    }
}

// MARK: Setters
extension Union6 {
    public mutating func set(_ item0: Item0) {
        self = .init(item0)
    }
    
    public mutating func set(_ item1: Item1) {
        self = .init(item1)
    }
    
    public mutating func set(_ item2: Item2) {
        self = .init(item2)
    }
    
    public mutating func set(_ item3: Item3) {
        self = .init(item3)
    }
    
    public mutating func set(_ item4: Item4) {
        self = .init(item4)
    }
    
    public mutating func set(_ item5: Item5) {
        self = .init(item5)
    }
}

// MARK: Map
extension Union6 {
    public func map0<Transformed0>(_ transform: (Item0) throws -> Transformed0) rethrows -> Union6<Transformed0, Item1, Item2, Item3, Item4, Item5> {
        switch self {
        case .item0(let item0):
            return .init(try transform(item0))
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        }
    }
    
    public func map1<Transformed1>(_ transform: (Item1) throws -> Transformed1) rethrows -> Union6<Item0, Transformed1, Item2, Item3, Item4, Item5> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(try transform(item1))
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        }
    }
    
    public func map2<Transformed2>(_ transform: (Item2) throws -> Transformed2) rethrows -> Union6<Item0, Item1, Transformed2, Item3, Item4, Item5> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(try transform(item2))
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        }
    }
    
    public func map3<Transformed3>(_ transform: (Item3) throws -> Transformed3) rethrows -> Union6<Item0, Item1, Item2, Transformed3, Item4, Item5> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(try transform(item3))
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        }
    }
    
    public func map4<Transformed4>(_ transform: (Item4) throws -> Transformed4) rethrows -> Union6<Item0, Item1, Item2, Item3, Transformed4, Item5> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(try transform(item4))
        
        case .item5(let item5):
            return .init(item5)
        }
    }
    
    public func map5<Transformed5>(_ transform: (Item5) throws -> Transformed5) rethrows -> Union6<Item0, Item1, Item2, Item3, Item4, Transformed5> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(try transform(item5))
        }
    }
}

// MARK: Flat Map
extension Union6 {
    public func flatMap0<Transformed0>(_ transform: (Item0) throws -> Union6<Transformed0, Item1, Item2, Item3, Item4, Item5>) rethrows -> Union6<Transformed0, Item1, Item2, Item3, Item4, Item5> {
        switch self {
        case .item0(let item0):
            return try transform(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        }
    }
    
    public func flatMap1<Transformed1>(_ transform: (Item1) throws -> Union6<Item0, Transformed1, Item2, Item3, Item4, Item5>) rethrows -> Union6<Item0, Transformed1, Item2, Item3, Item4, Item5> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return try transform(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        }
    }
    
    public func flatMap2<Transformed2>(_ transform: (Item2) throws -> Union6<Item0, Item1, Transformed2, Item3, Item4, Item5>) rethrows -> Union6<Item0, Item1, Transformed2, Item3, Item4, Item5> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return try transform(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        }
    }
    
    public func flatMap3<Transformed3>(_ transform: (Item3) throws -> Union6<Item0, Item1, Item2, Transformed3, Item4, Item5>) rethrows -> Union6<Item0, Item1, Item2, Transformed3, Item4, Item5> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return try transform(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        }
    }
    
    public func flatMap4<Transformed4>(_ transform: (Item4) throws -> Union6<Item0, Item1, Item2, Item3, Transformed4, Item5>) rethrows -> Union6<Item0, Item1, Item2, Item3, Transformed4, Item5> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return try transform(item4)
        
        case .item5(let item5):
            return .init(item5)
        }
    }
    
    public func flatMap5<Transformed5>(_ transform: (Item5) throws -> Union6<Item0, Item1, Item2, Item3, Item4, Transformed5>) rethrows -> Union6<Item0, Item1, Item2, Item3, Item4, Transformed5> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return try transform(item5)
        }
    }
}

// MARK: Compact Map
extension Sequence where Element: Union6Protocol {
    public func compactMap0() -> [Element.Item0] {
        return compactMap { $0.item0 }
    }
    
    public func compactMap1() -> [Element.Item1] {
        return compactMap { $0.item1 }
    }
    
    public func compactMap2() -> [Element.Item2] {
        return compactMap { $0.item2 }
    }
    
    public func compactMap3() -> [Element.Item3] {
        return compactMap { $0.item3 }
    }
    
    public func compactMap4() -> [Element.Item4] {
        return compactMap { $0.item4 }
    }
    
    public func compactMap5() -> [Element.Item5] {
        return compactMap { $0.item5 }
    }
}

public protocol Union6Protocol {
    associatedtype Item0
    associatedtype Item1
    associatedtype Item2
    associatedtype Item3
    associatedtype Item4
    associatedtype Item5
    
    var item0: Item0? { get }
    var item1: Item1? { get }
    var item2: Item2? { get }
    var item3: Item3? { get }
    var item4: Item4? { get }
    var item5: Item5? { get }
}

extension Union6: Union6Protocol {
}

// MARK: Equatable
extension Union6: Equatable where Item0: Equatable, Item1: Equatable, Item2: Equatable, Item3: Equatable, Item4: Equatable, Item5: Equatable {
    public static func ==(_ union: Self, _ item0: Item0) -> Bool {
        return union.item0 == item0
    }
    
    public static func ==(_ union: Self, _ item1: Item1) -> Bool {
        return union.item1 == item1
    }
    
    public static func ==(_ union: Self, _ item2: Item2) -> Bool {
        return union.item2 == item2
    }
    
    public static func ==(_ union: Self, _ item3: Item3) -> Bool {
        return union.item3 == item3
    }
    
    public static func ==(_ union: Self, _ item4: Item4) -> Bool {
        return union.item4 == item4
    }
    
    public static func ==(_ union: Self, _ item5: Item5) -> Bool {
        return union.item5 == item5
    }
    
    public static func ==(_ item0: Item0, _ union: Self) -> Bool {
        return union.item0 == item0
    }
    
    public static func ==(_ item1: Item1, _ union: Self) -> Bool {
        return union.item1 == item1
    }
    
    public static func ==(_ item2: Item2, _ union: Self) -> Bool {
        return union.item2 == item2
    }
    
    public static func ==(_ item3: Item3, _ union: Self) -> Bool {
        return union.item3 == item3
    }
    
    public static func ==(_ item4: Item4, _ union: Self) -> Bool {
        return union.item4 == item4
    }
    
    public static func ==(_ item5: Item5, _ union: Self) -> Bool {
        return union.item5 == item5
    }
}

// MARK: Hashable
extension Union6: Hashable where Item0: Hashable, Item1: Hashable, Item2: Hashable, Item3: Hashable, Item4: Hashable, Item5: Hashable {
}

// MARK: Encodable
extension Union6: Encodable where Item0: Encodable & UnionIdentifiable, Item1: Encodable & UnionIdentifiable, Item2: Encodable & UnionIdentifiable, Item3: Encodable & UnionIdentifiable, Item4: Encodable & UnionIdentifiable, Item5: Encodable & UnionIdentifiable {
    public func encode(to encoder: Encoder) throws {
        var unionContainer = encoder.container(keyedBy: UnionCodingKey.self)
        
        try unionContainer.encode(unionTypeID, forKey: .unionTypeID)
        try unionContainer.encode(innerEncodable, forKey: .wrappedValue)
    }
    
    private var unionTypeID: UnionTypeID {
        switch self {
        case .item0:
            return Item0.unionTypeID
        
        case .item1:
            return Item1.unionTypeID
        
        case .item2:
            return Item2.unionTypeID
        
        case .item3:
            return Item3.unionTypeID
        
        case .item4:
            return Item4.unionTypeID
        
        case .item5:
            return Item5.unionTypeID
        }
    }
    
    private var innerEncodable: Encodable {
        switch self {
        case .item0(let item0):
            return item0
        
        case .item1(let item1):
            return item1
        
        case .item2(let item2):
            return item2
        
        case .item3(let item3):
            return item3
        
        case .item4(let item4):
            return item4
        
        case .item5(let item5):
            return item5
        }
    }
}

// MARK: Decodable
extension Union6: Decodable where Item0: Decodable & UnionIdentifiable, Item1: Decodable & UnionIdentifiable, Item2: Decodable & UnionIdentifiable, Item3: Decodable & UnionIdentifiable, Item4: Decodable & UnionIdentifiable, Item5: Decodable & UnionIdentifiable {
    public init(from decoder: Decoder) throws {
        let unionContainer = try decoder.container(keyedBy: UnionCodingKey.self)
        
        let unionTypeID = try unionContainer.decode(UnionTypeID.self, forKey: .unionTypeID)
        
        switch unionTypeID {
        case Item0.unionTypeID:
            self = .item0(try unionContainer.decode(Item0.self, forKey: .wrappedValue))
        
        case Item1.unionTypeID:
            self = .item1(try unionContainer.decode(Item1.self, forKey: .wrappedValue))
        
        case Item2.unionTypeID:
            self = .item2(try unionContainer.decode(Item2.self, forKey: .wrappedValue))
        
        case Item3.unionTypeID:
            self = .item3(try unionContainer.decode(Item3.self, forKey: .wrappedValue))
        
        case Item4.unionTypeID:
            self = .item4(try unionContainer.decode(Item4.self, forKey: .wrappedValue))
        
        case Item5.unionTypeID:
            self = .item5(try unionContainer.decode(Item5.self, forKey: .wrappedValue))
        
        default:
            throw UnionDecodingError.unknownUnionTypeID(unionTypeID)
        }
    }
}

// MARK: CaseIterable
extension Union6: CaseIterable where Item0: CaseIterable, Item1: CaseIterable, Item2: CaseIterable, Item3: CaseIterable, Item4: CaseIterable, Item5: CaseIterable {
    public static var allCases: [Self] {
        return Item0.allCases.map { .init($0) } + Item1.allCases.map { .init($0) } + Item2.allCases.map { .init($0) } + Item3.allCases.map { .init($0) } + Item4.allCases.map { .init($0) } + Item5.allCases.map { .init($0) }
    }
}

// MARK: Sendable
extension Union6: Sendable where Item0: Sendable, Item1: Sendable, Item2: Sendable, Item3: Sendable, Item4: Sendable, Item5: Sendable {
}

// MARK: CustomStringConvertible
extension Union6: CustomStringConvertible {
    public var description: String {
        switch self {
        case .item0(let item0):
            return "Union6.item0(\(item0))"
        
        case .item1(let item1):
            return "Union6.item1(\(item1))"
        
        case .item2(let item2):
            return "Union6.item2(\(item2))"
        
        case .item3(let item3):
            return "Union6.item3(\(item3))"
        
        case .item4(let item4):
            return "Union6.item4(\(item4))"
        
        case .item5(let item5):
            return "Union6.item5(\(item5))"
        }
    }
}

// MARK: CustomDebugStringConvertible
extension Union6: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .item0(let item0):
            return "Union6.item0(\(item0))"
        
        case .item1(let item1):
            return "Union6.item1(\(item1))"
        
        case .item2(let item2):
            return "Union6.item2(\(item2))"
        
        case .item3(let item3):
            return "Union6.item3(\(item3))"
        
        case .item4(let item4):
            return "Union6.item4(\(item4))"
        
        case .item5(let item5):
            return "Union6.item5(\(item5))"
        }
    }
}

// MARK: Error
extension Union6: Error where Item0: Error, Item1: Error, Item2: Error, Item3: Error, Item4: Error, Item5: Error {
    public var innerError: Error {
        switch self {
        case .item0(let item0):
            return item0
        
        case .item1(let item1):
            return item1
        
        case .item2(let item2):
            return item2
        
        case .item3(let item3):
            return item3
        
        case .item4(let item4):
            return item4
        
        case .item5(let item5):
            return item5
        }
    }
    
    public var localizedDescription: String {
        return innerError.localizedDescription
    }
}

// MARK: - Union7

public enum Union7<Item0, Item1, Item2, Item3, Item4, Item5, Item6> {
    case item0(Item0)
    case item1(Item1)
    case item2(Item2)
    case item3(Item3)
    case item4(Item4)
    case item5(Item5)
    case item6(Item6)
}

public typealias U7 = Union7

// MARK: Initializers
extension Union7 {
    public init(_ item0: Item0) {
        self = .item0(item0)
    }
    
    public init(_ item1: Item1) {
        self = .item1(item1)
    }
    
    public init(_ item2: Item2) {
        self = .item2(item2)
    }
    
    public init(_ item3: Item3) {
        self = .item3(item3)
    }
    
    public init(_ item4: Item4) {
        self = .item4(item4)
    }
    
    public init(_ item5: Item5) {
        self = .item5(item5)
    }
    
    public init(_ item6: Item6) {
        self = .item6(item6)
    }
}

// MARK: Getters
extension Union7 {
    public var item0: Item0? {
        if case let .item0(item0) = self {
            return item0
        }
        
        return nil
    }
    
    public var item1: Item1? {
        if case let .item1(item1) = self {
            return item1
        }
        
        return nil
    }
    
    public var item2: Item2? {
        if case let .item2(item2) = self {
            return item2
        }
        
        return nil
    }
    
    public var item3: Item3? {
        if case let .item3(item3) = self {
            return item3
        }
        
        return nil
    }
    
    public var item4: Item4? {
        if case let .item4(item4) = self {
            return item4
        }
        
        return nil
    }
    
    public var item5: Item5? {
        if case let .item5(item5) = self {
            return item5
        }
        
        return nil
    }
    
    public var item6: Item6? {
        if case let .item6(item6) = self {
            return item6
        }
        
        return nil
    }
}

// MARK: Setters
extension Union7 {
    public mutating func set(_ item0: Item0) {
        self = .init(item0)
    }
    
    public mutating func set(_ item1: Item1) {
        self = .init(item1)
    }
    
    public mutating func set(_ item2: Item2) {
        self = .init(item2)
    }
    
    public mutating func set(_ item3: Item3) {
        self = .init(item3)
    }
    
    public mutating func set(_ item4: Item4) {
        self = .init(item4)
    }
    
    public mutating func set(_ item5: Item5) {
        self = .init(item5)
    }
    
    public mutating func set(_ item6: Item6) {
        self = .init(item6)
    }
}

// MARK: Map
extension Union7 {
    public func map0<Transformed0>(_ transform: (Item0) throws -> Transformed0) rethrows -> Union7<Transformed0, Item1, Item2, Item3, Item4, Item5, Item6> {
        switch self {
        case .item0(let item0):
            return .init(try transform(item0))
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        }
    }
    
    public func map1<Transformed1>(_ transform: (Item1) throws -> Transformed1) rethrows -> Union7<Item0, Transformed1, Item2, Item3, Item4, Item5, Item6> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(try transform(item1))
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        }
    }
    
    public func map2<Transformed2>(_ transform: (Item2) throws -> Transformed2) rethrows -> Union7<Item0, Item1, Transformed2, Item3, Item4, Item5, Item6> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(try transform(item2))
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        }
    }
    
    public func map3<Transformed3>(_ transform: (Item3) throws -> Transformed3) rethrows -> Union7<Item0, Item1, Item2, Transformed3, Item4, Item5, Item6> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(try transform(item3))
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        }
    }
    
    public func map4<Transformed4>(_ transform: (Item4) throws -> Transformed4) rethrows -> Union7<Item0, Item1, Item2, Item3, Transformed4, Item5, Item6> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(try transform(item4))
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        }
    }
    
    public func map5<Transformed5>(_ transform: (Item5) throws -> Transformed5) rethrows -> Union7<Item0, Item1, Item2, Item3, Item4, Transformed5, Item6> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(try transform(item5))
        
        case .item6(let item6):
            return .init(item6)
        }
    }
    
    public func map6<Transformed6>(_ transform: (Item6) throws -> Transformed6) rethrows -> Union7<Item0, Item1, Item2, Item3, Item4, Item5, Transformed6> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(try transform(item6))
        }
    }
}

// MARK: Flat Map
extension Union7 {
    public func flatMap0<Transformed0>(_ transform: (Item0) throws -> Union7<Transformed0, Item1, Item2, Item3, Item4, Item5, Item6>) rethrows -> Union7<Transformed0, Item1, Item2, Item3, Item4, Item5, Item6> {
        switch self {
        case .item0(let item0):
            return try transform(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        }
    }
    
    public func flatMap1<Transformed1>(_ transform: (Item1) throws -> Union7<Item0, Transformed1, Item2, Item3, Item4, Item5, Item6>) rethrows -> Union7<Item0, Transformed1, Item2, Item3, Item4, Item5, Item6> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return try transform(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        }
    }
    
    public func flatMap2<Transformed2>(_ transform: (Item2) throws -> Union7<Item0, Item1, Transformed2, Item3, Item4, Item5, Item6>) rethrows -> Union7<Item0, Item1, Transformed2, Item3, Item4, Item5, Item6> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return try transform(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        }
    }
    
    public func flatMap3<Transformed3>(_ transform: (Item3) throws -> Union7<Item0, Item1, Item2, Transformed3, Item4, Item5, Item6>) rethrows -> Union7<Item0, Item1, Item2, Transformed3, Item4, Item5, Item6> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return try transform(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        }
    }
    
    public func flatMap4<Transformed4>(_ transform: (Item4) throws -> Union7<Item0, Item1, Item2, Item3, Transformed4, Item5, Item6>) rethrows -> Union7<Item0, Item1, Item2, Item3, Transformed4, Item5, Item6> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return try transform(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        }
    }
    
    public func flatMap5<Transformed5>(_ transform: (Item5) throws -> Union7<Item0, Item1, Item2, Item3, Item4, Transformed5, Item6>) rethrows -> Union7<Item0, Item1, Item2, Item3, Item4, Transformed5, Item6> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return try transform(item5)
        
        case .item6(let item6):
            return .init(item6)
        }
    }
    
    public func flatMap6<Transformed6>(_ transform: (Item6) throws -> Union7<Item0, Item1, Item2, Item3, Item4, Item5, Transformed6>) rethrows -> Union7<Item0, Item1, Item2, Item3, Item4, Item5, Transformed6> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return try transform(item6)
        }
    }
}

// MARK: Compact Map
extension Sequence where Element: Union7Protocol {
    public func compactMap0() -> [Element.Item0] {
        return compactMap { $0.item0 }
    }
    
    public func compactMap1() -> [Element.Item1] {
        return compactMap { $0.item1 }
    }
    
    public func compactMap2() -> [Element.Item2] {
        return compactMap { $0.item2 }
    }
    
    public func compactMap3() -> [Element.Item3] {
        return compactMap { $0.item3 }
    }
    
    public func compactMap4() -> [Element.Item4] {
        return compactMap { $0.item4 }
    }
    
    public func compactMap5() -> [Element.Item5] {
        return compactMap { $0.item5 }
    }
    
    public func compactMap6() -> [Element.Item6] {
        return compactMap { $0.item6 }
    }
}

public protocol Union7Protocol {
    associatedtype Item0
    associatedtype Item1
    associatedtype Item2
    associatedtype Item3
    associatedtype Item4
    associatedtype Item5
    associatedtype Item6
    
    var item0: Item0? { get }
    var item1: Item1? { get }
    var item2: Item2? { get }
    var item3: Item3? { get }
    var item4: Item4? { get }
    var item5: Item5? { get }
    var item6: Item6? { get }
}

extension Union7: Union7Protocol {
}

// MARK: Equatable
extension Union7: Equatable where Item0: Equatable, Item1: Equatable, Item2: Equatable, Item3: Equatable, Item4: Equatable, Item5: Equatable, Item6: Equatable {
    public static func ==(_ union: Self, _ item0: Item0) -> Bool {
        return union.item0 == item0
    }
    
    public static func ==(_ union: Self, _ item1: Item1) -> Bool {
        return union.item1 == item1
    }
    
    public static func ==(_ union: Self, _ item2: Item2) -> Bool {
        return union.item2 == item2
    }
    
    public static func ==(_ union: Self, _ item3: Item3) -> Bool {
        return union.item3 == item3
    }
    
    public static func ==(_ union: Self, _ item4: Item4) -> Bool {
        return union.item4 == item4
    }
    
    public static func ==(_ union: Self, _ item5: Item5) -> Bool {
        return union.item5 == item5
    }
    
    public static func ==(_ union: Self, _ item6: Item6) -> Bool {
        return union.item6 == item6
    }
    
    public static func ==(_ item0: Item0, _ union: Self) -> Bool {
        return union.item0 == item0
    }
    
    public static func ==(_ item1: Item1, _ union: Self) -> Bool {
        return union.item1 == item1
    }
    
    public static func ==(_ item2: Item2, _ union: Self) -> Bool {
        return union.item2 == item2
    }
    
    public static func ==(_ item3: Item3, _ union: Self) -> Bool {
        return union.item3 == item3
    }
    
    public static func ==(_ item4: Item4, _ union: Self) -> Bool {
        return union.item4 == item4
    }
    
    public static func ==(_ item5: Item5, _ union: Self) -> Bool {
        return union.item5 == item5
    }
    
    public static func ==(_ item6: Item6, _ union: Self) -> Bool {
        return union.item6 == item6
    }
}

// MARK: Hashable
extension Union7: Hashable where Item0: Hashable, Item1: Hashable, Item2: Hashable, Item3: Hashable, Item4: Hashable, Item5: Hashable, Item6: Hashable {
}

// MARK: Encodable
extension Union7: Encodable where Item0: Encodable & UnionIdentifiable, Item1: Encodable & UnionIdentifiable, Item2: Encodable & UnionIdentifiable, Item3: Encodable & UnionIdentifiable, Item4: Encodable & UnionIdentifiable, Item5: Encodable & UnionIdentifiable, Item6: Encodable & UnionIdentifiable {
    public func encode(to encoder: Encoder) throws {
        var unionContainer = encoder.container(keyedBy: UnionCodingKey.self)
        
        try unionContainer.encode(unionTypeID, forKey: .unionTypeID)
        try unionContainer.encode(innerEncodable, forKey: .wrappedValue)
    }
    
    private var unionTypeID: UnionTypeID {
        switch self {
        case .item0:
            return Item0.unionTypeID
        
        case .item1:
            return Item1.unionTypeID
        
        case .item2:
            return Item2.unionTypeID
        
        case .item3:
            return Item3.unionTypeID
        
        case .item4:
            return Item4.unionTypeID
        
        case .item5:
            return Item5.unionTypeID
        
        case .item6:
            return Item6.unionTypeID
        }
    }
    
    private var innerEncodable: Encodable {
        switch self {
        case .item0(let item0):
            return item0
        
        case .item1(let item1):
            return item1
        
        case .item2(let item2):
            return item2
        
        case .item3(let item3):
            return item3
        
        case .item4(let item4):
            return item4
        
        case .item5(let item5):
            return item5
        
        case .item6(let item6):
            return item6
        }
    }
}

// MARK: Decodable
extension Union7: Decodable where Item0: Decodable & UnionIdentifiable, Item1: Decodable & UnionIdentifiable, Item2: Decodable & UnionIdentifiable, Item3: Decodable & UnionIdentifiable, Item4: Decodable & UnionIdentifiable, Item5: Decodable & UnionIdentifiable, Item6: Decodable & UnionIdentifiable {
    public init(from decoder: Decoder) throws {
        let unionContainer = try decoder.container(keyedBy: UnionCodingKey.self)
        
        let unionTypeID = try unionContainer.decode(UnionTypeID.self, forKey: .unionTypeID)
        
        switch unionTypeID {
        case Item0.unionTypeID:
            self = .item0(try unionContainer.decode(Item0.self, forKey: .wrappedValue))
        
        case Item1.unionTypeID:
            self = .item1(try unionContainer.decode(Item1.self, forKey: .wrappedValue))
        
        case Item2.unionTypeID:
            self = .item2(try unionContainer.decode(Item2.self, forKey: .wrappedValue))
        
        case Item3.unionTypeID:
            self = .item3(try unionContainer.decode(Item3.self, forKey: .wrappedValue))
        
        case Item4.unionTypeID:
            self = .item4(try unionContainer.decode(Item4.self, forKey: .wrappedValue))
        
        case Item5.unionTypeID:
            self = .item5(try unionContainer.decode(Item5.self, forKey: .wrappedValue))
        
        case Item6.unionTypeID:
            self = .item6(try unionContainer.decode(Item6.self, forKey: .wrappedValue))
        
        default:
            throw UnionDecodingError.unknownUnionTypeID(unionTypeID)
        }
    }
}

// MARK: CaseIterable
extension Union7: CaseIterable where Item0: CaseIterable, Item1: CaseIterable, Item2: CaseIterable, Item3: CaseIterable, Item4: CaseIterable, Item5: CaseIterable, Item6: CaseIterable {
    public static var allCases: [Self] {
        return Item0.allCases.map { .init($0) } + Item1.allCases.map { .init($0) } + Item2.allCases.map { .init($0) } + Item3.allCases.map { .init($0) } + Item4.allCases.map { .init($0) } + Item5.allCases.map { .init($0) } + Item6.allCases.map { .init($0) }
    }
}

// MARK: Sendable
extension Union7: Sendable where Item0: Sendable, Item1: Sendable, Item2: Sendable, Item3: Sendable, Item4: Sendable, Item5: Sendable, Item6: Sendable {
}

// MARK: CustomStringConvertible
extension Union7: CustomStringConvertible {
    public var description: String {
        switch self {
        case .item0(let item0):
            return "Union7.item0(\(item0))"
        
        case .item1(let item1):
            return "Union7.item1(\(item1))"
        
        case .item2(let item2):
            return "Union7.item2(\(item2))"
        
        case .item3(let item3):
            return "Union7.item3(\(item3))"
        
        case .item4(let item4):
            return "Union7.item4(\(item4))"
        
        case .item5(let item5):
            return "Union7.item5(\(item5))"
        
        case .item6(let item6):
            return "Union7.item6(\(item6))"
        }
    }
}

// MARK: CustomDebugStringConvertible
extension Union7: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .item0(let item0):
            return "Union7.item0(\(item0))"
        
        case .item1(let item1):
            return "Union7.item1(\(item1))"
        
        case .item2(let item2):
            return "Union7.item2(\(item2))"
        
        case .item3(let item3):
            return "Union7.item3(\(item3))"
        
        case .item4(let item4):
            return "Union7.item4(\(item4))"
        
        case .item5(let item5):
            return "Union7.item5(\(item5))"
        
        case .item6(let item6):
            return "Union7.item6(\(item6))"
        }
    }
}

// MARK: Error
extension Union7: Error where Item0: Error, Item1: Error, Item2: Error, Item3: Error, Item4: Error, Item5: Error, Item6: Error {
    public var innerError: Error {
        switch self {
        case .item0(let item0):
            return item0
        
        case .item1(let item1):
            return item1
        
        case .item2(let item2):
            return item2
        
        case .item3(let item3):
            return item3
        
        case .item4(let item4):
            return item4
        
        case .item5(let item5):
            return item5
        
        case .item6(let item6):
            return item6
        }
    }
    
    public var localizedDescription: String {
        return innerError.localizedDescription
    }
}

// MARK: - Union8

public enum Union8<Item0, Item1, Item2, Item3, Item4, Item5, Item6, Item7> {
    case item0(Item0)
    case item1(Item1)
    case item2(Item2)
    case item3(Item3)
    case item4(Item4)
    case item5(Item5)
    case item6(Item6)
    case item7(Item7)
}

public typealias U8 = Union8

// MARK: Initializers
extension Union8 {
    public init(_ item0: Item0) {
        self = .item0(item0)
    }
    
    public init(_ item1: Item1) {
        self = .item1(item1)
    }
    
    public init(_ item2: Item2) {
        self = .item2(item2)
    }
    
    public init(_ item3: Item3) {
        self = .item3(item3)
    }
    
    public init(_ item4: Item4) {
        self = .item4(item4)
    }
    
    public init(_ item5: Item5) {
        self = .item5(item5)
    }
    
    public init(_ item6: Item6) {
        self = .item6(item6)
    }
    
    public init(_ item7: Item7) {
        self = .item7(item7)
    }
}

// MARK: Getters
extension Union8 {
    public var item0: Item0? {
        if case let .item0(item0) = self {
            return item0
        }
        
        return nil
    }
    
    public var item1: Item1? {
        if case let .item1(item1) = self {
            return item1
        }
        
        return nil
    }
    
    public var item2: Item2? {
        if case let .item2(item2) = self {
            return item2
        }
        
        return nil
    }
    
    public var item3: Item3? {
        if case let .item3(item3) = self {
            return item3
        }
        
        return nil
    }
    
    public var item4: Item4? {
        if case let .item4(item4) = self {
            return item4
        }
        
        return nil
    }
    
    public var item5: Item5? {
        if case let .item5(item5) = self {
            return item5
        }
        
        return nil
    }
    
    public var item6: Item6? {
        if case let .item6(item6) = self {
            return item6
        }
        
        return nil
    }
    
    public var item7: Item7? {
        if case let .item7(item7) = self {
            return item7
        }
        
        return nil
    }
}

// MARK: Setters
extension Union8 {
    public mutating func set(_ item0: Item0) {
        self = .init(item0)
    }
    
    public mutating func set(_ item1: Item1) {
        self = .init(item1)
    }
    
    public mutating func set(_ item2: Item2) {
        self = .init(item2)
    }
    
    public mutating func set(_ item3: Item3) {
        self = .init(item3)
    }
    
    public mutating func set(_ item4: Item4) {
        self = .init(item4)
    }
    
    public mutating func set(_ item5: Item5) {
        self = .init(item5)
    }
    
    public mutating func set(_ item6: Item6) {
        self = .init(item6)
    }
    
    public mutating func set(_ item7: Item7) {
        self = .init(item7)
    }
}

// MARK: Map
extension Union8 {
    public func map0<Transformed0>(_ transform: (Item0) throws -> Transformed0) rethrows -> Union8<Transformed0, Item1, Item2, Item3, Item4, Item5, Item6, Item7> {
        switch self {
        case .item0(let item0):
            return .init(try transform(item0))
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        }
    }
    
    public func map1<Transformed1>(_ transform: (Item1) throws -> Transformed1) rethrows -> Union8<Item0, Transformed1, Item2, Item3, Item4, Item5, Item6, Item7> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(try transform(item1))
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        }
    }
    
    public func map2<Transformed2>(_ transform: (Item2) throws -> Transformed2) rethrows -> Union8<Item0, Item1, Transformed2, Item3, Item4, Item5, Item6, Item7> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(try transform(item2))
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        }
    }
    
    public func map3<Transformed3>(_ transform: (Item3) throws -> Transformed3) rethrows -> Union8<Item0, Item1, Item2, Transformed3, Item4, Item5, Item6, Item7> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(try transform(item3))
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        }
    }
    
    public func map4<Transformed4>(_ transform: (Item4) throws -> Transformed4) rethrows -> Union8<Item0, Item1, Item2, Item3, Transformed4, Item5, Item6, Item7> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(try transform(item4))
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        }
    }
    
    public func map5<Transformed5>(_ transform: (Item5) throws -> Transformed5) rethrows -> Union8<Item0, Item1, Item2, Item3, Item4, Transformed5, Item6, Item7> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(try transform(item5))
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        }
    }
    
    public func map6<Transformed6>(_ transform: (Item6) throws -> Transformed6) rethrows -> Union8<Item0, Item1, Item2, Item3, Item4, Item5, Transformed6, Item7> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(try transform(item6))
        
        case .item7(let item7):
            return .init(item7)
        }
    }
    
    public func map7<Transformed7>(_ transform: (Item7) throws -> Transformed7) rethrows -> Union8<Item0, Item1, Item2, Item3, Item4, Item5, Item6, Transformed7> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(try transform(item7))
        }
    }
}

// MARK: Flat Map
extension Union8 {
    public func flatMap0<Transformed0>(_ transform: (Item0) throws -> Union8<Transformed0, Item1, Item2, Item3, Item4, Item5, Item6, Item7>) rethrows -> Union8<Transformed0, Item1, Item2, Item3, Item4, Item5, Item6, Item7> {
        switch self {
        case .item0(let item0):
            return try transform(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        }
    }
    
    public func flatMap1<Transformed1>(_ transform: (Item1) throws -> Union8<Item0, Transformed1, Item2, Item3, Item4, Item5, Item6, Item7>) rethrows -> Union8<Item0, Transformed1, Item2, Item3, Item4, Item5, Item6, Item7> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return try transform(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        }
    }
    
    public func flatMap2<Transformed2>(_ transform: (Item2) throws -> Union8<Item0, Item1, Transformed2, Item3, Item4, Item5, Item6, Item7>) rethrows -> Union8<Item0, Item1, Transformed2, Item3, Item4, Item5, Item6, Item7> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return try transform(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        }
    }
    
    public func flatMap3<Transformed3>(_ transform: (Item3) throws -> Union8<Item0, Item1, Item2, Transformed3, Item4, Item5, Item6, Item7>) rethrows -> Union8<Item0, Item1, Item2, Transformed3, Item4, Item5, Item6, Item7> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return try transform(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        }
    }
    
    public func flatMap4<Transformed4>(_ transform: (Item4) throws -> Union8<Item0, Item1, Item2, Item3, Transformed4, Item5, Item6, Item7>) rethrows -> Union8<Item0, Item1, Item2, Item3, Transformed4, Item5, Item6, Item7> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return try transform(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        }
    }
    
    public func flatMap5<Transformed5>(_ transform: (Item5) throws -> Union8<Item0, Item1, Item2, Item3, Item4, Transformed5, Item6, Item7>) rethrows -> Union8<Item0, Item1, Item2, Item3, Item4, Transformed5, Item6, Item7> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return try transform(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        }
    }
    
    public func flatMap6<Transformed6>(_ transform: (Item6) throws -> Union8<Item0, Item1, Item2, Item3, Item4, Item5, Transformed6, Item7>) rethrows -> Union8<Item0, Item1, Item2, Item3, Item4, Item5, Transformed6, Item7> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return try transform(item6)
        
        case .item7(let item7):
            return .init(item7)
        }
    }
    
    public func flatMap7<Transformed7>(_ transform: (Item7) throws -> Union8<Item0, Item1, Item2, Item3, Item4, Item5, Item6, Transformed7>) rethrows -> Union8<Item0, Item1, Item2, Item3, Item4, Item5, Item6, Transformed7> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return try transform(item7)
        }
    }
}

// MARK: Compact Map
extension Sequence where Element: Union8Protocol {
    public func compactMap0() -> [Element.Item0] {
        return compactMap { $0.item0 }
    }
    
    public func compactMap1() -> [Element.Item1] {
        return compactMap { $0.item1 }
    }
    
    public func compactMap2() -> [Element.Item2] {
        return compactMap { $0.item2 }
    }
    
    public func compactMap3() -> [Element.Item3] {
        return compactMap { $0.item3 }
    }
    
    public func compactMap4() -> [Element.Item4] {
        return compactMap { $0.item4 }
    }
    
    public func compactMap5() -> [Element.Item5] {
        return compactMap { $0.item5 }
    }
    
    public func compactMap6() -> [Element.Item6] {
        return compactMap { $0.item6 }
    }
    
    public func compactMap7() -> [Element.Item7] {
        return compactMap { $0.item7 }
    }
}

public protocol Union8Protocol {
    associatedtype Item0
    associatedtype Item1
    associatedtype Item2
    associatedtype Item3
    associatedtype Item4
    associatedtype Item5
    associatedtype Item6
    associatedtype Item7
    
    var item0: Item0? { get }
    var item1: Item1? { get }
    var item2: Item2? { get }
    var item3: Item3? { get }
    var item4: Item4? { get }
    var item5: Item5? { get }
    var item6: Item6? { get }
    var item7: Item7? { get }
}

extension Union8: Union8Protocol {
}

// MARK: Equatable
extension Union8: Equatable where Item0: Equatable, Item1: Equatable, Item2: Equatable, Item3: Equatable, Item4: Equatable, Item5: Equatable, Item6: Equatable, Item7: Equatable {
    public static func ==(_ union: Self, _ item0: Item0) -> Bool {
        return union.item0 == item0
    }
    
    public static func ==(_ union: Self, _ item1: Item1) -> Bool {
        return union.item1 == item1
    }
    
    public static func ==(_ union: Self, _ item2: Item2) -> Bool {
        return union.item2 == item2
    }
    
    public static func ==(_ union: Self, _ item3: Item3) -> Bool {
        return union.item3 == item3
    }
    
    public static func ==(_ union: Self, _ item4: Item4) -> Bool {
        return union.item4 == item4
    }
    
    public static func ==(_ union: Self, _ item5: Item5) -> Bool {
        return union.item5 == item5
    }
    
    public static func ==(_ union: Self, _ item6: Item6) -> Bool {
        return union.item6 == item6
    }
    
    public static func ==(_ union: Self, _ item7: Item7) -> Bool {
        return union.item7 == item7
    }
    
    public static func ==(_ item0: Item0, _ union: Self) -> Bool {
        return union.item0 == item0
    }
    
    public static func ==(_ item1: Item1, _ union: Self) -> Bool {
        return union.item1 == item1
    }
    
    public static func ==(_ item2: Item2, _ union: Self) -> Bool {
        return union.item2 == item2
    }
    
    public static func ==(_ item3: Item3, _ union: Self) -> Bool {
        return union.item3 == item3
    }
    
    public static func ==(_ item4: Item4, _ union: Self) -> Bool {
        return union.item4 == item4
    }
    
    public static func ==(_ item5: Item5, _ union: Self) -> Bool {
        return union.item5 == item5
    }
    
    public static func ==(_ item6: Item6, _ union: Self) -> Bool {
        return union.item6 == item6
    }
    
    public static func ==(_ item7: Item7, _ union: Self) -> Bool {
        return union.item7 == item7
    }
}

// MARK: Hashable
extension Union8: Hashable where Item0: Hashable, Item1: Hashable, Item2: Hashable, Item3: Hashable, Item4: Hashable, Item5: Hashable, Item6: Hashable, Item7: Hashable {
}

// MARK: Encodable
extension Union8: Encodable where Item0: Encodable & UnionIdentifiable, Item1: Encodable & UnionIdentifiable, Item2: Encodable & UnionIdentifiable, Item3: Encodable & UnionIdentifiable, Item4: Encodable & UnionIdentifiable, Item5: Encodable & UnionIdentifiable, Item6: Encodable & UnionIdentifiable, Item7: Encodable & UnionIdentifiable {
    public func encode(to encoder: Encoder) throws {
        var unionContainer = encoder.container(keyedBy: UnionCodingKey.self)
        
        try unionContainer.encode(unionTypeID, forKey: .unionTypeID)
        try unionContainer.encode(innerEncodable, forKey: .wrappedValue)
    }
    
    private var unionTypeID: UnionTypeID {
        switch self {
        case .item0:
            return Item0.unionTypeID
        
        case .item1:
            return Item1.unionTypeID
        
        case .item2:
            return Item2.unionTypeID
        
        case .item3:
            return Item3.unionTypeID
        
        case .item4:
            return Item4.unionTypeID
        
        case .item5:
            return Item5.unionTypeID
        
        case .item6:
            return Item6.unionTypeID
        
        case .item7:
            return Item7.unionTypeID
        }
    }
    
    private var innerEncodable: Encodable {
        switch self {
        case .item0(let item0):
            return item0
        
        case .item1(let item1):
            return item1
        
        case .item2(let item2):
            return item2
        
        case .item3(let item3):
            return item3
        
        case .item4(let item4):
            return item4
        
        case .item5(let item5):
            return item5
        
        case .item6(let item6):
            return item6
        
        case .item7(let item7):
            return item7
        }
    }
}

// MARK: Decodable
extension Union8: Decodable where Item0: Decodable & UnionIdentifiable, Item1: Decodable & UnionIdentifiable, Item2: Decodable & UnionIdentifiable, Item3: Decodable & UnionIdentifiable, Item4: Decodable & UnionIdentifiable, Item5: Decodable & UnionIdentifiable, Item6: Decodable & UnionIdentifiable, Item7: Decodable & UnionIdentifiable {
    public init(from decoder: Decoder) throws {
        let unionContainer = try decoder.container(keyedBy: UnionCodingKey.self)
        
        let unionTypeID = try unionContainer.decode(UnionTypeID.self, forKey: .unionTypeID)
        
        switch unionTypeID {
        case Item0.unionTypeID:
            self = .item0(try unionContainer.decode(Item0.self, forKey: .wrappedValue))
        
        case Item1.unionTypeID:
            self = .item1(try unionContainer.decode(Item1.self, forKey: .wrappedValue))
        
        case Item2.unionTypeID:
            self = .item2(try unionContainer.decode(Item2.self, forKey: .wrappedValue))
        
        case Item3.unionTypeID:
            self = .item3(try unionContainer.decode(Item3.self, forKey: .wrappedValue))
        
        case Item4.unionTypeID:
            self = .item4(try unionContainer.decode(Item4.self, forKey: .wrappedValue))
        
        case Item5.unionTypeID:
            self = .item5(try unionContainer.decode(Item5.self, forKey: .wrappedValue))
        
        case Item6.unionTypeID:
            self = .item6(try unionContainer.decode(Item6.self, forKey: .wrappedValue))
        
        case Item7.unionTypeID:
            self = .item7(try unionContainer.decode(Item7.self, forKey: .wrappedValue))
        
        default:
            throw UnionDecodingError.unknownUnionTypeID(unionTypeID)
        }
    }
}

// MARK: CaseIterable
extension Union8: CaseIterable where Item0: CaseIterable, Item1: CaseIterable, Item2: CaseIterable, Item3: CaseIterable, Item4: CaseIterable, Item5: CaseIterable, Item6: CaseIterable, Item7: CaseIterable {
    public static var allCases: [Self] {
        return Item0.allCases.map { .init($0) } + Item1.allCases.map { .init($0) } + Item2.allCases.map { .init($0) } + Item3.allCases.map { .init($0) } + Item4.allCases.map { .init($0) } + Item5.allCases.map { .init($0) } + Item6.allCases.map { .init($0) } + Item7.allCases.map { .init($0) }
    }
}

// MARK: Sendable
extension Union8: Sendable where Item0: Sendable, Item1: Sendable, Item2: Sendable, Item3: Sendable, Item4: Sendable, Item5: Sendable, Item6: Sendable, Item7: Sendable {
}

// MARK: CustomStringConvertible
extension Union8: CustomStringConvertible {
    public var description: String {
        switch self {
        case .item0(let item0):
            return "Union8.item0(\(item0))"
        
        case .item1(let item1):
            return "Union8.item1(\(item1))"
        
        case .item2(let item2):
            return "Union8.item2(\(item2))"
        
        case .item3(let item3):
            return "Union8.item3(\(item3))"
        
        case .item4(let item4):
            return "Union8.item4(\(item4))"
        
        case .item5(let item5):
            return "Union8.item5(\(item5))"
        
        case .item6(let item6):
            return "Union8.item6(\(item6))"
        
        case .item7(let item7):
            return "Union8.item7(\(item7))"
        }
    }
}

// MARK: CustomDebugStringConvertible
extension Union8: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .item0(let item0):
            return "Union8.item0(\(item0))"
        
        case .item1(let item1):
            return "Union8.item1(\(item1))"
        
        case .item2(let item2):
            return "Union8.item2(\(item2))"
        
        case .item3(let item3):
            return "Union8.item3(\(item3))"
        
        case .item4(let item4):
            return "Union8.item4(\(item4))"
        
        case .item5(let item5):
            return "Union8.item5(\(item5))"
        
        case .item6(let item6):
            return "Union8.item6(\(item6))"
        
        case .item7(let item7):
            return "Union8.item7(\(item7))"
        }
    }
}

// MARK: Error
extension Union8: Error where Item0: Error, Item1: Error, Item2: Error, Item3: Error, Item4: Error, Item5: Error, Item6: Error, Item7: Error {
    public var innerError: Error {
        switch self {
        case .item0(let item0):
            return item0
        
        case .item1(let item1):
            return item1
        
        case .item2(let item2):
            return item2
        
        case .item3(let item3):
            return item3
        
        case .item4(let item4):
            return item4
        
        case .item5(let item5):
            return item5
        
        case .item6(let item6):
            return item6
        
        case .item7(let item7):
            return item7
        }
    }
    
    public var localizedDescription: String {
        return innerError.localizedDescription
    }
}

// MARK: - Union9

public enum Union9<Item0, Item1, Item2, Item3, Item4, Item5, Item6, Item7, Item8> {
    case item0(Item0)
    case item1(Item1)
    case item2(Item2)
    case item3(Item3)
    case item4(Item4)
    case item5(Item5)
    case item6(Item6)
    case item7(Item7)
    case item8(Item8)
}

public typealias U9 = Union9

// MARK: Initializers
extension Union9 {
    public init(_ item0: Item0) {
        self = .item0(item0)
    }
    
    public init(_ item1: Item1) {
        self = .item1(item1)
    }
    
    public init(_ item2: Item2) {
        self = .item2(item2)
    }
    
    public init(_ item3: Item3) {
        self = .item3(item3)
    }
    
    public init(_ item4: Item4) {
        self = .item4(item4)
    }
    
    public init(_ item5: Item5) {
        self = .item5(item5)
    }
    
    public init(_ item6: Item6) {
        self = .item6(item6)
    }
    
    public init(_ item7: Item7) {
        self = .item7(item7)
    }
    
    public init(_ item8: Item8) {
        self = .item8(item8)
    }
}

// MARK: Getters
extension Union9 {
    public var item0: Item0? {
        if case let .item0(item0) = self {
            return item0
        }
        
        return nil
    }
    
    public var item1: Item1? {
        if case let .item1(item1) = self {
            return item1
        }
        
        return nil
    }
    
    public var item2: Item2? {
        if case let .item2(item2) = self {
            return item2
        }
        
        return nil
    }
    
    public var item3: Item3? {
        if case let .item3(item3) = self {
            return item3
        }
        
        return nil
    }
    
    public var item4: Item4? {
        if case let .item4(item4) = self {
            return item4
        }
        
        return nil
    }
    
    public var item5: Item5? {
        if case let .item5(item5) = self {
            return item5
        }
        
        return nil
    }
    
    public var item6: Item6? {
        if case let .item6(item6) = self {
            return item6
        }
        
        return nil
    }
    
    public var item7: Item7? {
        if case let .item7(item7) = self {
            return item7
        }
        
        return nil
    }
    
    public var item8: Item8? {
        if case let .item8(item8) = self {
            return item8
        }
        
        return nil
    }
}

// MARK: Setters
extension Union9 {
    public mutating func set(_ item0: Item0) {
        self = .init(item0)
    }
    
    public mutating func set(_ item1: Item1) {
        self = .init(item1)
    }
    
    public mutating func set(_ item2: Item2) {
        self = .init(item2)
    }
    
    public mutating func set(_ item3: Item3) {
        self = .init(item3)
    }
    
    public mutating func set(_ item4: Item4) {
        self = .init(item4)
    }
    
    public mutating func set(_ item5: Item5) {
        self = .init(item5)
    }
    
    public mutating func set(_ item6: Item6) {
        self = .init(item6)
    }
    
    public mutating func set(_ item7: Item7) {
        self = .init(item7)
    }
    
    public mutating func set(_ item8: Item8) {
        self = .init(item8)
    }
}

// MARK: Map
extension Union9 {
    public func map0<Transformed0>(_ transform: (Item0) throws -> Transformed0) rethrows -> Union9<Transformed0, Item1, Item2, Item3, Item4, Item5, Item6, Item7, Item8> {
        switch self {
        case .item0(let item0):
            return .init(try transform(item0))
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        
        case .item8(let item8):
            return .init(item8)
        }
    }
    
    public func map1<Transformed1>(_ transform: (Item1) throws -> Transformed1) rethrows -> Union9<Item0, Transformed1, Item2, Item3, Item4, Item5, Item6, Item7, Item8> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(try transform(item1))
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        
        case .item8(let item8):
            return .init(item8)
        }
    }
    
    public func map2<Transformed2>(_ transform: (Item2) throws -> Transformed2) rethrows -> Union9<Item0, Item1, Transformed2, Item3, Item4, Item5, Item6, Item7, Item8> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(try transform(item2))
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        
        case .item8(let item8):
            return .init(item8)
        }
    }
    
    public func map3<Transformed3>(_ transform: (Item3) throws -> Transformed3) rethrows -> Union9<Item0, Item1, Item2, Transformed3, Item4, Item5, Item6, Item7, Item8> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(try transform(item3))
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        
        case .item8(let item8):
            return .init(item8)
        }
    }
    
    public func map4<Transformed4>(_ transform: (Item4) throws -> Transformed4) rethrows -> Union9<Item0, Item1, Item2, Item3, Transformed4, Item5, Item6, Item7, Item8> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(try transform(item4))
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        
        case .item8(let item8):
            return .init(item8)
        }
    }
    
    public func map5<Transformed5>(_ transform: (Item5) throws -> Transformed5) rethrows -> Union9<Item0, Item1, Item2, Item3, Item4, Transformed5, Item6, Item7, Item8> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(try transform(item5))
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        
        case .item8(let item8):
            return .init(item8)
        }
    }
    
    public func map6<Transformed6>(_ transform: (Item6) throws -> Transformed6) rethrows -> Union9<Item0, Item1, Item2, Item3, Item4, Item5, Transformed6, Item7, Item8> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(try transform(item6))
        
        case .item7(let item7):
            return .init(item7)
        
        case .item8(let item8):
            return .init(item8)
        }
    }
    
    public func map7<Transformed7>(_ transform: (Item7) throws -> Transformed7) rethrows -> Union9<Item0, Item1, Item2, Item3, Item4, Item5, Item6, Transformed7, Item8> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(try transform(item7))
        
        case .item8(let item8):
            return .init(item8)
        }
    }
    
    public func map8<Transformed8>(_ transform: (Item8) throws -> Transformed8) rethrows -> Union9<Item0, Item1, Item2, Item3, Item4, Item5, Item6, Item7, Transformed8> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        
        case .item8(let item8):
            return .init(try transform(item8))
        }
    }
}

// MARK: Flat Map
extension Union9 {
    public func flatMap0<Transformed0>(_ transform: (Item0) throws -> Union9<Transformed0, Item1, Item2, Item3, Item4, Item5, Item6, Item7, Item8>) rethrows -> Union9<Transformed0, Item1, Item2, Item3, Item4, Item5, Item6, Item7, Item8> {
        switch self {
        case .item0(let item0):
            return try transform(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        
        case .item8(let item8):
            return .init(item8)
        }
    }
    
    public func flatMap1<Transformed1>(_ transform: (Item1) throws -> Union9<Item0, Transformed1, Item2, Item3, Item4, Item5, Item6, Item7, Item8>) rethrows -> Union9<Item0, Transformed1, Item2, Item3, Item4, Item5, Item6, Item7, Item8> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return try transform(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        
        case .item8(let item8):
            return .init(item8)
        }
    }
    
    public func flatMap2<Transformed2>(_ transform: (Item2) throws -> Union9<Item0, Item1, Transformed2, Item3, Item4, Item5, Item6, Item7, Item8>) rethrows -> Union9<Item0, Item1, Transformed2, Item3, Item4, Item5, Item6, Item7, Item8> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return try transform(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        
        case .item8(let item8):
            return .init(item8)
        }
    }
    
    public func flatMap3<Transformed3>(_ transform: (Item3) throws -> Union9<Item0, Item1, Item2, Transformed3, Item4, Item5, Item6, Item7, Item8>) rethrows -> Union9<Item0, Item1, Item2, Transformed3, Item4, Item5, Item6, Item7, Item8> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return try transform(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        
        case .item8(let item8):
            return .init(item8)
        }
    }
    
    public func flatMap4<Transformed4>(_ transform: (Item4) throws -> Union9<Item0, Item1, Item2, Item3, Transformed4, Item5, Item6, Item7, Item8>) rethrows -> Union9<Item0, Item1, Item2, Item3, Transformed4, Item5, Item6, Item7, Item8> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return try transform(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        
        case .item8(let item8):
            return .init(item8)
        }
    }
    
    public func flatMap5<Transformed5>(_ transform: (Item5) throws -> Union9<Item0, Item1, Item2, Item3, Item4, Transformed5, Item6, Item7, Item8>) rethrows -> Union9<Item0, Item1, Item2, Item3, Item4, Transformed5, Item6, Item7, Item8> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return try transform(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        
        case .item8(let item8):
            return .init(item8)
        }
    }
    
    public func flatMap6<Transformed6>(_ transform: (Item6) throws -> Union9<Item0, Item1, Item2, Item3, Item4, Item5, Transformed6, Item7, Item8>) rethrows -> Union9<Item0, Item1, Item2, Item3, Item4, Item5, Transformed6, Item7, Item8> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return try transform(item6)
        
        case .item7(let item7):
            return .init(item7)
        
        case .item8(let item8):
            return .init(item8)
        }
    }
    
    public func flatMap7<Transformed7>(_ transform: (Item7) throws -> Union9<Item0, Item1, Item2, Item3, Item4, Item5, Item6, Transformed7, Item8>) rethrows -> Union9<Item0, Item1, Item2, Item3, Item4, Item5, Item6, Transformed7, Item8> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return try transform(item7)
        
        case .item8(let item8):
            return .init(item8)
        }
    }
    
    public func flatMap8<Transformed8>(_ transform: (Item8) throws -> Union9<Item0, Item1, Item2, Item3, Item4, Item5, Item6, Item7, Transformed8>) rethrows -> Union9<Item0, Item1, Item2, Item3, Item4, Item5, Item6, Item7, Transformed8> {
        switch self {
        case .item0(let item0):
            return .init(item0)
        
        case .item1(let item1):
            return .init(item1)
        
        case .item2(let item2):
            return .init(item2)
        
        case .item3(let item3):
            return .init(item3)
        
        case .item4(let item4):
            return .init(item4)
        
        case .item5(let item5):
            return .init(item5)
        
        case .item6(let item6):
            return .init(item6)
        
        case .item7(let item7):
            return .init(item7)
        
        case .item8(let item8):
            return try transform(item8)
        }
    }
}

// MARK: Compact Map
extension Sequence where Element: Union9Protocol {
    public func compactMap0() -> [Element.Item0] {
        return compactMap { $0.item0 }
    }
    
    public func compactMap1() -> [Element.Item1] {
        return compactMap { $0.item1 }
    }
    
    public func compactMap2() -> [Element.Item2] {
        return compactMap { $0.item2 }
    }
    
    public func compactMap3() -> [Element.Item3] {
        return compactMap { $0.item3 }
    }
    
    public func compactMap4() -> [Element.Item4] {
        return compactMap { $0.item4 }
    }
    
    public func compactMap5() -> [Element.Item5] {
        return compactMap { $0.item5 }
    }
    
    public func compactMap6() -> [Element.Item6] {
        return compactMap { $0.item6 }
    }
    
    public func compactMap7() -> [Element.Item7] {
        return compactMap { $0.item7 }
    }
    
    public func compactMap8() -> [Element.Item8] {
        return compactMap { $0.item8 }
    }
}

public protocol Union9Protocol {
    associatedtype Item0
    associatedtype Item1
    associatedtype Item2
    associatedtype Item3
    associatedtype Item4
    associatedtype Item5
    associatedtype Item6
    associatedtype Item7
    associatedtype Item8
    
    var item0: Item0? { get }
    var item1: Item1? { get }
    var item2: Item2? { get }
    var item3: Item3? { get }
    var item4: Item4? { get }
    var item5: Item5? { get }
    var item6: Item6? { get }
    var item7: Item7? { get }
    var item8: Item8? { get }
}

extension Union9: Union9Protocol {
}

// MARK: Equatable
extension Union9: Equatable where Item0: Equatable, Item1: Equatable, Item2: Equatable, Item3: Equatable, Item4: Equatable, Item5: Equatable, Item6: Equatable, Item7: Equatable, Item8: Equatable {
    public static func ==(_ union: Self, _ item0: Item0) -> Bool {
        return union.item0 == item0
    }
    
    public static func ==(_ union: Self, _ item1: Item1) -> Bool {
        return union.item1 == item1
    }
    
    public static func ==(_ union: Self, _ item2: Item2) -> Bool {
        return union.item2 == item2
    }
    
    public static func ==(_ union: Self, _ item3: Item3) -> Bool {
        return union.item3 == item3
    }
    
    public static func ==(_ union: Self, _ item4: Item4) -> Bool {
        return union.item4 == item4
    }
    
    public static func ==(_ union: Self, _ item5: Item5) -> Bool {
        return union.item5 == item5
    }
    
    public static func ==(_ union: Self, _ item6: Item6) -> Bool {
        return union.item6 == item6
    }
    
    public static func ==(_ union: Self, _ item7: Item7) -> Bool {
        return union.item7 == item7
    }
    
    public static func ==(_ union: Self, _ item8: Item8) -> Bool {
        return union.item8 == item8
    }
    
    public static func ==(_ item0: Item0, _ union: Self) -> Bool {
        return union.item0 == item0
    }
    
    public static func ==(_ item1: Item1, _ union: Self) -> Bool {
        return union.item1 == item1
    }
    
    public static func ==(_ item2: Item2, _ union: Self) -> Bool {
        return union.item2 == item2
    }
    
    public static func ==(_ item3: Item3, _ union: Self) -> Bool {
        return union.item3 == item3
    }
    
    public static func ==(_ item4: Item4, _ union: Self) -> Bool {
        return union.item4 == item4
    }
    
    public static func ==(_ item5: Item5, _ union: Self) -> Bool {
        return union.item5 == item5
    }
    
    public static func ==(_ item6: Item6, _ union: Self) -> Bool {
        return union.item6 == item6
    }
    
    public static func ==(_ item7: Item7, _ union: Self) -> Bool {
        return union.item7 == item7
    }
    
    public static func ==(_ item8: Item8, _ union: Self) -> Bool {
        return union.item8 == item8
    }
}

// MARK: Hashable
extension Union9: Hashable where Item0: Hashable, Item1: Hashable, Item2: Hashable, Item3: Hashable, Item4: Hashable, Item5: Hashable, Item6: Hashable, Item7: Hashable, Item8: Hashable {
}

// MARK: Encodable
extension Union9: Encodable where Item0: Encodable & UnionIdentifiable, Item1: Encodable & UnionIdentifiable, Item2: Encodable & UnionIdentifiable, Item3: Encodable & UnionIdentifiable, Item4: Encodable & UnionIdentifiable, Item5: Encodable & UnionIdentifiable, Item6: Encodable & UnionIdentifiable, Item7: Encodable & UnionIdentifiable, Item8: Encodable & UnionIdentifiable {
    public func encode(to encoder: Encoder) throws {
        var unionContainer = encoder.container(keyedBy: UnionCodingKey.self)
        
        try unionContainer.encode(unionTypeID, forKey: .unionTypeID)
        try unionContainer.encode(innerEncodable, forKey: .wrappedValue)
    }
    
    private var unionTypeID: UnionTypeID {
        switch self {
        case .item0:
            return Item0.unionTypeID
        
        case .item1:
            return Item1.unionTypeID
        
        case .item2:
            return Item2.unionTypeID
        
        case .item3:
            return Item3.unionTypeID
        
        case .item4:
            return Item4.unionTypeID
        
        case .item5:
            return Item5.unionTypeID
        
        case .item6:
            return Item6.unionTypeID
        
        case .item7:
            return Item7.unionTypeID
        
        case .item8:
            return Item8.unionTypeID
        }
    }
    
    private var innerEncodable: Encodable {
        switch self {
        case .item0(let item0):
            return item0
        
        case .item1(let item1):
            return item1
        
        case .item2(let item2):
            return item2
        
        case .item3(let item3):
            return item3
        
        case .item4(let item4):
            return item4
        
        case .item5(let item5):
            return item5
        
        case .item6(let item6):
            return item6
        
        case .item7(let item7):
            return item7
        
        case .item8(let item8):
            return item8
        }
    }
}

// MARK: Decodable
extension Union9: Decodable where Item0: Decodable & UnionIdentifiable, Item1: Decodable & UnionIdentifiable, Item2: Decodable & UnionIdentifiable, Item3: Decodable & UnionIdentifiable, Item4: Decodable & UnionIdentifiable, Item5: Decodable & UnionIdentifiable, Item6: Decodable & UnionIdentifiable, Item7: Decodable & UnionIdentifiable, Item8: Decodable & UnionIdentifiable {
    public init(from decoder: Decoder) throws {
        let unionContainer = try decoder.container(keyedBy: UnionCodingKey.self)
        
        let unionTypeID = try unionContainer.decode(UnionTypeID.self, forKey: .unionTypeID)
        
        switch unionTypeID {
        case Item0.unionTypeID:
            self = .item0(try unionContainer.decode(Item0.self, forKey: .wrappedValue))
        
        case Item1.unionTypeID:
            self = .item1(try unionContainer.decode(Item1.self, forKey: .wrappedValue))
        
        case Item2.unionTypeID:
            self = .item2(try unionContainer.decode(Item2.self, forKey: .wrappedValue))
        
        case Item3.unionTypeID:
            self = .item3(try unionContainer.decode(Item3.self, forKey: .wrappedValue))
        
        case Item4.unionTypeID:
            self = .item4(try unionContainer.decode(Item4.self, forKey: .wrappedValue))
        
        case Item5.unionTypeID:
            self = .item5(try unionContainer.decode(Item5.self, forKey: .wrappedValue))
        
        case Item6.unionTypeID:
            self = .item6(try unionContainer.decode(Item6.self, forKey: .wrappedValue))
        
        case Item7.unionTypeID:
            self = .item7(try unionContainer.decode(Item7.self, forKey: .wrappedValue))
        
        case Item8.unionTypeID:
            self = .item8(try unionContainer.decode(Item8.self, forKey: .wrappedValue))
        
        default:
            throw UnionDecodingError.unknownUnionTypeID(unionTypeID)
        }
    }
}

// MARK: CaseIterable
extension Union9: CaseIterable where Item0: CaseIterable, Item1: CaseIterable, Item2: CaseIterable, Item3: CaseIterable, Item4: CaseIterable, Item5: CaseIterable, Item6: CaseIterable, Item7: CaseIterable, Item8: CaseIterable {
    public static var allCases: [Self] {
        return Item0.allCases.map { .init($0) } + Item1.allCases.map { .init($0) } + Item2.allCases.map { .init($0) } + Item3.allCases.map { .init($0) } + Item4.allCases.map { .init($0) } + Item5.allCases.map { .init($0) } + Item6.allCases.map { .init($0) } + Item7.allCases.map { .init($0) } + Item8.allCases.map { .init($0) }
    }
}

// MARK: Sendable
extension Union9: Sendable where Item0: Sendable, Item1: Sendable, Item2: Sendable, Item3: Sendable, Item4: Sendable, Item5: Sendable, Item6: Sendable, Item7: Sendable, Item8: Sendable {
}

// MARK: CustomStringConvertible
extension Union9: CustomStringConvertible {
    public var description: String {
        switch self {
        case .item0(let item0):
            return "Union9.item0(\(item0))"
        
        case .item1(let item1):
            return "Union9.item1(\(item1))"
        
        case .item2(let item2):
            return "Union9.item2(\(item2))"
        
        case .item3(let item3):
            return "Union9.item3(\(item3))"
        
        case .item4(let item4):
            return "Union9.item4(\(item4))"
        
        case .item5(let item5):
            return "Union9.item5(\(item5))"
        
        case .item6(let item6):
            return "Union9.item6(\(item6))"
        
        case .item7(let item7):
            return "Union9.item7(\(item7))"
        
        case .item8(let item8):
            return "Union9.item8(\(item8))"
        }
    }
}

// MARK: CustomDebugStringConvertible
extension Union9: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .item0(let item0):
            return "Union9.item0(\(item0))"
        
        case .item1(let item1):
            return "Union9.item1(\(item1))"
        
        case .item2(let item2):
            return "Union9.item2(\(item2))"
        
        case .item3(let item3):
            return "Union9.item3(\(item3))"
        
        case .item4(let item4):
            return "Union9.item4(\(item4))"
        
        case .item5(let item5):
            return "Union9.item5(\(item5))"
        
        case .item6(let item6):
            return "Union9.item6(\(item6))"
        
        case .item7(let item7):
            return "Union9.item7(\(item7))"
        
        case .item8(let item8):
            return "Union9.item8(\(item8))"
        }
    }
}

// MARK: Error
extension Union9: Error where Item0: Error, Item1: Error, Item2: Error, Item3: Error, Item4: Error, Item5: Error, Item6: Error, Item7: Error, Item8: Error {
    public var innerError: Error {
        switch self {
        case .item0(let item0):
            return item0
        
        case .item1(let item1):
            return item1
        
        case .item2(let item2):
            return item2
        
        case .item3(let item3):
            return item3
        
        case .item4(let item4):
            return item4
        
        case .item5(let item5):
            return item5
        
        case .item6(let item6):
            return item6
        
        case .item7(let item7):
            return item7
        
        case .item8(let item8):
            return item8
        }
    }
    
    public var localizedDescription: String {
        return innerError.localizedDescription
    }
}

// MARK: - Shared

// MARK: Codable

public typealias UnionTypeID = String

public protocol UnionIdentifiable {
    static var unionTypeID: UnionTypeID { get }
}

private struct UnionCodingKey: CodingKey {
    var stringValue: String
    init?(stringValue: String) { self.stringValue = stringValue }
    
    var intValue: Int? { return nil }
    init?(intValue: Int) { return nil }
    
    static let unionTypeID = UnionCodingKey(stringValue: "type")!
    static let wrappedValue = UnionCodingKey(stringValue: "value")!
}

public enum UnionDecodingError: Error {
    case unknownUnionTypeID(UnionTypeID)
}

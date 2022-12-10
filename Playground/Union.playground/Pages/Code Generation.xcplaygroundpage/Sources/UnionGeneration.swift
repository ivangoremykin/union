//
//  UnionGeneration.swift
//  UnionExample
//
//  Created by Ivan Goremykin on 04/10/2022.
//

import Foundation

// MARK: - Source
public func makeUnionSource(
    unionSize: Int,
    accessLevel: String,
    unionTypeIDType: String,
    unionTypeIDKey: String,
    wrappedValueKey: String
) -> String {
    guard let accessLevel = AccessLevel(rawValue: accessLevel) else {
        return makeUnknownTemplateParameterValueError(
            parameter: "accessLevel",
            value: accessLevel
        )
    }

    let _imports = makeImportsDeclaration([Constants.Framework.foundation])

    let _unions = loop(from: 2, size: unionSize + 1) {
        return makeUnion(size: $0, accessLevel: accessLevel)
    }

    let _unionShared = makeUnionShared(
        accessLevel: accessLevel,
        unionTypeIDType: unionTypeIDType,
        unionTypeIDKey: unionTypeIDKey,
        wrappedValueKey: wrappedValueKey
    )

    return ([_imports] + _unions + [_unionShared]).joinedWithDoubleNewLine()
}

// MARK: - Union
func makeUnion(
    size: Int,
    accessLevel: AccessLevel
) -> String {
    return [
        makeUnionMark(size),
        makeUnionDeclaration(size, accessLevel),
        makeUnionTypealias(size, accessLevel),
        makeInitializers(size, accessLevel),
        makeGetters(size, accessLevel),
        makeSetters(size, accessLevel),
        makeMap(size, accessLevel),
        makeFlatMap(size, accessLevel),
        makeCompactMap(size, accessLevel),
        makeEquatable(size, accessLevel),
        makeHashable(size),
        makeEncodable(size, accessLevel),
        makeDecodable(size, accessLevel),
        makeCaseIterable(size, accessLevel),
        makeSendable(size),
        makeCustomStringConvertible(size, accessLevel),
        makeCustomDebugStringConvertible(size, accessLevel),
        makeError(size, accessLevel)
    ].joinedWithDoubleNewLine()
}

// MARK: Mark
func makeUnionMark(_ size: Int) -> String {
    return makeMark(unionTypeName(size), hasSeparator: true)
}

// MARK: Declaration
func makeUnionDeclaration(
    _ size: Int,
    _ accessLevel: AccessLevel
) -> String {
    return makeEnum(
        name: unionTypeName(size),
        accessLevel: accessLevel,
        genericArguments: loop(size, { "Item\($0)" }),
        conformsTo: nil,
        cases: loop(size) { "item\($0)(Item\($0))" }
    )
}

// MARK: Typealias
func makeUnionTypealias(
    _ size: Int,
    _ accessLevel: AccessLevel
) -> String {
    return makeTypealias(accessLevel, "U\(size)", "\(unionTypeName(size))")
}

// MARK: Initializers
func makeInitializers(
    _ size: Int,
    _ accessLevel: AccessLevel
) -> String {
    return makeUnionExtension(
        size,
        accessLevel: nil,
        mark: Constants.Mark.initializers,
        conforms: nil,
        whereBlock: nil,
        body: loop(size) {
            makeInitializer(
                accessLevel: accessLevel,
                arguments: [.init("_", "item\($0)", "Item\($0)")],
                throws: nil,
                body: "self = .item\($0)(item\($0))"
            )
        }.joinedWithDoubleNewLine()
    )
}

// MARK: Getters
func makeGetters(
    _ size: Int,
    _ accessLevel: AccessLevel
) -> String {
    return makeUnionExtension(
        size,
        accessLevel: nil,
        mark: Constants.Mark.getters,
        conforms: nil,
        whereBlock: nil,
        body: loop(size) {
            makeComputedProperty(
                name: "item\($0)",
                accessLevel: accessLevel,
                type: "Item\($0)?",
                keyword: nil,
                body: """
                if case let .item\($0)(item\($0)) = self {
                    return item\($0)
                }

                return nil
                """
            )
        }.joinedWithDoubleNewLine()
    )
}

// MARK: Setters
func makeSetters(
    _ size: Int,
    _ accessLevel: AccessLevel
) -> String {
    return makeUnionExtension(
        size,
        accessLevel: nil,
        mark: Constants.Mark.setters,
        conforms: nil,
        whereBlock: nil,
        body: loop(size) {
            makeFunction(
                name: "set",
                accessLevel: accessLevel,
                keyword: .mutating,
                genericArguments: nil,
                arguments: [.init("_", "item\($0)", "Item\($0)")],
                throws: nil,
                returns: nil,
                body: "self = .init(item\($0))"
            )
        }.joinedWithDoubleNewLine()
    )
}

// MARK: Map
func makeMap(
    _ size: Int,
    _ accessLevel: AccessLevel
) -> String {
    return makeUnionExtension(
        size,
        accessLevel: nil,
        mark: Constants.Mark.map,
        conforms: nil,
        whereBlock: nil,
        body: loop(size) { transformedIndex in
            let _transformedType = "Transformed\(transformedIndex)"
            
            return makeFunction(
                name: "map\(transformedIndex)",
                accessLevel: accessLevel,
                keyword: nil,
                genericArguments: [_transformedType],
                arguments: [.init("_", "transform", "(Item\(transformedIndex)) throws -> \(_transformedType)")],
                throws: .rethrows,
                returns: makeTransformedUnionDeclaration(size: size, transformedIndex: transformedIndex),
                body: makeSwitchSelfCaseReturn(
                    size: size,
                    shouldUnwrapAssociatedValues: true,
                    returns: { index in
                        return index == transformedIndex
                            ? ".init(try transform(item\(index)))"
                            : ".init(item\(index))"
                    }
                )
            )
        }.joinedWithDoubleNewLine()
    )
}

func makeTransformedGenerics(
    size: Int,
    transformedIndex: Int
) -> String {
    return makeGenericArgumentsDeclaration(
        loop(size) {
            $0 == transformedIndex ? "Transformed\($0)" : "Item\($0)"
        }
    )
}

func makeTransformedUnionDeclaration(
    size: Int,
    transformedIndex: Int
) -> String {
    let _transformedGenerics = makeTransformedGenerics(
        size: size,
        transformedIndex: transformedIndex
    )

    return "\(unionTypeName(size))\(_transformedGenerics)"
}

// MARK: Flat Map
func makeFlatMap(
    _ size: Int,
    _ accessLevel: AccessLevel
) -> String {
    return makeUnionExtension(
        size,
        accessLevel: nil,
        mark: Constants.Mark.flatMap,
        conforms: nil,
        whereBlock: nil,
        body: loop(size) { transformedIndex in
            let _transformedType = "Transformed\(transformedIndex)"
            let _transformedUnion = makeTransformedUnionDeclaration(size: size, transformedIndex: transformedIndex)
        
            return makeFunction(
                name: "flatMap\(transformedIndex)",
                accessLevel: accessLevel,
                keyword: nil,
                genericArguments: [_transformedType],
                arguments: [.init("_", "transform", "(Item\(transformedIndex)) throws -> \(_transformedUnion)")],
                throws: .rethrows,
                returns: _transformedUnion,
                body: makeSwitchSelfCaseReturn(
                    size: size,
                    shouldUnwrapAssociatedValues: true,
                    returns: { index in
                        return index == transformedIndex
                            ? "try transform(item\(index))"
                            : ".init(item\(index))"
                    }
                )
            )
        }.joinedWithDoubleNewLine()
    )
}

// MARK: Compact Map
func makeCompactMap(
    _ size: Int,
    _ accessLevel: AccessLevel
) -> String {
    return [
        makeUnionProtocolSequenceExtension(size, accessLevel),
        makeUnionProtocol(size, accessLevel),
        makeUnionProtocolConformance(size)
    ].joinedWithDoubleNewLine()
}

func makeUnionProtocolSequenceExtension(
    _ size: Int,
    _ accessLevel: AccessLevel
) -> String {
    return makeExtension(
        for: "Sequence",
        accessLevel: nil,
        mark: Constants.Mark.compactMap,
        conformsTo: nil,
        where: "Element: \(unionProtocolName(size))",
        body: loop(size) {
            makeFunction(
                name: "compactMap\($0)",
                accessLevel: accessLevel,
                keyword: nil,
                genericArguments: nil,
                arguments: [],
                throws: nil,
                returns: "[Element.Item\($0)]",
                body: "return compactMap { $0.item\($0) }"
            )
        }.joinedWithDoubleNewLine()
    )
}

func makeUnionProtocol(
    _ size: Int,
    _ accessLevel: AccessLevel
) -> String {
    return makeProtocol(
        name: unionProtocolName(size),
        accessLevel: accessLevel,
        associatedTypes: loop(size) { "Item\($0)" },
        body: loop(size) { "var item\($0): Item\($0)? { get }" }.joinedWithNewLine()
    )
}

func makeUnionProtocolConformance(
    _ size: Int
) -> String {
    return makeUnionExtension(
        size,
        accessLevel: nil,
        mark: nil,
        conforms: [unionProtocolName(size)],
        whereBlock: nil,
        body: nil
    )
}

// MARK: Equatable
func makeEquatable(
    _ size: Int,
    _ accessLevel: AccessLevel
) -> String {
    return makeUnionExtensionWithAllConforming(
        size,
        accessLevel: nil,
        protocol: "Equatable",
        body: [
            loop(size) { index in
                return makeEquatableFunc(size, accessLevel, index, argumentOrderInverted: false)
            }.joinedWithDoubleNewLine(),
            loop(size) { index in
                return makeEquatableFunc(size, accessLevel, index, argumentOrderInverted: true)
            }.joinedWithDoubleNewLine()
        ].joinedWithDoubleNewLine()
    )
}

func makeEquatableFunc(
    _ size: Int,
    _ accessLevel: AccessLevel,
    _ index: Int,
    argumentOrderInverted: Bool
) -> String {
    var arguments: [FunctionArgument] = [
        .init("_", "union", "Self"),
        .init("_", "item\(index)", "Item\(index)")
    ]
    
    if argumentOrderInverted {
        arguments.reverse()
    }
    
    return makeFunction(
        name: "==",
        accessLevel: accessLevel,
        keyword: .static,
        genericArguments: nil,
        arguments: arguments,
        throws: nil,
        returns: "Bool",
        body: "return union.item\(index) == item\(index)"
    )
}

// MARK: Hashable
func makeHashable(
    _ size: Int
) -> String {
    return makeUnionExtensionWithAllConforming(
        size,
        accessLevel: nil,
        protocol: "Hashable",
        body: nil
    )
}

// MARK: Sendable
func makeSendable(
    _ size: Int
) -> String {
    return makeUnionExtensionWithAllConforming(
        size,
        accessLevel: nil,
        protocol: "Sendable",
        body: nil
    )
}

// MARK: Error
func makeError(
    _ size: Int,
    _ accessLevel: AccessLevel
) -> String {
    return makeUnionExtensionWithAllConforming(
        size,
        accessLevel: nil,
        protocol: "Error",
        body: [
            makeComputedProperty(
                name: "innerError",
                accessLevel: accessLevel,
                type: "Error",
                keyword: nil,
                body: makeSwitchSelfCaseReturn(
                    size: size,
                    shouldUnwrapAssociatedValues: true,
                    returns: { "item\($0)" }
                )
            ),
            makeComputedProperty(
                name: "localizedDescription",
                accessLevel: accessLevel,
                type: "String",
                keyword: nil,
                body: "return innerError.localizedDescription"
            )
        ].joinedWithDoubleNewLine()
    )
}

// MARK: CustomStringConvertible
func makeCustomStringConvertible(
    _ size: Int,
    _ accessLevel: AccessLevel
) -> String {
    let protocolName = "CustomStringConvertible"
    
    return makeUnionExtension(
        size,
        accessLevel: nil,
        mark: protocolName,
        conforms: [protocolName],
        whereBlock: nil,
        body: makeComputedProperty(
            name: "description",
            accessLevel: accessLevel,
            type: "String",
            keyword: nil,
            body: makeSwitchSelfCaseReturn(
                size: size,
                shouldUnwrapAssociatedValues: true,
                returns: { "\"\(unionTypeName(size)).item\($0)(\\(item\($0)))\"" }
            )
        )
    )
}

// MARK: CustomDebugStringConvertible
func makeCustomDebugStringConvertible(
    _ size: Int,
    _ accessLevel: AccessLevel
) -> String {
    let protocolName = "CustomDebugStringConvertible"
    
    return makeUnionExtension(
        size,
        accessLevel: nil,
        mark: protocolName,
        conforms: [protocolName],
        whereBlock: nil,
        body: makeComputedProperty(
            name: "debugDescription",
            accessLevel: accessLevel,
            type: "String",
            keyword: nil,
            body: makeSwitchSelfCaseReturn(
                size: size,
                shouldUnwrapAssociatedValues: true,
                returns: { "\"\(unionTypeName(size)).item\($0)(\\(item\($0)))\"" }
            )
        )
    )
}

// MARK: CaseIterable
func makeCaseIterable(
    _ size: Int,
    _ accessLevel: AccessLevel
) -> String {
    return makeUnionExtensionWithAllConforming(
        size,
        accessLevel: nil,
        protocol: "CaseIterable",
        body: makeComputedProperty(
            name: "allCases",
            accessLevel: accessLevel,
            type: "[Self]",
            keyword: .static,
            body: """
            return \(
                loop(size) {
                    "Item\($0).allCases.map { .init($0) }"
                }.joinedWithPlus()
            )
            """
        )
    )
}

// MARK: Encodable
func makeEncodable(
    _ size: Int,
    _ accessLevel: AccessLevel
) -> String {
    return makeUnionExtensionWithAllConforming(
        size,
        accessLevel: nil,
        extensionProtocol: "Encodable",
        whereProtocols: ["Encodable", "UnionIdentifiable"],
        body: [
            makeFunction(
                name: "encode",
                accessLevel: accessLevel,
                keyword: nil,
                genericArguments: nil,
                arguments: [.init("to", "encoder", "Encoder")],
                throws: .throws,
                returns: nil,
                body: """
                var unionContainer = encoder.container(keyedBy: UnionCodingKey.self)

                try unionContainer.encode(unionTypeID, forKey: .unionTypeID)
                try unionContainer.encode(innerEncodable, forKey: .wrappedValue)
                """
            ),
            makeComputedProperty(
                name: "unionTypeID",
                accessLevel: .private,
                type: "UnionTypeID",
                keyword: nil,
                body: makeSwitchSelfCaseReturn(
                    size: size,
                    shouldUnwrapAssociatedValues: false,
                    returns: { index in
                        return "Item\(index).unionTypeID"
                    }
                )
            ),
            makeComputedProperty(
                name: "innerEncodable",
                accessLevel: .private,
                type: "Encodable",
                keyword: nil,
                body: makeSwitchSelfCaseReturn(
                    size: size,
                    shouldUnwrapAssociatedValues: true,
                    returns: { index in
                        return "item\(index)"
                    }
                )
            )
        ].joinedWithDoubleNewLine()
    )
}

// MARK: Decodable
func makeDecodable(
    _ size: Int,
    _ accessLevel: AccessLevel
) -> String {
    return makeUnionExtensionWithAllConforming(
        size,
        accessLevel: nil,
        extensionProtocol: "Decodable",
        whereProtocols: ["Decodable", "UnionIdentifiable"],
        body: makeInitializer(
            accessLevel: accessLevel,
            arguments: [.init("from", "decoder", "Decoder")],
            throws: .throws,
            body: """
            let unionContainer = try decoder.container(keyedBy: UnionCodingKey.self)

            let unionTypeID = try unionContainer.decode(UnionTypeID.self, forKey: .unionTypeID)
            
            \(
                makeSwitchCaseAssignSelf(
                    size: size,
                    variable: "unionTypeID",
                    makeCase: { "Item\($0).unionTypeID" },
                    makeAssign: { ".item\($0)(try unionContainer.decode(Item\($0).self, forKey: .wrappedValue))" },
                    default: "throw UnionDecodingError.unknownUnionTypeID(unionTypeID)"
                )
            )
            """
        )
    )
}

// MARK: - Shared
func makeUnionShared(
    accessLevel: AccessLevel,
    unionTypeIDType: String,
    unionTypeIDKey: String,
    wrappedValueKey: String
) -> String {
    return [
        makeMark("Shared", hasSeparator: true),
        makeCodable(
            accessLevel: accessLevel,
            unionTypeIDType: unionTypeIDType,
            unionTypeIDKey: unionTypeIDKey,
            wrappedValueKey: wrappedValueKey
        )
    ].joinedWithDoubleNewLine()
}

// MARK: - Codable
func makeCodable(
    accessLevel: AccessLevel,
    unionTypeIDType: String,
    unionTypeIDKey: String,
    wrappedValueKey: String
) -> String {
    return [
        makeMark("Codable", hasSeparator: false),
        makeTypealias(accessLevel, "UnionTypeID", unionTypeIDType),
        makeUnionIdentifiable(accessLevel),
        makeUnionCodingKey(
            unionTypeIDKey: unionTypeIDKey,
            wrappedValueKey: wrappedValueKey
        ),
        makeUnionDecodingError(accessLevel)
    ].joinedWithDoubleNewLine()
}

func makeUnionIdentifiable(
    _ accessLevel: AccessLevel
) -> String {
    return makeProtocol(
        name: "UnionIdentifiable",
        accessLevel: accessLevel,
        associatedTypes: nil,
        body: "static var unionTypeID: UnionTypeID { get }"
    )
}

func makeUnionCodingKey(
    unionTypeIDKey: String,
    wrappedValueKey: String
) -> String {
    return makeStruct(
        name: "UnionCodingKey",
        accessLevel: .private,
        conformsTo: ["CodingKey"],
        body: """
        var stringValue: String
        init?(stringValue: String) { self.stringValue = stringValue }

        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }

        static let unionTypeID = UnionCodingKey(stringValue: "\(unionTypeIDKey)")!
        static let wrappedValue = UnionCodingKey(stringValue: "\(wrappedValueKey)")!
        """
    )
}

func makeUnionDecodingError(
    _ accessLevel: AccessLevel
) -> String {
    return makeEnum(
        name: "UnionDecodingError",
        accessLevel: accessLevel,
        genericArguments: nil,
        conformsTo: ["Error"],
        cases: ["unknownUnionTypeID(UnionTypeID)"]
    )
}

// MARK: - Utils

// MARK: Type Names
func unionTypeName(_ size: Int) -> String {
    return "Union\(size)"
}

func unionProtocolName(_ size: Int) -> String {
    return "Union\(size)Protocol"
}

// MARK: Switch-Case
func makeSwitchSelfCaseReturn(
    size: Int,
    shouldUnwrapAssociatedValues: Bool,
    returns: (Int) -> String
) -> String {
    return makeSwitchCaseReturn(
        variable: "self",
        cases: loop(size) { index in
            let _associatedValue = shouldUnwrapAssociatedValues ? "(let item\(index))" : ""

            return (
                ".item\(index)\(_associatedValue)",
                returns(index)
            )
        },
        default: nil
    )
}

func makeSwitchCaseAssignSelf(
    size: Int,
    variable: String,
    makeCase: (Int) -> String,
    makeAssign: (Int) -> String,
    `default`: String?
) -> String {
    return makeSwitchCaseAssignSelf(
        variable: variable,
        cases: loop(size) { index in
            (
                makeCase(index),
                makeAssign(index)
            )
        },
        default: `default`
    )
}

// MARK: Extensions
func makeUnionExtension(
    _ size: Int,
    accessLevel: AccessLevel?,
    mark: String?,
    conforms: [String]?,
    whereBlock: String?,
    body: String?
) -> String {
    return makeExtension(
        for: unionTypeName(size),
        accessLevel: accessLevel,
        mark: mark,
        conformsTo: conforms,
        where: whereBlock,
        body: body
    )
}

func makeUnionExtensionWithAllConforming(
    _ size: Int,
    accessLevel: AccessLevel?,
    extensionProtocol: String,
    whereProtocols: [String],
    body: String?
) -> String {
    return makeUnionExtension(
        size,
        accessLevel: accessLevel,
        mark: extensionProtocol,
        conforms: [extensionProtocol],
        whereBlock: makeAllWrappedTypesConforming(
            size,
            to: makeCombinedProtocolDeclaration(whereProtocols)
        ),
        body: body
    )
}

func makeAllWrappedTypesConforming(
    _ size: Int,
    to protocol: String
) -> String {
    return loop(size) {
        "Item\($0): \(`protocol`)"
    }.joinedWithComma()
}

func makeUnionExtensionWithAllConforming(
    _ size: Int,
    accessLevel: AccessLevel?,
    protocol: String,
    body: String?
) -> String {
    return makeUnionExtensionWithAllConforming(
        size,
        accessLevel: accessLevel,
        extensionProtocol: `protocol`,
        whereProtocols: [`protocol`],
        body: body
    )
}

// MARK: - Constants
enum Constants {
    enum Framework {
        static let foundation = "Foundation"
    }

    enum Mark {
        static let initializers = "Initializers"
        static let getters = "Getters"
        static let setters = "Setters"
        static let map = "Map"
        static let flatMap = "Flat Map"
        static let compactMap = "Compact Map"
    }
}

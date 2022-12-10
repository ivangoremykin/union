//
//  CodeGeneration.swift
//  UnionExample
//
//  Created by Ivan Goremykin on 04/10/2022.
//

import Foundation

// MARK: - Types
public enum AccessLevel: String {
    case `open`
    case `public`
    case `internal`
    case `private`
    case `fileprivate`
}

public struct FunctionArgument {
    let label: String?
    let name: String
    let type: String
    
    public init(
        _ name: String,
        _ type: String
    ) {
        self.label = nil
        self.name = name
        self.type = type
    }
    
    public init(
        _ label: String,
        _ name: String,
        _ type: String
    ) {
        self.label = label
        self.name = name
        self.type = type
    }
}

public enum FunctionKeyword: String {
    case `static`
    case `class`
    case `mutating`
}

public enum Throws: String {
    case `throws`
    case `rethrows`
}

public enum ComputedPropertyKeyword: String {
    case `static`
}

// MARK: - Expressions
public func makeMark(
    _ name: String,
    hasSeparator: Bool
) -> String {
    return "// MARK: \(hasSeparator ? "- " : "")\(name)"
}

public func makeErrorCompilerDiagnosticDirective(
    _ message: String
) -> String {
    return "#error(\"\(message)\")"
}

public func makeUnknownTemplateParameterValueError<T>(
    parameter: String,
    value: T
) -> String {
    return makeErrorCompilerDiagnosticDirective(
        "Unknown value \\\"\(value)\\\" for template parameter \\\"\(parameter)\\\""
    )
}

public func makeTypealias(
    _ accessLevel: AccessLevel?,
    _ left: String,
    _ right: String
) -> String {
    let _accessLevel = makeAccessLevelDeclaration(accessLevel)

    return "\(_accessLevel)typealias \(left) = \(right)"
}

public func makeImportsDeclaration(
    _ imports: [String]
) -> String {
    return imports
        .map { "import \($0)" }
        .joinedWithNewLine()
}

public func makeExpression(
    header: String,
    body: String?,
    shouldTabulateBody: Bool = true
) -> String {
    return [
        "\(header) {",
        body.map { shouldTabulateBody ? tab($0) : $0 },
        "}"
    ].compactMap { $0 }.joinedWithNewLine()
}

public func makeAccessLevelDeclaration(_ accessLevel: AccessLevel?) -> String {
    guard let accessLevel = accessLevel else { return "" }
    
    return accessLevel == .internal
        ? ""
        : spacePostfixOrEmpty(accessLevel.rawValue)
}

private func makeFunctionArgumentListDeclaration(_ arguments: [FunctionArgument]) -> String {
    return arguments
        .map(makeFunctionArgumentDeclaration)
        .joinedWithComma()
        .enclosedByParentheses()
}

private func makeFunctionArgumentDeclaration(_ argument: FunctionArgument) -> String {
    return [
        argument.label,
        "\(argument.name): \(argument.type)"
    ].compactMap { $0 }.joinedWithSpace()
}

private func makeThrowsDeclaration(_ `throws`: Throws?) -> String {
    return spacePrefixOrEmpty(`throws`?.rawValue)
}

public func makeGenericArgumentsDeclaration(_ genericArguments: [String]?) -> String {
    guard let genericArguments = genericArguments, !genericArguments.isEmpty else { return "" }

    return genericArguments
            .joinedWithComma()
            .enclosedByAngleBrackets()
}

private func makeKeywordDeclaration<Keyword: RawRepresentable>(
    _ keyword: Keyword?
) -> String where Keyword.RawValue == String {
    return spacePostfixOrEmpty(keyword?.rawValue)
}

private func makeProtocolConformanceDeclaration(_ protocols: [String]?) -> String {
    guard let protocols = protocols, !protocols.isEmpty else { return "" }

    return ": " + protocols.joinedWithAmpersand()
}

private func makeWhereDeclaration(_ where: String?) -> String {
    return spacePrefixOrEmpty(`where`.map { "where \($0)" })
}

public func makeCombinedProtocolDeclaration(_ protocols: [String]) -> String {
    return protocols.joinedWithAmpersand()
}

// MARK: - Contents of First-class Objects

// MARK: Initializer
public func makeInitializer(
    accessLevel: AccessLevel?,
    arguments: [FunctionArgument],
    `throws`: Throws?,
    body: String
) -> String {
    let _accessLevel = makeAccessLevelDeclaration(accessLevel)
    let _arguments = makeFunctionArgumentListDeclaration(arguments)
    let _throws = makeThrowsDeclaration(`throws`)
    
    return makeExpression(
        header: "\(_accessLevel)init\(_arguments)\(_throws)",
        body: body
    )
}

// MARK: Computed Property
public func makeComputedProperty(
    name: String,
    accessLevel: AccessLevel?,
    type: String,
    keyword: ComputedPropertyKeyword?,
    body: String
) -> String {
    let _accessLevel = makeAccessLevelDeclaration(accessLevel)
    let _keyword = makeKeywordDeclaration(keyword)

    return makeExpression(
        header: "\(_accessLevel)\(_keyword)var \(name): \(type)",
        body: body
    )
}

// MARK: Extension
public func makeExtension(
    for typeName: String,
    accessLevel: AccessLevel?,
    mark: String?,
    conformsTo protocols: [String]?,
    `where`: String?,
    body: String?
) -> String {
    let _accessLevel = makeAccessLevelDeclaration(accessLevel)
    let _protocols = makeProtocolConformanceDeclaration(protocols)
    let _where = makeWhereDeclaration(`where`)
    
    return [
        mark.map { makeMark($0, hasSeparator: false) },
        makeExpression(
            header: "\(_accessLevel)extension \(typeName)\(_protocols)\(_where)",
            body: body
        )
    ].compactMap { $0 }.joinedWithNewLine()
}

// MARK: Switch-Case
public func makeSwitchCase(
    variable: String,
    cases: [(`case`: String, body: String)],
    `default`: String?
) -> String {
    let _cases = cases.map { tuple in
        [
            "case \(tuple.`case`):",
            tab(tuple.body)
        ].joinedWithNewLine()
    }
    
    let _default = `default`.map {
        [
            "default:",
            tab($0)
        ].joinedWithNewLine()
    }

    let body = (
        _cases + [_default].compactMap { $0 }
    ).joinedWithDoubleNewLine()
    
    return makeExpression(
        header: "switch \(variable)",
        body: body,
        shouldTabulateBody: false
    )
}

public func makeSwitchCaseReturn(
    variable: String,
    cases: [(`case`: String, `return`: String)],
    `default`: String?
) -> String {
    return makeSwitchCase(
        variable: variable,
        cases: cases.map { tuple in (tuple.0, "return \(tuple.1)") },
        default: `default`
    )
}

public func makeSwitchCaseAssignSelf(
    variable: String,
    cases: [(`case`: String, assignSelf: String)],
    `default`: String?
) -> String {
    return makeSwitchCase(
        variable: variable,
        cases: cases.map { tuple in (tuple.0, "self = \(tuple.1)") },
        default: `default`
    )
}

// MARK: - First-class Objects

// MARK: Protocol
public func makeProtocol(
    name: String,
    accessLevel: AccessLevel?,
    associatedTypes: [String]?,
    body: String
) -> String {
    let _accessLevel = makeAccessLevelDeclaration(accessLevel)
    let _associatedTypes = makeAssociatedTypes(associatedTypes)
    
    return makeExpression(
        header: "\(_accessLevel)protocol \(name)",
        body: [_associatedTypes, body]
            .compactMap { $0 }
            .joinedWithDoubleNewLine()
    )
}

private func makeAssociatedTypes(
    _ associatedTypes: [String]?
) -> String? {
    guard let associatedTypes = associatedTypes, !associatedTypes.isEmpty else { return nil }
    
    return associatedTypes
        .map { "associatedtype \($0)" }
        .joinedWithNewLine()
}

// MARK: Function
public func makeFunction(
    name: String,
    accessLevel: AccessLevel?,
    keyword: FunctionKeyword?,
    genericArguments: [String]?,
    arguments: [FunctionArgument],
    `throws`: Throws?,
    returns: String?,
    body: String
) -> String {
    let _accessLevel = makeAccessLevelDeclaration(accessLevel)
    let _keyword = makeKeywordDeclaration(keyword)
    let _genericArguments = makeGenericArgumentsDeclaration(genericArguments)
    let _arguments = makeFunctionArgumentListDeclaration(arguments)
    let _throws = makeThrowsDeclaration(`throws`)
    let _return = makeReturnDeclaration(returns)

    return makeExpression(
        header: "\(_accessLevel)\(_keyword)func \(name)\(_genericArguments)\(_arguments)\(_throws)\(_return)",
        body: body
    )
}

private func makeReturnDeclaration(_ returns: String?) -> String {
    guard let returns = returns else { return "" }

    return " -> \(returns)"
}

// MARK: Enum
public func makeEnum(
    name: String,
    accessLevel: AccessLevel?,
    genericArguments: [String]?,
    conformsTo protocols: [String]?,
    cases: [String]
) -> String {
    let _accessLevel = makeAccessLevelDeclaration(accessLevel)
    let _genericArguments = makeGenericArgumentsDeclaration(genericArguments)
    let _protocols = makeProtocolConformanceDeclaration(protocols)
    
    return makeExpression(
        header: "\(_accessLevel)enum \(name)\(_genericArguments)\(_protocols)",
        body: cases.map { "case \($0)" }.joinedWithNewLine()
    )
}

// MARK: Struct
public func makeStruct(
    name: String,
    accessLevel: AccessLevel?,
    conformsTo protocols: [String]?,
    body: String
) -> String {
    let _accessLevel = makeAccessLevelDeclaration(accessLevel)
    let _protocols = makeProtocolConformanceDeclaration(protocols)
    
    return makeExpression(
        header: "\(_accessLevel)struct \(name)\(_protocols)",
        body: body
    )
}

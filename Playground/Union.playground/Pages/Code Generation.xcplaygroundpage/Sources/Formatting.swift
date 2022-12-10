//
//  Formatting.swift
//  UnionExample
//
//  Created by Ivan Goremykin on 04/10/2022.
//

import Foundation

// MARK: - Join
public extension Array where Element == String {
    func joinedWithSpace() -> String {
        return joined(separator: " ")
    }

    func joinedWithNewLine() -> String {
        return joined(separator: "\n")
    }

    func joinedWithDoubleNewLine() -> String {
        return joined(separator: "\n\n")
    }
    
    func joinedWithComma() -> String {
        return joined(separator: ", ")
    }
    
    func joinedWithPlus() -> String {
        return joined(separator: " + ")
    }
    
    func joinedWithAmpersand() -> String {
        return joined(separator: " & ")
    }
    
    func joinedWithCommaAndNewLine() -> String {
        return joined(separator: ",\n")
    }
}

// MARK: - Enclosing
public extension String {
    func enclosedBy(
        _ left: String,
        _ right: String
    ) -> String {
        return "\(left)\(self)\(right)"
    }

    func enclosedByParentheses() -> String {
        return enclosedBy("(", ")")
    }

    func enclosedBySquareBrackets() -> String {
        return enclosedBy("[", "]")
    }

    func enclosedByCurlyBrackets() -> String {
        return enclosedBy("{", "}")
    }

    func enclosedByAngleBrackets() -> String {
        return enclosedBy("<", ">")
    }
}

// MARK: - Repetition
public func loop<T>(
    _ size: Int,
    _ transform: (Int) -> T
) -> [T] {
    return loop(from: 0, size: size, transform)
}

public func loop<T>(
    from: Int,
    size: Int,
    _ transform: (Int) -> T
) -> [T] {
    return Array(from..<size).map(transform)
}

// MARK: - Replacement
public func tab(
    _ string: String
) -> String {
    let tabulation = String(repeating: " ", count: 4)

    return tabulation + string.replacingOccurrences(
        of: "\n",
        with: "\n\(tabulation)"
    )
}

public func spacePrefixOrEmpty(
    _ string: String?
) -> String {
    if let string = string {
        return " \(string)"
    }
    
    return ""
}

public func spacePostfixOrEmpty(
    _ string: String?
) -> String {
    if let string = string {
        return "\(string) "
    }
    
    return ""
}

// MARK: - Text Case
public enum TextCase: String {
    case camel
    case kebab
    case pascal
    case snake
}

extension String {
    public func formatted(withCase textCase: TextCase) -> String {
        switch textCase {
        case .camel:
            return formattedWithCamelCase()

        case .kebab:
            return formattedWithKebabCase()

        case .pascal:
            return formattedWithPascalCase()

        case .snake:
            return formattedWithSnakeCase()
        }
    }

    private func formattedWithCamelCase() -> String {
        return formatted(
            uppercasingFirst: false,
            uppercasingRest: true,
            separator: ""
        )
    }

    private func formattedWithKebabCase() -> String {
        return formatted(
            uppercasingFirst: false,
            uppercasingRest: false,
            separator: "-"
        )
    }

    private func formattedWithPascalCase() -> String {
        return formatted(
            uppercasingFirst: true,
            uppercasingRest: true,
            separator: ""
        )
    }

    private func formattedWithSnakeCase() -> String {
        return formatted(
            uppercasingFirst: false,
            uppercasingRest: false,
            separator: "_"
        )
    }
    
    private func formatted(
        uppercasingFirst: Bool,
        uppercasingRest: Bool,
        separator: String
    ) -> String {
        guard !isEmpty else { return "" }
        
        let parts = components(separatedBy: .alphanumerics.inverted)
        
        guard let first = parts.first else { return "" }
        let rest = parts.dropFirst()
        
        let _first = uppercasingFirst ? first.uppercasingFirst : first.lowercasingFirst
        let _rest = rest.map { uppercasingRest ? $0.uppercasingFirst : $0.lowercasingFirst }
        
        return ([_first] + _rest).joined(separator: separator)
    }
}

// MARK: - Capitalization
public extension String {
    var lowercasingFirst: String { prefix(1).lowercased() + dropFirst() }
    var uppercasingFirst: String { prefix(1).uppercased() + dropFirst() }
}

/*:
 An example for an article [Adding Union to Swift with Metaprogramming](https://dev.to/ivangoremykin/adding-union-to-swift-with-metaprogramming-510d-temp-slug-2422196).
 
[Table of Contents](Table%20of%20Contents) · [Previous](@previous) · [Next](@next)
****
# Generating a Union
*/
// Generic parameters
let unionSize = 9
let accessLevel = "public"

// Codable parameters
let unionTypeIDType = "String"
let unionTypeIDKey = "type"
let wrappedValueKey = "value"

print(
    makeUnionSource(
        unionSize: unionSize,
        accessLevel: accessLevel,
        unionTypeIDType: unionTypeIDType,
        unionTypeIDKey: unionTypeIDKey,
        wrappedValueKey: wrappedValueKey
    )
)

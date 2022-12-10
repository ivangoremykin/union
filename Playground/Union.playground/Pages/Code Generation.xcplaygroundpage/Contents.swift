/*:
 An example from an article [Adding Union to Swift with Metaprogramming](https://dev.to/ivangoremykin/adding-union-to-swift-with-metaprogramming-510d-temp-slug-2422196?preview=2a0e6b0e13a54f8e81bdf0b3ebda509fea745fbfdab1f59387125d102de27974ffd01ccc7221c38ca39e5719b544d952883627daa299376c05c022cc).
 
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

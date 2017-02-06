//: [Previous](@previous)

import UIKit
/*:
***************************************

### TOPIC 3: Optionals

If you cannot pre-determine a variable at startup, you can make a variable **optional**.

Such variables are actually enumerated types (Swift has quite advanved enumerated types - we will meet these later)
*/
var dayBabyIsBorn : Int?    //THIS IS NOT AN `Int`, but of type `Optional` - it is said to "wrap" an `Int` inside an enumerated type

//: When ready, we can assign this variable
dayBabyIsBorn = 28

//: When we try to access the value, you can *force upwrap* it using the pling `!`
let day : Int = dayBabyIsBorn!

/*:
*Question* - What happens when you remove the exclaimation mark?

*Question* - What happens when you don't initialise dayBabyIsBorn?

* Forced unwrapping of nil will result in a run-time crash.

* Forced unwrapping is best avoided where possible unless you are very sure it is safe to do so.

The force-unwrap operator is a pling `!` - this usually represents danger. The same applies to Swift code.
*If you are looking for a run-time crash in your code, look for the `!` operators*

A safer alternative - "nil coalescing operator": unwrap if not `nil`, otherwise set to a literal or another non-optional variable.
*/
let d : Int = dayBabyIsBorn ?? 0

//: This is fine when it makes sense to have an alternative value, but this is not always the case.
//: Even better / more generic, use `if let` - this tests the value for nil before unwrapping.
if let dy = dayBabyIsBorn {
   
   //: This ONLY runs if dayBabyIsBorn can be safely unwrapped (once the baby has been born presumably!)
   print("Day baby is born is \(dy)th of the month")
}

//: You can achieve the same this way (not as nice) as an optional without a value can be compared to nil
if dayBabyIsBorn != nil {
   print("Day baby is born is \(dayBabyIsBorn!)th of the month")
}


//: ### Implicitly unwrapped optionals

/*:
There are some use-cases where a variable needs to be optional, but where we know it becomes initialised and is always safe to use.
An example is an Outlet, where at run-time it is hooked up to an object in memory by the nib loading mechansim.
The point at which we, the developers can access the outlets, they are already hooked up.

In such cases, you can use implicitly wrapped variables to make code look prettier, but it's not just about prettyness.
The absence of a `!` operator means this is probably not code responsible for a run-time error.
*/

var petWeight : Double!     //This is an optional

//: petWeight is assigned a value at some point before we access it code
petWeight = 3.5

//: It is therefore to safe access it. You do not need the ! to unwrap
let w : Double = petWeight
print("w = \(w)")

//: **Be warned** - do not use implicitly unwrapped optionals unless you are very sure they fit this use-case.
//:
//: *Question* - comment out the line that initialises petWeight with 3.5 - what happens?

//: ### Optional chaining

/*:
Consider the tasks of converting a string into a Double.

One of the dangers is that the string is not a properly formatted number - so how should a conversion function communicate this?

Optionals are often returned from functions that can potentially fail.

I am going to use the class `NSNumberFormatter` - don't worry about the details of this.
* It has a method called `numberFromString()` which returns an optional (wrapped instance of the `NSNumber` class)
* If a conversion can be done, a wrapped instance of `NSNumber` object is returned.
* NSNumber has a method `doubleValue()` to convert to a Double.

*/

let strCandidate1 = "1.2345"    //This can convert
let strCandidate2 = "ten"       //This cannot

//: The value I will store in is an optional type - this is because it might be `nil` (indicating a failure to convert)
var dblVal : Double?

//: First time, all is well - note the `?` in the next line
dblVal = NumberFormatter().number(from: strCandidate1)?.doubleValue
if let v = dblVal {
   //dbVal can be unwrapped and copied into v
   print("The number is \(v)")
}

/*:
If `numberFromString()` cannot perform the conversion, a `nil` is returned. Let's look at this now.

Consider the case `let strCandidate2 = "ten"`. A string is not a valid number - the evaluation gets as far as `NSNumberFormatter().numberFromString(strCandidate2)`
*/
dblVal = NumberFormatter().number(from: strCandidate2)?.doubleValue

//: The `?` above tells the compiler to only continue evauation if the result can be safely unwrapped, otherwise stop processing.
//:
//: We now conditionally unwrap using `if let`
if let v = dblVal {
   //: dblVal cannot be unwrapped - so this code never runs
   print("The number is \(v)")
}
//: Note that nothing was output as the return value of numberFromString cannot be safely unwrapped.



//: [Next](@next)

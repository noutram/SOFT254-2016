//: [Previous](@previous)

import UIKit

/*:

### TOPIC 1: Mutables and Immutables

Variable declaration - one with `var`, another with `let`

`var` is **mutable** (variable)

`let` is **immutable** (constant)

*/

var str1 : String = "Hello, playground"
let str2 : String = "Hello, playground"

//: Try uncommenting the following two lines - can you predict which will work?
//str1 = str1 + "!"
//str2 = str2 + "!"

print("string 1: \(str1)")
print("string 1: \(str2)")

//: Note also that the operator + has been overloaded to join strings...which is nice.

//: ### TOPIC 2: Initialisation
//: For safely, *variables cannot be used until they are initialised*.

//: This variable is strongly typed, but uninitialised
var age : Int

//: *Question* What do you think will happen if you uncomment this line?
//let y = age

//: *Experiment* Now initialise age (e.g. `var age : Int = 20`) and try again

/*:
This is a safety feature. Using variables before they are initialised can result in bugs that are hard to track down. We will have more to say about initialisation when we look at structures and classes.

Initialisation is not limited to literals. You can also initialise variables with an expression, such as the following example
*/

var year = 2015
var msg : String = String(format: "Age is %d", year)

//: Variable and constant initialisation can be deferred
var nextYear : Int
nextYear = 2016

/*:
*Experiment* - change nextYear to a constant with `let` - what happens (if anything)?

**Note** : In Swift 2, you can now defer initialisation of **both** variables and constants. This was previously limited to varibles in Swift 1.
*/


//: [Next](@next)

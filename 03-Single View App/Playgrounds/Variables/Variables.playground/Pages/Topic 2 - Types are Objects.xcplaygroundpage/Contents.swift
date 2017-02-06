//: [Previous](@previous)

import UIKit

//: ### TOPIC 2: Types are Objects

let p : Double = 10.1234567890123

//: Try uncommenting this line
//var fVal : Float = p

/*:
You cannot simply equate variables of different types. The next line creates a new Float with `p` passed to it's constructor.

(Yes, all datatypes are objects and they have constructors!)
*/
var fVal : Float = Float(p)             //This will create a float (and loose precision of course)
var iVal : Int = Int(floor(p + 0.5))    //This performs a round then a conversion

/*:
Note how data types are objects. Don't worry about this having any impact on the perforamance of compiled code.
You can trust the compiler to optimise this.

It's not just constructors. There are properties as well. Some properties are backed by storage. Others might be computed at run time.
For a simple string representation, you can use the *computed property* description:
*/
let strNum = "The number is " + p.description + "."
print(" \(strNum)")

//: This one is useful. String has an initialiser that takes a C-like format string
var strNumber = String(format: "%4.1f", p);
print("The number rounded down is \(strNumber)")

/*:
You can even add your own functions using Swift "extensions" (getting ahead of myself here).
As everything is an object, then with Swift we can extend it!

Constant `p` is of type `Double` (a struct) - we can extend the object Double to include a new method
*/
extension Double {
   func asSinglePrecisionString() -> String {
      let strOfNumber = String(format: "%4.1f", self)
      return strOfNumber
   }
}

//: Now apply this function
let strOfP = p.asSinglePrecisionString()




//: [Next](@next)

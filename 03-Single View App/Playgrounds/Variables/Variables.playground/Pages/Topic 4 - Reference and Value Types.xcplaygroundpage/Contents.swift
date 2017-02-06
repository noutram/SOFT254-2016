//: [Previous](@previous)

import UIKit
//: ### TOPIC 4: Reference and Value Types

//: We are familiar with value-type semantics when working with simple data types. For example:
var fred : Int = 10
var jim : Int = fred
jim = jim + 1
//: The variable `jim` is an independent copy - so changes to `jim` will not impact on `fred`
if (fred == jim) {
   print("These must be the same object");
} else {
   print("These must be indepdnent objects");
}

//: Let's now look at a **Swift Array**
var arrayOfStrings : [String] = ["Mars", "Jupiter", "Earth"]
var arrayOfMoreStrings : [String] = arrayOfStrings          //This will perform a (mutable) deep copy (see **footnote)

//: We can compare them (later, we discuss protocols and types of objects that are Equatable)
if (arrayOfStrings == arrayOfMoreStrings) {
   print("These arrays are identical in content")
} else {
   print("These arrays are different")
}
//: Let's add one more the second array
arrayOfMoreStrings.append("Naboo")

//: Compare
arrayOfStrings
arrayOfMoreStrings
if (arrayOfStrings == arrayOfMoreStrings) {
   print("These arrays are still identical in content")
} else {
   print("These arrays are now different")
}

//: **footnote** - for efficiency, a copy is only actually made if one of the arrays is modified - read up on "copy on write" if you are curious

/*:
The key point to note is how they are independent. This is because Swift arrays are *value types*. Structures and enumerated types are value types.

Instances of classes, classes, functions and closures are said to be *reference types*. C and C++ programmers might think of these as pointers.

Let's now compare this with *class* `NSArray`. ObjectiveC developers will know this class well. Note: An instance of a class is always a *reference type*. `NSArray` is a class that contains a orded list of objects.
*/
var xx : NSMutableArray = NSMutableArray(arrayLiteral: 10, "Freddy", 20.0)

//: Now, let's equate this to another
var yy : NSMutableArray = xx

//: First - by content
if (xx == yy) {
   print("These arrays are identical in content")
} else {
   print("These arrays are different")
}

//: Second - *we can also compare the references* themselves using the `===` operator
if (xx === yy) {
   print("These variables reference the exact same object")
} else {
   print("These variables reference different objects")
}

//: Mutate the contents of `yy`, but don't (progamatically) change `xx`
yy[0] = 99

//: Let's compare again, first - by content using the `==` operator
if (xx == yy) {
   print("These arrays are identical in content")
} else {
   print("These arrays are different")
}

//: Second - we can also comare the references themselves using the `===` operator (note the additional `=` character)
if (xx === yy) {
   print("These variables reference the exact same object")
} else {
   print("These variables reference different objects")
}

//: We see **both** are modified. This demonstrates reference-type semantics. This is expected as `NSArray` is a class.
//:
//: Now I create an independent array that happens to have the same content
var zz : NSMutableArray = NSMutableArray(arrayLiteral: 99, "Freddy", 20.0)
if (xx == zz) {
   print("These arrays are identical in content")
} else {
   print("These arrays are different")
}
if (xx === zz) {
   print("These variables reference the exact same object")
} else {
   print("These variables reference different objects")
}
//: This time, == indicates the content is the same, but === indicates these are indepednent references.
//:
//: Problems might occur when reading code, and where you are unsure whether an object is a reference type or value type.
//: It might be an idea to use a naming convention for reference objects?


//: ### Examples of some additional value types

//: Tuples - grouping data together. Great for returning multiple data from functions, but not only.
let guitar : (Int, String) = (69, "Stratocaster")
let (yr, model): (Int, String) = guitar

let axes : (String, String, String) = ("Red Special", "Brian May", "Homemade")
let (name,owner,manu) = axes
name
owner
manu
//: More on Tuples and pattern matching later.


//: Dictionaries (or hashmaps for Java developers) have a nice syntax and are strongly typed
let instruments : [String : Int] = ["69 Stratocaster" : 4000, "74 LesPaul" : 2200]

//: However, *looking up key-value pairs in a dictionary can fail*, so a dictionary always returns an **optional**
if let fCost = instruments["69 Stratocaster"] {
   print("69 Fender costs est. \(fCost) USD")
}
if let gCost = instruments["74 LesPaul"] {
   print("74 Gibson Les Paul cost est. \(gCost) USD")
}
if let briCost = instruments["RedSpecial"] {
   print("Red Special valued at £\(briCost) GBP")
} else {
   print("That guitar is not for sale")
}

//: Closing point - just to get you thinking.... Functions are also types!
func add( v1 : Int, v2 : Int ) -> Int {
   return v1 + v2
}
func mul( v1 : Int, v2 : Int ) -> Int {
   return v1 * v2
}

var fn : (Int, Int) -> Int = add

//: Enough of that for now :o)

//: [Next](@next)

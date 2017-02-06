//: [Previous](@previous)
import UIKit
import PlaygroundSupport
//: ![Closures](Banner.jpg)

//: ## Type Interence
//: One of the motivations to use closures (as opposed to functions) is type-inference. This allows closure expressions to be concise, and often written in-place, thus keeping related code together.

//: ### Interring return type with assignment
//: Type inference can be obtained in a number of ways

//: For the assignment operator `=`, we say:
//:
//:    expression = value
//:
//: The expression can infer type from the value, *or the other way around*.

//:Consider the following closure
let tm = { () -> String in
   let date = Date()
   let fmt = DateFormatter()
   fmt.dateFormat = "h:mm a"
   return fmt.string(from: date)
}

//: Here the type of expression `tm` is inferred from the closure type. In this case, it is `() -> String`.
type(of: tm)
//: We can evaluate and see the output (type `String`).
tm()
//: Equally, the value type can be inferred from the type of the *expression* (left hand side).
let tm2 : () -> String  = {
   let date = Date()
   let fmt = DateFormatter()
   fmt.dateFormat = "h:mm a"
   return fmt.string(from: date)
}
//: Note how there is no need to specify the closure parameter or return type in the closure.
type(of: tm2)
//: Contrast this with the following example.
//: * **note** the parenthesis on the end
let theTimeNow : String  = {
   let date = Date()
   let fmt = DateFormatter()
   fmt.dateFormat = "h:mm a"
   return fmt.string(from: date)
}()

type(of: theTimeNow)
//: The return type here is `String` as the closure is evaluated in place.
//: This technique is very useful for initialisation of constants and variables
//:
//: **EXPERIMENT** Try removing the `String` type from the declaration of `theTimeNow`

//: ### Void
//: Remember `Void` is a data type.

//: ### Example - no parameters
let c1 = { (_ : Void) -> Void in
   print("This has no parameters", separator: "", terminator: "")
}
//: `(_ : Void)` can be expressed as `()`
let c2 = { () -> Void in
   print("This has no parameters", separator: "", terminator: "")
}
//: The return type `Void` can also be expressed as `()`
let c3 = { () in ()
   print("This has no parameters", separator: "")
}
//: For now return type, you can just drop `in ()` as it will be inferred.
let c4 = { ()
   print("This has no parameters", separator: "")
}
//: For empty parameters, simply drop the `()` as it will be again inferred.
let c5 = {
   print("This has no parameters", separator: "", terminator: "")
}
//: Written on one line 
let c6 = { print("This has no parameters", separator: "", terminator: "") }

//: These are all equivalent
c1
c2
c3
c4
c5

//: Note the use of empty parenthesis - no mention of `Void` etc.

//: ### Inferring type from the code statements

//: Consider this simple closure
let area = { (r : Double) -> Double in
   return 3.14*r*r
}

//: Swift is a type-safe language. Given 3.1415926541 is a Double, then so must r.
//: Therefore, the compiler can infer the type for both the parameters and return type.
let area2 = { 3.14*$0*$0 }

//: ### Interring type from *context*
//: Closures are first-class types and can be used both as parameters and return types. Sometimes they are parameters of a method called on an object (class, structure etc..).
//: In many cases, the compiler can again infer type information from the *context*.

//: #### Function Parameters
//: Higher order functions and closures can have parameters of any type, including a closure.
//: We have already met this with the higher order functions `map`, `filter` and `reduce`.

//: **Example** - Distance between points
//: I shall once again write a function to calculate the distance between
//: two 2D points using different metrics for distance. I try to avoid code replication
//: by writing the common code in a higher-order function, and passing in the specific
//: functionality via a parameter.

//: To make the code cleaner, I shall use `typealias` and create
//: a new type for a 2D point called `Point2D`. This type is a Tuple. I've used labels
//: to also make the code more self-explanitory.
typealias Point2D = (x: Double, y: Double)    //Type Point is a tuple (with labels)

//: Now I create another new type `DistanceMetric`. This type takes a point argument and returns a `Double`. By default this would be the distance from the origin (0,0).
typealias DistanceMetric = (Point2D) -> Double

//: Previously I wrote some functions for different distance metrics, measuring the distance of a 2D point from the origin (0,0).

//Euclidean Distance (based on Pythagoras theorem) from the origin (0,0)
func euclidean(p : Point2D) -> Double {
   return sqrt(p.x*p.x + p.y*p.y)
}

//Maximum distance from the origin (0,0)
func maxAbsolute(p : Point2D) -> Double {
   return max(fabs(p.x) , fabs(p.y))
}

//: The following **higher-order function** calculates the 'distance' *between* two points using a provided `DistanceMetric`. Note that this function contains the common code for the different methods used. Note the third *and last* parameter is a function / closure. It returns a `Double`, which ultimately represents the distance between the points p1 and p2
func distanceBetween(point : Point2D,  andPoint p2 : Point2D, usingMetric metric : DistanceMetric) -> Double {
   
   //The following three lines are common to many distance measures
   let dx = p1.x - p2.x        //Difference between x coordinates
   let dy = p1.y - p2.y        //Difference between y coordinates
   let delta = (x: dx, y: dy)  //Wrap in a tuple (with labelled elements)
   
   //: It is the next line that enables this function to implment  different distance metrics
   let distance = metric(delta)//Apply provided distance metric
   
   return distance
}

//: Ok, as before, let's test using a couple points
let p1 : Point2D = (x: 1.0, y: 5.0)           //Point in 2D
let p2 : Point2D = (x: 2.0, y: 3.0)           //And again

//: Calculate using two different distance metrics - as we did in the playground on Functions.
distanceBetween(point: p1, andPoint: p2, usingMetric: euclidean)
distanceBetween(point: p1, andPoint: p2, usingMetric: maxAbsolute)

//: #### Now with closures.
//:
//: **Note**: `euclidean` and `maxAbsolute` are simple functions, so I can write them in-place without making the code too complex.
distanceBetween(point: p1, andPoint: p2, usingMetric: { (p : Point2D)-> Double in
   return sqrt(p.x*p.x + p.y*p.y)
})
//: Now we can simplify.

//: #### Inferred return rule
//: For a single statement closure, you can drop the `return`
distanceBetween(point: p1, andPoint: p2, usingMetric: { (p : Point2D)-> Double in
   sqrt(p.x*p.x + p.y*p.y)
})

//: #### Using parameter type inference and shorthand notation
//: The higher order function `distanceBetweenPoint` already tells the compiler the parameter types. Therefore we can use the **shorthand notation** and let the compiler infer the type
distanceBetween(point: p1, andPoint: p2, usingMetric: { sqrt($0.x*$0.x + $0.y*$0.y) })
//: where $0 is the first (and only) parameter.

//: #### Trailing Closures
//: Note that the *last* parameter of the higher-order function is the closure. Where this is the case, we can use *trailing closure syntax* to make it more readable
distanceBetween(point: p1, andPoint: p2){ sqrt($0.x*$0.x + $0.y*$0.y) }
//: or if you prefer
distanceBetween(point: p1, andPoint: p2){
   sqrt($0.x*$0.x + $0.y*$0.y)
}
//: Note how the last parameter is no longer labelled or included in the parenthesis list.

//: This seems to work with shorthand parameter names as well:
distanceBetween(point: p1, andPoint: p2) {
   sqrt($0*$0 + $1*$1)
}
//: (where $0 is the first tuple element, and $1 the second).

//: #### Comment
//: A real benefit here is that it is easy to write different closures, in a very compact form, to adapt the behaviour of a higher order function, thus *the code is kept together*. This can help readibility and maintainance. It does assume the reader is confident with closure syntax of course, and can understand the type inference. In the next example, a different distance metric is used.
distanceBetween(point: p1, andPoint: p2) { max(fabs($0.x) , fabs($0.y)) }
//: With practise, this becomes quick and easy to read (at least for simple examples).

//: ### Further Examples from the Swift Standard Library
//: The above shows how a closure can not only be passed as a parameter to another higher-order function, but also defined in place. We see this used with higher order functions in the standard library, such as `sort`, `map`, `filter` and `reduce`

//: #### Example - `sort`
//: In this example, I used the Swift standard library `sort` function. This is a higher-order function that allows custom sorting behaviour of data in an array.

//: Start with some integer values
let arrayOfNumbers = [1, 15, -5, 10, 22]

//: Calculate the mean *(maybe you now understand this code?)*
let sum = arrayOfNumbers.reduce(0, {$0 + $1})     //Sum all elements in the array
let fMean = Double(sum) / Double(arrayOfNumbers.count)     //Divide to obtain arithmetic mean

//: Now sort to find the values closest to the mean. Again, I am using the *trailing closure* syntax to make this more readable.
let sortedArray = arrayOfNumbers.sorted(){
   let da = fabs(Double($0)-fMean)     //capture fMean
   let db = fabs(Double($1)-fMean)
   return da < db
}
//: Almost everything about this particular is written in one place. We could even use this to initiaise a variable or constant. I know I keep mentioning this, but it helps as code scales.

//: #### Example - `map`
//: The standard library higher-order function `map` applies a function to all elements of an array. In this simple example, I determine if an element is *even* (true) or *odd* (false)
arrayOfNumbers.map( { (u : Int) -> Bool in
   return (u % 2) == 0
})

//: We only have a single statement, so drop the return
arrayOfNumbers.map( { (u : Int) -> Bool in
   (u % 2) == 0
})

//: Generic method `map` operates on `Array<Int>`, so expects the closure to take an `Int` as a parameter. We can therefore infer the type of `u`
arrayOfNumbers.map( { u -> Bool in
   (u % 2) == 0
})

//: It is clear from the closure statements that a `Bool` is returned. We can therefore infer and drop the return type
arrayOfNumbers.map( { u in
   (u % 2) == 0
})

//: Given the parameter and return type are known, we can use shorthand parameters instead
arrayOfNumbers.map( {
   ($0 % 2) == 0
})

//: Write on one line
arrayOfNumbers.map( { ($0 % 2) == 0 })

//: Use a trailing closure
let evens = arrayOfNumbers.map(){ ($0 % 2) == 0 }
evens
//: As long as you can read the syntax, this is very concise while still being expressive.

//: #### Example - `filter`
//: The standard library higher-order function `filter` applies a function to all elements of a collection to test if that element should be retained in the result. In this simple example, I determine if an element is positive or zero.
let positives = arrayOfNumbers.filter({$0>=0})
positives
//: Note the value `-5` is absent from the final result.

//: #### Example - `reduce`
//: The standard library higher-order function `reduce` recursively applies a function to itself and each element of a collection. For example, assume the result of reduce to be `a`. Then for each element x of the array, `a <- f(a,x)`.
//:
//: A common example is to sum all elements of the array.
//:
//: * Paramember `a` is the **cumulative result**
//: * Paramember `b` is the next value from the array
//: * In effect, this will result in `a = a + b`
func f1(a : Int, _ b : Int) -> Int {
   return a+b
}

//: Rather than pass in f1,we can simply write a closure
let sumOfAllElements = arrayOfNumbers.reduce(0, {$0+$1})
sumOfAllElements
//: or even this (See next section for a discussion)
arrayOfNumbers.reduce(0, +)

//: ### Even more simplification - function name (including operator functions)
//: As demonstrated above, you can sometimes simplify even further. 
//: For a given function, where its type is known, Swift allows you to simply pass in the function name.

//: Create some angles (in radians)
let radians = Array(0...359).map({M_PI * Double($0) / 180.0})
//: Where it can be inferred, you don't even need shorthand parameters
let yy = radians.map(sin)
//: To see the output, view the timeline
for yval in yy {
   yval
}

//: As we saw earlier, this also works with operator functions
let truths = [true, false, false, true]

//: We could perform the logical NOT function on these Bool types
let opposites = truths.map({ !$0 })
opposites

//: **You can simplify even further**
truths.map(!)

//: **Remember** The operator function `!` is just that, *a function*, which has type `Bool->Bool`. 
//: This is also the type of the `map` parameter. We've just travelled full-circle back to passing functions as parameters.
//:
//: In simple terms, we are simply passing in a function as opposed to a closure (which is why we no longer have the `{ }`
//: A closure is surrounded by `{ }` where as a function has a name.

//: Another simple example - negate
let negated = arrayOfNumbers.map(-)

//: This custom unary operator squares a number
protocol CanMultiply {
   static func * (u : Self, v : Self)->Self
}

//: Extend Int and Double so they now conform to this protocol
extension Int    : CanMultiply {}
extension Double : CanMultiply {}
//: (We will discuss extensions later)

//: Declare and define the operator
postfix operator ^^
postfix func^^<U:CanMultiply>(u : U) -> U {
   return u*u
}
4^^

//: Pass operator to map
let squaredInt = arrayOfNumbers.map(^^)
let squaredDbl = arrayOfNumbers.map({Double($0)}).map(^^)
//: Of course, if you read this code in isolation, it is not obvious what ^^ actually does.


//: ## Solution to Lecture Tasks
//: Using type-inference, simplify the following closures as far as you can

//: **TASK**
//: This is the higher order function
func performSomething(_ a : Int, _ b : Int, fn : (Int, Int)->Int ) -> String {
   let result = fn(a,b)
   let strResult = "fn(\(a),\(b)) = \(result)"
   return strResult
}
//: Pass this closure to the higher order function in-place
let f : (Int,Int)->Int = { (a : Int, b : Int) -> Int in
   let y = a*a + b*b
   return y
}
//: Test with 2,3 and a closure that is equivalent to `f`. Expected output is shown.
performSomething(2, 3, fn: f)

//: Solution
//: * single statement - implicit return
//: * type inference from the higher order function
//: * short-hand parameter names
//: * trailing closure
let strRes = performSomething(2, 3){$0*$0+$1*$1}
strRes

//: **TASK**
let t2 : (String,Bool)->String = { (name : String, hasPHD : Bool) -> String in
   if (hasPHD == true) {
      return "Dr. " + name
   } else {
      return name
   }
}
t2("Seuss", true)
t2("Spock", false)

//: Solution (one possible solution)
//:
//: * The type is on both sides of the assignment. It is only needed on one side
//: * The code statements can be written on one line using ?
let sol2  = { $1 == true ? "Dr. " + $0 : $0 }
sol2("Seuss", true)
sol2("Spock", false)
//: **note** it seems the `$1 == true` is needed. Simply writing `$1` did not seem to compile. I have queried this via bugreport.apple.com
//: [Next](@next)



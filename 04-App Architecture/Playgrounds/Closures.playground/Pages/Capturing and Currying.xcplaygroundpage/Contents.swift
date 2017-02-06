//: [Previous](@previous)

import UIKit
import PlaygroundSupport
//: ![Closures](Banner.jpg)

//: ## Capturing and Currying

//: The same rule apply for capturing as with nested functions.

//: ### Capturing from enclosing scope - parameters and locals

typealias DoubleTransform = (Double) -> Double

//: This closure encasulates the captured variable `sum`
let acc = { ( s : Double) -> DoubleTransform in
   // Return the single-parameter closure - The `return` could be dropped of course
   var sum = s
   return {
      sum += $0   // Closure captures variable sum
      return sum  
   }
}(5.0)

acc(2.0)
acc(5.0)
let y = acc(8.0)
//: As you can infer by observation, the captured `sum` persists because accumulator persists

//: ### Currying
//:
//: Any closure with `N` parameters can be broken down into `N` closures with 1 parameter.
//: This follows a process of "capture and return", just as we did with functions.

typealias IntTx = (Int) -> Int    //Function type that takes an Int parameter, and returns an Int

//: Outer closure provides the first argument - this is captured by the next level of nesting
let curried = {( num1 : Int) ->  IntTx in
   {$0 + num1} // Captures num1, implicit return
}

//: Invoke with first parameter, then pass second parameter to the returned function
curried(10)(20)

//: Again, useful when you need a closure of a particular type
//: Here is the same example used in the Functions playground and lecture podcast
let tx = curried(100)
//: `tx` is a Function that has captured `num1=100`, and accepts a single parameter. For example:
tx(10)
//: Now consider the higher-order function `map`.
//: Applied to an array of type `[Int]`, it accepts a function of type `Int->U`, where 'U' is a generic type and represents the type of data in the result.
//: A key point here is that `tx` is now a function with **one** `Int` parameter as a result of currying. Therefore it can be passed as a parameter to `map`.
let arrayOfInt = [1, 5, 10]
let res = arrayOfInt.map(tx)
//: Looking at the result, each element has 100 added to it. The return
//: 

//: Another example - calculating times-tables using a single for-loop.
//:
//: First, without simplification
let symbols = Array<Int>(1...12)
for x in symbols {
   let mul = { (a : Int) -> Int in
      return a*x  //Capture x
   }
   let row = symbols.map(mul)
//: uncomment the line below to see the results in the timeline (can be slow)
   //XCPlaygroundPage.currentPage.captureValue(row, withIdentifier: "x " + String(x))
}
//: Here is a compact way
let tables = symbols.map(){ (row : Int) -> [Int] in
   symbols.map(){$0 * row}
}
//: Of course, we can do the same with two for-loops, but this is much more concise. You may prefer two for-loops of course.

//: #### Example used in the Functions lecture
typealias T1 = (Double) -> Double
typealias T2 = (Double) -> T1

//: The original function used
func f1(_ m : Double) -> T2 {
   func f2(_ x : Double) -> T1 {
      let prod = m*x
      func f3(_ c : Double) -> Double {
         return prod+c
      }
      return f3
   }
   return f2
}

//: Example for 10*2 + 5
f1(10)
f1(10)(2)
f1(10)(2)(5)

//: Now convert directly to closure syntax
let c1 = { (m : Double)-> T2 in
   let c2 = { (x : Double) -> T1 in
      let prod = m*x
      let c3 = { (c : Double) -> Double in
         return prod+c
      }
      return c3
   }
   return c2
}

//: Confirm the results and types are the same
c1(10)
c1(10)(2)
c1(10)(2)(5)

//: We can simplify of course
//:
//: Starting with inferred returns
//let c1 = { (_ m : Double)-> T2 in
//   { (_ x : Double) -> T1 in
//      { (_ c : Double) -> Double in m*x+c }
//   }
//}
//:
//: Now the return types - these can be inferred
//let c1 = { (_ m : Double) in
//   { (_ x : Double) in
//      { (_ c : Double) in m*x+c }
//   }
//}
//:
//: Shorthand notation can be used on the most inner function
//let c1 = { (_ m : Double) in
//   { (x : Double) in
//      { m*x+$0 }
//   }
//}
//:
//: Parameter types can be inferred.
//: Remember - because this is a type-strict language, only a Double can be multiplied with a Double, so the type of x is implied given the type of m is known
//let c2 = { (_ m : Double) in
//   { x in
//      { m*x+$0 }
//   }
//}

//: We can now write on one line.
let c2 = { (_ m : Double) in { x in { m*x+$0 } } }

c2(10)
c2(10)(2)
c2(10)(2)(5)

//: I will leave you with the following thought to discuss with your peers. Consider the simplified closure expressions given above. *If this was not your code*, is it clear what these closures do? 

//: (If you only use your own source code, you may assume that your own code might as well be someone elses after 6 months :o)

//: [Next](@next)

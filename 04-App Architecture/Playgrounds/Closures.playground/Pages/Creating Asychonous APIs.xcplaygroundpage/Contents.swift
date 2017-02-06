//: [Previous](@previous)

import UIKit
import PlaygroundSupport
//: ![Closures](Banner.jpg)

//: ## Creating an Asychronous API
//:
//: To make like simpler for the developer, let's create a second version of the hill-climb function that
//: provides an asychonrous call-back **on the main thread**.

//: The following is needed to allow the execution of the playground to continue beyond the scope of the higher-order function.
PlaygroundPage.current.needsIndefiniteExecution = true


let deg2rad = { $0*M_PI/180.0 }
let rad2deg = { $0 * 180.0 / M_PI }

//: ### Create asychronous API
//: This call-back function is passed as the last parameter. This parameter is a function with one parameter.
//: The objective of the higher order function is to iterate "up hill" to find the nearest peak
typealias SOLN = (x: Double, y : Double)
func hillClimbWithInitialValue(_ xx : Double, 𝛌 : Double, maxIterations: Int, fn : @escaping (Double)->Double, completion: @escaping (SOLN?)->Void) {
   var x0 = xx
   //Encapsualte code in a parameterless closure
   let P1 = {
      
      func estimateSlope(_ x : Double) -> Double {
         let 𝛅 = 1e-6
         let 𝛅2 = 2*𝛅
         return ( fn(x+𝛅)-fn(x-𝛅) ) / 𝛅2
      }
      
      var slope = estimateSlope(x0)
      var iteration = 0
      
      while (fabs(slope) > 1e-6) && (iteration < maxIterations) {
         
         //For a positive slope, increase x
         x0 += 𝛌 * slope
         
         //Update the gradient estimate
         slope = estimateSlope(x0)
         
         //Update count
         iteration += 1
      }
      
      //Create an Operation to perform a callback passing the result as a parameter
      let P2 = {
         //Capture iteration and maxIterations
         if iteration < maxIterations {
            //Capture x0 and fn(x0)
            let res = ( x:x0, y:fn(x0) )
            //Pass back result
            completion( res )
         } else {
            //Did not converge
            completion( nil )
         }
         //This is to stop the playground running indefinately
         PlaygroundPage.current.finishExecution()
      }
      
      //Perform call back on main thread
      OperationQueue.main.addOperation(P2)   //P2 will be a copy
      
   } //end of closure

   //Perform operation on seperate thread
   OperationQueue().addOperation(P1)
}

//: ### Invoke asychronous function
//: The developer now has a simpler task.

//: First, define two closures:
//: * The function being searched
let fcn : (Double)->Double = { sin($0) }
//: * A callback closure (which is performed in the runloop of the main thread)
let complete = { (solution : SOLN?) -> Void in
   print("Completed: \(NSDate())", separator: "", terminator: "")

   if let s = solution {
      print("Peak of value \(s.y) found at x=\(rad2deg(s.x)) degrees", separator: "", terminator: "")
   } else {
      print("Did not converge", terminator: "")
   }
}
//: Invoke
hillClimbWithInitialValue(0.1, 𝛌: 0.01, maxIterations: 10000, fn: fcn, completion: complete)
print("Started: \(NSDate())", separator: "", terminator: "")
//: Look at the times - you can see the call-back has occured after the start, and that the duration is significant (in the order of seconds). Note this is likely to be somewhat different for a Playground, but the principle is the same. Network transactions can be much longer.


//: [Next](@next)

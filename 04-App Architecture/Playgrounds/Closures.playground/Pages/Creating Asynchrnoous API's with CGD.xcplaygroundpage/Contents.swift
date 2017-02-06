//: [Previous](@previous)

import UIKit
import PlaygroundSupport
//: ![Closures](Banner.jpg)

//: ## Creating an Asychronous API with GCD
//:

//: The following is needed to allow the execution of the playground to continue beyond the scope of the higher-order function.
PlaygroundPage.current.needsIndefiniteExecution = true


let deg2rad = { $0*M_PI/180.0 }
let rad2deg = { $0 * 180.0 / M_PI }


//: #### Grand Central Dispatch (alternative)
//: While we are on the subject of multi-threaded code, `NSOperationQueue` is built on a lower-level technology, *Grand Central Dispatch* (GCD). This is commonly used, so it is worth highlighting.

//: Let's return to the original synchronous function
func synchronousHillClimbWithInitialValue(_ xx : Double, 𝛌 : Double, maxIterations: Int, fn : @escaping (Double) -> Double ) -> (x: Double, y : Double)? {
   var x0 = xx
   func estimateSlope(_ x : Double) -> Double {
      let 𝛅 = 1e-6
      let 𝛅2 = 2*𝛅
      return ( fn(x+𝛅)-fn(x-𝛅) ) / 𝛅2
   }
   
   var slope = estimateSlope(x0)
   var iteration = 0
   while (fabs(slope) > 1e-6) {
      
      //For a positive slope, increase x
      x0 += 𝛌 * slope
      
      //Update the gradient estimate
      slope = estimateSlope(x0)
      
      //Update count
      iteration += 1
      
      if iteration == maxIterations {
         return nil
      }
   }
   
   return (x:x0, y:fn(x0))
}

//: Create / obtain a queue (separate thread) where all tasks can run concurrently
//let q = dispatch_queue_create("calc", DISPATCH_QUEUE_CONCURRENT)   //Creates a new queue
let q = DispatchQueue.global(qos: .default)   //Use an existing (from the global pool)
//: Dispatch the task on the queue
q.async {
   //Call the (computationally intensive) function
   let solution = synchronousHillClimbWithInitialValue(0.01, 𝛌: 0.01, maxIterations: 10000, fn: sin)
   //: * Perform call-back on main thread. Again, the code is a parameterless trailing-closure.
   DispatchQueue.main.sync {
      if let s = solution {
         print("GCD: Peak of value \(s.y) found at x=\(rad2deg(s.x)) degrees", separator: "")
      } else {
         print("GCD: Did not converge")
      }
      //This next line is just to stop the Playground Executing forever
      PlaygroundPage.current.finishExecution()
   }
}

//: A difficulty with such asychronous APIs is *managing state*, i.e. keeping track of what tasks have completed, including cases where operations may have been unsuccessful.
//:
//: You can think of the asychrounous callbacks as events posted into a run-loop. Different threads of execution can have their own run-loop (read up on `NSThread`  and the Concurrency Programming Guide if you are curious).

//: Often, callbacks are *posted* on the runloop for the *main thread* making them much like an `Action` (e.g. tapping a `UIButton`). There are challenges in managing code that uses a lot of asychrnous APIs. I the *breadcrumbs' app (to follow), I am going too show you one that I tend to use: *finite state machines*.


//: [Next](@next)


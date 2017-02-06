//: [Previous](@previous)
import UIKit
import PlaygroundSupport
//: ![Closures](Banner.jpg)

//: ## Sychronous and Asychronous callbacks
//: An increasing number of APIs are higher-order functions, and in some cases perform asychronous call backs.
//: This is used particularly where execution may block or take a significant amount of time, such as
//: a network transaction, a write to flash memory storage or a computationally extensive algorithm.
//: Sometimes it is a simpler and concise aternative to the delegation pattern.
//: It is common place to use a (often trailing) closure when invoking such APIs to keep code together in a single context.
let deg2rad = { $0*M_PI/180.0 }
let rad2deg = { $0 * 180.0 / M_PI }

//: ### Synchronous call-back
//: In this example, a closure is listed as the last parameter of a higher-order function. This parameter is a closure with one parameter.
//: The objective of the higher order function is to iterate "up hill" to find the nearest peak (see lecture for details).

func hillClimbWithInitialValue(_ x0 : Double, 𝛌 : Double, maxIterations: Int, fn : @escaping (Double) -> Double ) -> (x: Double, y : Double)? {
   
   var x0 = x0
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

//: Evaluate (performs a gradient search) - **note** this can take quite a few iterations, and hence time,
//: so I've capped the iterations at 1000. On the main thread, this might be problematic as it can degrade
//: the user experience.
let peak = hillClimbWithInitialValue(0.0, 𝛌: 0.1, maxIterations: 1000){
   sin($0)
}

//: Report result
if let p = peak {
   print("Peak of value \(p.y) found at \(rad2deg(p.x)) degrees",separator: "")
} else {
   print("Did not converge")
}

//: ### Run on a seperate thread
//: For a more precise answer, this algorithm will take too much time on the main thread.
//: We can use the foundation classes `OperationQueue` and `BlockOperation` to run the function on another thread.
//: *Note* for those interested in concurrency - the function shares no mutable state (no globals or `inout` parameters) and to help prevent races, all parameters are value types (indepednent copies) except for the call-back (which is a reference type)

//: The following is needed to allow the execution of the playground to continue beyond the scope of the higher-order function.
PlaygroundPage.current.needsIndefiniteExecution = true

//: Create a `BlockOperation` - the higher-order initialiser function takes a single parameters - a parameterless function of type `()->Void`
//:
//: Note the use of a trailing closures to keep the code neater. This is possible because the closure is always the last parameter.
let P = BlockOperation(){
   //Invoke the function on a thread other than the main
   let res = hillClimbWithInitialValue(0.0, 𝛌: 0.01, maxIterations: 10000){sin($0) }
   //Once complete, create another operation only this time on the main thread. Some functions and UI updates
   //should only be done on the main thread.
   let Qres = BlockOperation(){
      if let p = res {
         print("Peak of value \(p.y) found at \(rad2deg(p.x)) degrees",separator: "")
         let deg = rad2deg(p.x)
         deg
         p.y
      } else {
         print("Did not converge")
      }
   }
   OperationQueue.main.addOperation(Qres)
}

//: Create a queue (on another thread)
let Q = OperationQueue()
//: Add the operation to that queue (it will run automatically)
Q.addOperation(P)

//: ### Creating an asychonous API
//: Wouldn't it be better if developer did not have to worry about threads. This is where a run-loop really helps simplify the design of safe asynchronous APIs.
//: On the next page we will do just this.


//: [Next](@next)

//: ![Closures - Programming Examples](Banner.jpg)

import UIKit
//: # Closure Syntax
//: ## From the Lecture "Closures"
//:
//: For Xcode 8
//:
//: First created 7th December 2015
//: Updated Nov 2016

//: ## Closure Syntax and Type Inference"

//:[The Swift Programming Language (Closures)]: https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Closures.html#//apple_ref/doc/uid/TP40014097-CH11-ID94 "Open in Browser"
//:
//:For more information, see the chapter on Automatic Reference Counting in [The Swift Programming Language (Closures)].

//: ### First example - convert a function to a closure

func divide(numerator n : Int, denominator d: Int) -> Double? {
   if (d == 0) {
      return nil
   } else {
      let y = Double(n) / Double(d)
      return y
   }
}

//: Note again, the parameters are all explicitly labelled.
let divide_closure = { (n : Int, d: Int) -> Double? in
   if (d == 0) {
      return nil
   } else {
      let y = Double(n) / Double(d)
      return y
   }
}

//: The `{` now marks the start of the closure. Use `in` to separate the parameters from the code statements

//: Evaluate as you would a function (a function is a closure with a name)
divide_closure(12, 3)

//: The type is the same as the function `(Int,Int)->Double?`. In fact you can interrogate the type (handy tip!)
type(of: divide_closure)

//: Where the code is not reused, you can use in-place evaluation. Note how the closures is both defined and invoked in one place. **Useful for initialisation** of variables and constants
let y  = { (n : Int, d: Int) -> Double? in
      if (d == 0) {
         return nil
      } else {
         let y = Double(n) / Double(d)
         return y
      }
}(12, 3)
//: (Note also that the type of `y` is inferred, which is the same as the function return type `Double?`)


//: ### Example - with explicit internal and external parameter names

//: All parameters labelled
func cuboidVolume(width w:Double, height h:Double, depth d:Double) -> Double {
   return w * h * d
}

//: Now the closure equivalent. Note it has the same *type* as the function, but no function name
//:
//: Closures do not have default exernal labels. The rule is the same for ALL parameters: you must specify explicitly.
let cuboidVolumeClosure = { (w : Double, h: Double, d: Double) -> Double in
   return w*h*d
}
cuboidVolumeClosure(2.0,3.0,4.0)

//: They have the same type - to prove it, we can add both to a typed array
typealias threeDVolume = ( (_ width:Double, _ height:Double, _ depth:Double) -> Double)
var closureArray : [threeDVolume] = []
closureArray.append(cuboidVolume)
closureArray.append(cuboidVolumeClosure)
//: Given there are no syntax errors here, they must be the same type.

//: One of the reasons to use closures is that it can be written in-place (within some context), such as in a parameter list of a function
closureArray.append({ (w : Double, h: Double, d: Double) in return w*h*d} )
//: One of the additional benefits is that closure syntax can often be greatly simplified to keep the code concise. This will be explained later, but for example:

//: * As this has a single statement, so we can drop the return
closureArray.append({ (w : Double, h: Double, d: Double) in w*h*d} )
//: * Given that we have some typed-context (the typed array), the compiler can inter the types of the parameters
closureArray.append({$0*$1*$2})
//: Creating an array of closures might seem strange, but again, we treat closure/function types like any other. To prove it works, we can evaluate as follows:
if let c = closureArray.last {
   c(2.0, 3.0, 4.0)
}
//: More concisely
closureArray.last?(2.0, 3.0, 4.0)

//: ### Example - no external parameter names
func cuboidVolumeWHD(_ width:Double, _ height:Double, _ depth:Double) -> Double {
   return width * height * depth
}
//: For the closure, you don't get external parameter labels unless you specify them - *no need to supress parameter labels*
let cuboidVolumeWHDClosure = {(width:Double, height:Double, depth:Double) -> Double in
   return width*height*depth
}
cuboidVolumeWHD(2.0, 3.0, 4.0) - cuboidVolumeWHDClosure(2.0,3.0,4.0)
//: Once again, we can greatly shorten the closure expression

//: * There is only one line, so the return can be dropped. The type is inferred
let cuboidVolumeWHDClosure2 = {(width:Double, height:Double, depth:Double) -> Double in width*height*depth }
cuboidVolumeWHD(2.0, 3.0, 4.0) - cuboidVolumeWHDClosure2(2.0, 3.0, 4.0)
   
//: * If the constant is typed, then the parameter types can be inferred from the context. In this case, we can use shorthand notation: $0 for parameter 0, $1 for parameter 1 etc..
let cuboidVolumeWHDClosure3 : (Double,Double,Double)->Double = { $0*$1*$2 }
cuboidVolumeWHD(2.0, 3.0, 4.0) - cuboidVolumeWHDClosure3(2.0,3.0,4.0)

//: Again, note the function type is the same
closureArray.append(cuboidVolumeWHD)
closureArray.append(cuboidVolumeWHDClosure)

//: Another way to inspect type
type(of: cuboidVolume)
type(of: cuboidVolumeWHD)

//: ## Solution to tasks in lecture

//: Convert the following function to a closure
func vol(width w:Double, height h:Double, depth d:Double) -> Double {
   return w * h * d
}
//: Solution
/// *Note that parameter labels in closures are no longer valid*
let vol1 = { (w:Double, h:Double, d:Double) -> Double in
   return w * h * d
}
//: Test
vol(width: 2.0, height: 3.0, depth: 4.0) - vol1(2.0, 3.0, 4.0)

//: Convert the following to a closure
func cuboidVolumeWithDimensions(_ w:Double, _ h:Double, _ d:Double) -> Double {
   return w * h * d
}

//: Solution
let vol2 = { (w:Double, h:Double, d:Double) -> Double in
   return w * h * d
}

//: Test
vol2(2.0,3.0,4.0) - cuboidVolumeWithDimensions(2.0,3.0,4.0)

//: [Next](@next)





//: ![Functions 1 - Programming Examples](Banner.jpg)

import UIKit
//: # Functions - 1 Programming Examples
//: ## From the Lecture "Functions 1"
//:
//: For Xcode 8
//:
//: Updated 19th November 2015 Xcode 7 support
//:
//: Updated 24th November 2016 Xcode 8 support
//:
//: ## Function Syntax and Parameter Labelling"
//:
//: ### Example - with explicit internal and external parameter names

//: Note how the external names are more *verbose*, allowing the internal names to be concise
func cuboidVolume(width w:Double, height h:Double, depth d:Double) -> Double {
   return w * h * d
}

//: Note how only the external names are visible when calling the function
let V1 = cuboidVolume(width: 2.0, height: 3.0, depth: 10.0)


//: ### Example - no explicit external parameter names provided
func cuboidVolumeWithWidth(width:Double, height:Double, depth:Double) -> Double {
   return width * height * depth
}

//: Note the following:
//:   * The first parameter label is no longer embedded in the function name, but in the first label
//:   * The remain parameters are automatically labelled (same as the intenal names)
let V2 = cuboidVolume(width: 2.0, height: 3.0, depth: 10.0)

//: ### Example - no external parameter names
func cuboidVolumeWHD(_ width:Double, _ height:Double, _ depth:Double) -> Double {
   return width * height * depth
}

//: Note that no external labels are present. Given the *mathematical* ordering is unimportant, you can argue that external labels are redundant? Your choice.
let V3 = cuboidVolumeWHD(2.0, 3.0, 10.0)


//: Single parameter example where an external label is not required
func piAsStringWithPrecision(_ decimalPlaces : Int) -> String {
   let p = Double(M_PI)
   let formatString = "%." + String(decimalPlaces) + "f"
   return String(format: formatString, p)
}

//: The following invokation is quite readable
piAsStringWithPrecision(2)

//: ## Review 1

//: ### Review 1a - no external parameter names
func force1a(_ mass : Double, _ acceleration : Double) -> Double {
   return mass * acceleration
}
//: I don't like this style. Although the mathematical ordering does not matter in this case, that may not clear to the developer invoking this method
let f1a = force1a(10.0, 2.0)


//: ### Review 1b - external parameter names
func force1b(mass m : Double, acceleration a : Double) -> Double {
   return m * a
}
let f1b = force1b(mass: 10.0, acceleration: 2.0)
//: Although verbose, this is very explicit
//: 
//: I could have written this slightly differently
func force1b_alt(mass m : Double, acceleration : Double) -> Double {
   return m * acceleration
}
let f1b_alt = force1b(mass: 10.0, acceleration: 2.0)
//: ### Review 1c - parameter 1 in the name, external parameter name for second
func forceForMass(_ m : Double, withAcceleration a: Double) -> Double {
   return m * a
}
let f1c = forceForMass(10.0, withAcceleration: 2.0)
//: I have chosen to use an explicit second parameter name here. This is to make the invokation read like natural language. If you did not do this, and used the same as the parameter name, that's ok.



//: ### Example - no parameters

//: Note the use of empty parenthesis - no mention of "void" etc.
func timeNow(_: Void) -> String {
   
    let date = Date()
    let fmt = DateFormatter()
    fmt.dateFormat = "h:mm a"
    let desc = fmt.string(from: date)
    
    return desc
}

let t = timeNow()
print("The time is \(t)", terminator:"")

//: ### Experiment - using Void (if you insist!)
//: Void is actually a type, and thus needs to be treated as such.
//: *Try changing the function parameters to Void*

//: You can use `return` to make an early return
func displayTimeWithFormat(formatString : String) {
    if (formatString.isEmpty) {
        return
    }
    let date = Date()
    let fmt = DateFormatter()
    fmt.dateFormat = formatString
    let desc = fmt.string(from: date)
    print("\(desc)", terminator:"")
}

displayTimeWithFormat(formatString: "d MMMM YYYY")



//: [Next](@next)





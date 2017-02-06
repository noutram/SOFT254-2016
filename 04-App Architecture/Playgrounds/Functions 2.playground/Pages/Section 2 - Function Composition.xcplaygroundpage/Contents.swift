//: [Previous](@previous)
import UIKit
import PlaygroundSupport

//: ![Functions Part 2](banner.png)

//: # Functions Part 2 - Section 2 - Functional Programming Examples
//: Version 3 - updated for Swift 3
//:
//: For Xcode 8
//:
//: Updated 24th November 2016
//:
//: This playground is designed to support the materials of the lecure "Functions 2".

//: In this playground, I am going to build up a simple example of functional programming. We will meet first class functions, function types, Currying and function composition.

//: ## Define types
//: To make the code much easier to follow, it is common to define type alias. `Point2D` is a Tulpe where as `Transform2D` is a function. Remember, don't think of functions as a simply function pointer (esp. you C programmers out there!). Think of it more as an object, where the data are 'captured' and copied or referenced within, and where the functions can operate on that data. You might say it's rather like an instance of a class.

typealias Point2D = (x: Double, y: Double)  //2D point in a Tuple
typealias Transform2D = (Point2D) -> Point2D  //Function type

//: ## Create transforms
//: These are functions that return other (nested) functions. A few key points here:
//: * The type of all __returned__ functions are purposely identical `Point2D->Point2D`, that is, accepts a single Point2D input, and returns a single Point2D output. I call this type `Transform2D` as they all transform a Point2D from one location to another.
//: * These functions accept different types. These are the parameters intended to be 'captured' by the nested functions which are subsequently returned.

//: ### Translate point (addition)
//:
//: The nested functions captures `offset`, an additional Point2D (2D vector) used in subsequent calculations.
//: As the `offset` parameter is not mutated outside the nested function, then a copy is said to be captured.
//: Note that *it is the nested **function** that is returned*. This function takes a 2D Point as a parameter and returns a new point. It uses the *captured* `offset` to perform the calculation.

func translate(_ offset: Point2D) -> Transform2D {
   func tx(_ point: Point2D) -> Point2D {
      //Capture offset
      let off = offset
      //Calculate and return new point
      return (x: point.x + off.x, y: point.y + off.y)
   }
   
   return tx
}

//: ![Translate function](translate.png)

//: ### Scale
//:
//: Scale both elements by a common scalar (stretch radially)
//:
//: Again, the nested function captures a copy of the scaling factor provided by the enslosing scope.

func scaleTransform(_ scale: Double) -> Transform2D {
   
   func tx(_ point: Point2D) -> Point2D {
      let s = scale
      return (x: point.x * s, y: point.y * s)
   }
   
   return tx
}

//: ![Scale function](scale.png)

//: ### Rotate about the origin.
//:
//: Note a slight difference here.
//: * The generating outer function is passed the angle of rotation as a parameter
//: * I've chosen to precalculate cos and sin functions needed for rotations. I've done this as I plan to apply this function multiple times and don't want to keep recalculating them.
//: * Is `cos_ø` and `sin_ø` that are captured by the nested function and returned.

func rotate(_ angleInDegrees: Double) -> Transform2D {
   let π = M_PI
   let radians = π * angleInDegrees / 180.0
   let cos_ø = cos(radians)
   let sin_ø = sin(radians)
   
   // The transform is a rotation
   func rotate (_ point : Point2D) -> Point2D {
      //cos_ø and sin_ø are 'captured' inside this closure
      let newX =  cos_ø * point.x + sin_ø * point.y
      let newY = -sin_ø * point.x + cos_ø * point.y
      return (x: newX, y: newY)
   }
   return rotate
}

//: If I had only planned to perform a single rotation, I might have done this differently and calculated `cos_ø` and `sin_ø` within the nested function. This was the expensive `cos` and `sin` functions would only be performed if/when actually needed (lazily).

//: ![Rotate about the origin function](rotate.png)
//:

//: ### Negate
//:
//: Used later in the advanced task.
//:
func negate(_ p: Point2D) -> Point2D {
   let minus_p = (x: -p.x, y: -p.y)
   return minus_p
}


//: ## Function composition
//:
//: ![Compose function](compose.png)
//:
//: The objective here is to make function composition behave rather like a UNIX pipe. Functions are performed left to right, with the output of each providing the input to the next
//:
//: Where two functions are to be applied, one to the output of the other, then we can create a higher-order function to perform this for us.
//:
func composeTransform(_ f1: @escaping Transform2D, _ f2: @escaping Transform2D) -> Transform2D {
   func tx(_ point: Point2D) -> Point2D {
      return f2(f1(point))
   }
   return tx
}

//: ### To make it resemble a UNIX pipe, I've created a custom operator |-> . Note the associativity is critcal
//:

infix operator |-> : AdditionPrecedence
func |-> (f1: @escaping Transform2D, f2: @escaping Transform2D) -> Transform2D {
   func tx(_ point: Point2D) -> Point2D {
      return f2(f1(point))
   }
   return tx
}

//: ## Testing

//: ### Test 1 - first apply individual transforms

//: Constants
let offset = (x: 50.0, y: 50.0)
let scale = 2.0
let rotation = -90.0

//: Generate the functions, capturing the parameters provided
let translate1 = translate(offset)
let scale1 = scaleTransform(scale)
let rotate1 = rotate(rotation)

//: Test point
let p1 : Point2D = (x: 20.0, y: 20.0)

//: Calculate the position after each transform
let p2 = translate1(p1)
let p3 = scale1(p2)
let p4 = rotate1(p3)

//: Dictionary of points (Label : Coordinate) used for plotting
let points1 = ["A" : p1, "B" : p2, "C" : p3, "D" : p4]

//: Plot each point on a 2D graph
//Wrapper function around PlotView initialiser
let f = CGRect(x: 0.0, y: 0.0, width: 400.0, height: 400.0) //Common to all
func PlotViewWithPoints(_ p : [String : Point2D]) -> UIView {
   return PlotView(frame: f, points: p)    //Capture f
}
let plot1 = PlotViewWithPoints(points1)


//: ### Test 2 - Composite Function

//: Generate a composite function using the custom operator
let cf = translate(offset) |-> scaleTransform(scale) |-> rotate(rotation)
//let cf = composeTransform(composeTransform(translate1,scale1),rotate1)

//: Apply the composite function to the original point p1
let p5 = cf(p1)

//: Plot, showing the points A and D are eqivalent to the previous plot
let points2 = ["A" : p1, "D" : p5]
let plot2 = PlotViewWithPoints(points2)

//: ### Test 3 - Use the composite function to rotate one point around another

//: Create some points
let sun : Point2D    = Point2D(x : 100.0, y: 100.0)
let planet : Point2D = Point2D(x : 40.0,  y: 70.0)

//: Generate a composite function for a 90 degree rotation about the sun
let minusSun =  negate(sun)
let orbit45 = translate(minusSun) |-> rotate(90.0) |-> translate(sun)

//: Apply the function to another point
let planet45 = orbit45(planet)

//: Plot
let points3 = ["Sun" : sun, "Planet" : planet, "Planet+90" : planet45]
let plot3 = PlotViewWithPoints(points3)

//: ## Advanced task - write an *Orbit function*
//: This is not covered in the lecture. I have left this to you experiment with
//:
//: Rotate about another point a given number of degrees
//: Both the centre and angle of rotation need to be provided and captured

//: This version uses Currying so that only one parameter is ever passed
func orbit(center : Point2D) -> ((Double) -> Transform2D) {
   let minusCenter = negate(center)
   func R(_ angle : Double) -> Transform2D {
      let tx = translate(minusCenter) |-> rotate(angle) |-> translate(center)
      return tx
   }
   return R
}

//: So does this version, but it uses the alternative syntax and is easier to read
func orbit_nicecurry(_ center : Point2D, _ angle: Double) -> Transform2D {
   let minusCenter = negate(center)
   let tx = translate(minusCenter) |-> rotate(angle) |-> translate(center)
   return tx
}

//: This version is not curried - which is ok as well if you don't want partial evaluation
func orbit_notcurried(_ center : Point2D, angle: Double) -> Transform2D {
   let minusCenter = negate(center)
   let tx = translate(minusCenter) |-> rotate(angle) |-> translate(center)
   return tx
}


//: ### Test 4 - Orbit function (uses the curried version)
let newPosition = orbit(center: sun)(90.0)(planet) //Curried version
let points4 = ["Sun" : sun, "Planet" : planet, "Planet+90" : newPosition]
let plot4 = PlotViewWithPoints(points3)

//: ### Test 5 - Orbit function with partial evaluation

//: What is interesting with the Curried version is that you can prepare partially incomplete orbits. This allows partially evaulated orbits to be passed to other code.

//: For example:
let solarOrbit = orbit(center : sun)

//: We can now apply different angles around the sun
var trans = [Transform2D]()         //Array of functions (all with captured data of course!)
//for (var ß = 0.0; ß<360.0; ß+=60.0) {
for ß in stride(from: 0.0, to: 360.0, by: 60.0) {
   let tx = solarOrbit(ß)
   trans.append(tx)
}

//: Now we can apply this to different planets
let earth   = Point2D(x: 50.0, y: 50.0)
let mercury = Point2D(x: 70.0, y: 75.0)
var planetOrbits   = [String : Point2D]()

for (idx,f) in trans.enumerated() {
   planetOrbits["e\(idx)"] = f(x: earth.x, y: earth.y)
   planetOrbits["m\(idx)"] = f(x: mercury.x, y: mercury.y)
}
let plot5 = PlotViewWithPoints(planetOrbits)


//: I hope you enjoyed this. I certainly had fun creating it.
//: This only begins to cover Functional Programming (FP) as I understand it (I'm very much still learning). Until Swift, I'd never considered using FP. From what I've seen, I can already see some benefits, but I've also got mixed feelings.
//:
//: * There is something intellectually enjoyable about FP. It's hard to write, but very rewarding when you get it to work. Is fun enough justification? Well, nothing wrong with having fun of course.
//: * There are those who claim FP is 'superior', and others who are more sceptical.
//: * Some say it makes you a better programmer even if you don't use it all the time.
//:
//: I encourage students to be guarded, critical and open-minded when it comes to big claims you might read or hear.
//:
//: * There is nothing to say you must learn to use FP. I've seen nothing in the Apple frameworks or documentation that seem to demand it beyond passing functions as parameters (nice way to create call backs essentially).
//: * Don't feel alone if you find it totally confusing or off-putting.
//: * I've seen plenty of FP code that is incomprehensible (to me at least) - mostly in other languages.
//: * It is helpful to recognise it and learning to understand it in case you have to work with FP code written by other people.
//: * Writing in this style might be 'fun' and give us an intellectual reward, but speaking personally, I hope I am also self-aware enough to not do this *just* to get the thrill from cracking the puzzle!
//: * Swift supports both imperitive and FP styles, and they can be mixed in the same project of course
//: * If FP means you create more expressive code, maybe this is a good reason to use it
//: * If FP means you write more testable code, again, maybe this is a good reason to use it
//: * If FP means you write safer code (e.g. concurrent code), this is probably a good reason to use it
//: * FP may or may not be more efficient (I've no idea which + it might change as the language evolves) - if you're writing CPU intensive code, benchmark carefully!
//: * If you have to bend FP to solve a problem that is more simply/naturally solved with imperitive styles (e.g. GUI code), then I envy your spare time ;o)
//:
//: Swift may have a reasonably low entry point for learning to code, but a high ceiling if you want to master it in its entirity. Considerable effort seems to have gone into keeping Swift syntax clean and easy to read, even when writing FP.
//: What ever style you use, happy coding and don't forget to get enough sleep!

//: [Next](@next)

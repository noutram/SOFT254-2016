//: [Previous](@previous)
import UIKit
import PlaygroundSupport
//: ![Functions 1 - Programming Examples](Banner.jpg)

//: ## Parameter and Return Types

//: ### Tuples
//: Before we proceed, let's look at a compound data type, Tuples.

//: Note the type (String, Int) is written explicitly, but could be inferred.
let theDate : (String, Int) = ("January", 30)
let (month, day) = theDate
print("It is day \(day) in the month of \(month)", terminator:"")

//: Note here how an underscore is a placeholder for an unused value
let (mm, _) = theDate
print("Month = \(mm)", terminator:"")

//: You can use the element index to access elements of a Tuple
let theDay = theDate.1
print("Day = \(theDay)", terminator:"")

//: You can also label tuples
let anotherDate = (month: "January", day: 30)
let anotherDay   = anotherDate.day
let anotherMonth = anotherDate.month
print("It is day \(anotherDay) in the month of \(anotherMonth)")

//: **Type inference**.
//: I've used type inference for `anotherDate`. It's type is `(month: String, day : Int)`
//: Just to prove it...
let oneMoreDate : (month: String, day: Int) = anotherDate
print("It is day \(oneMoreDate.day) in the month of \(oneMoreDate.month)")

//: However, the labels are optional
let yetAnotherDate : (String,Int) = anotherDate

//: Previously, this was defined: `let theDate : (String, Int) = ("January", 30)` where labels were not used. Again, you can still use labels

let theDateLabelled : (month:String, day:Int) = theDate
theDateLabelled.month
//: If you uncomment the following, it will give an error (as theDay has no labels in it's data type)
//theDay.month

//: ### Example - Returning multiple data with a Tuple

func currentDate() -> (day:Int, month:String, year:Int)
{
   let date = Date() //Now
   
   //Get month as a string
   let fmt = DateFormatter()
   fmt.dateFormat = "MMMM"
   let monthString = fmt.string(from: date)
   
   //I am *very* confident the following will not return nil
   let cal : Calendar! = Calendar(identifier: Calendar.Identifier.gregorian)
   
   //Extract the day and year as Int values
   let d  = cal.component(.day, from: date)
   let y  = cal.component(.year, from: date)
   
   //Return result as 3-tuple
   return (day:d, month:monthString, year:y)
}

//decompose as normal
let (d,m,y) = currentDate()
print("On day \(d) of \(month), in the year \(y), Xcode 6.3 beta was updated", terminator:"")

//Just the month
let (_,theMonth,_) = currentDate()
print("The month is \(theMonth)")

//: Or by name
let dmy = currentDate()
print("The day is \(dmy.day)")

//: ### Using Optionals to indicate failure
func firstCommaPosInString(inputString : String) -> Int?
{
   for (idx, character) in inputString.characters.enumerated() {
      if character == "," {
         return idx
      }
   }
   return nil
}

//: This example is successful, and returns the location of the first comma
if let pos = firstCommaPosInString(inputString: "Fred,Roger,John and Brian") {
   print("Found a comma at position \(pos)")
}
//: This example is not successful, and returns nil
if let pos = firstCommaPosInString(inputString: "Fred. Roger. John. Brian.") {
   print("Found a comma at position \(pos)")
}

//: ### Default values
func normalise(x:Double, y:Double, scale:Double=1.0) -> (x:Double,y:Double)?
{
   let magnitude = sqrt(x*x + y*y) / scale
   if magnitude < 1.0e-12 {
      return nil //Numberically illconditioned
   }
   return (x: x/magnitude, y: y/magnitude)
}

//: Using a prescribed scale
if let vec = normalise(x: 2.0, y: 3.0, scale: 2.0) {
   print("\(vec)")
}
//: Using the default (scale by 1)
if let vec = normalise(x: 2.0, y: 3.0) {
   print("\(vec)")
}

//: ### Optional Parameters
func message(name : String, title : String?) -> String {
   var message = "Greetings "
   
   if let t = title {
      message += ( t + " " )
   }
   
   message += name
   return message
}

message(name: "Spock", title: "Mr")
message(name: "Bones", title: nil)

//: ### Variable Parameters
//: To save creating another local variable, you can make a parameter a variable.
//: Note - the parameter is *an independent copy*, not a referene to the original
func mac(_ accumulator: Double, _ x : Double, _ y : Double) -> Double {
   //accumulator is a copy - not the original
   var accumulator = accumulator
   accumulator += x*y
   return accumulator
}

//: The variable a is an accumulator (stores a running sum)
var a : Double = 0.0
a = mac(a, 2.0, 3.0) // Note - the function mac is not modifying `a` direcly
a = mac(a, 5.0, 2.0)


//: ### inout parameters
func mac2(_ accumulator: inout Double, _ x : Double, _ y : Double) {
   accumulator += x*y
}
a = 0.0
mac2(&a, 2.0, 3.0)
mac2(&a, 5.0, 2.0)

//: ### variable number of parameters
func recipe(title t: String, ingredients: String...) -> String {
   
   var description = "<P><h2>" + t + "</h2><ul>"
   for ingredient in ingredients {
      description += "<li>" + ingredient + "</li>"
   }
   description+="</ul>"
   return description
}

let page = recipe(title: "Perfect Breakfast", ingredients: "Cold Pizza", "Meat-balls", "Biriani")
let wv = UIWebView(frame: CGRect(x: 0, y: 0,width: 200, height:200))
wv.loadHTMLString(page, baseURL: nil)
//: To see the output of this, uncomment the next line and turn on the Assistant View
//PlaygroundPage.current.liveView = wv



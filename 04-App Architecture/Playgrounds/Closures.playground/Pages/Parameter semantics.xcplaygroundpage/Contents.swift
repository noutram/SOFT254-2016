//: [Previous](@previous)
import UIKit
import PlaygroundSupport
//: ![Closures](Banner.jpg)

//: ## Parameter and Return Types

//: ### Default values cannot be used for closures

//: ### Optional Parameters - same as functions
let message = { (name : String, title : String?) -> String in
   var message = "Greetings "
   
   if let t = title {
      message += ( t + " " )
   }
   
   message += name
   return message
}

message("Spock", "Mr")
message("Bones", nil)

//: ### Variable Parameters - no longer supported
//: You simple have to create a local variable
let mac = { ( accumulator: Double, x : Double, y : Double) -> Double in
   //accumulator acc is a copy - not the original
   var acc = accumulator
   acc += x*y
   return acc
}

//: The variable `a` is an accumulator (stores a running sum)
var a : Double = 0.0
//: Note - the function mac is not modifying `a` inline
a = mac(a, 2.0, 3.0)  // a = a + 6
a = mac(a, 5.0, 2.0)  // a = a + 10

//: ### inout parameters - same as functions
let mac2 = { ( accumulator: inout Double, x : Double, y : Double) in
   accumulator += x*y
}
a = 0.0
mac2(&a, 2.0, 3.0)
mac2(&a, 5.0, 2.0)

//: ### variable number of parameters - same as functions 

let recipe = { (t: String, ingredients: String...) -> String in
   
   var description = "<P><h2>" + t + "</h2><ul>"
   for ingredient in ingredients {
      description += "<li>" + ingredient + "</li>"
   }
   description+="</ul>"
   return description
}

let page = recipe("Perfect Breakfast", "Cold Pizza", "Meat-balls", "Biriani")
let wv = UIWebView(frame: CGRect(x: 0.0, y: 0.0, width: 200.0, height: 200.0) )
wv.loadHTMLString(page, baseURL: nil)

//: To see the output of this, turn on the Assistant View
PlaygroundPage.current.liveView = wv



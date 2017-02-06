//: ![banner](banner.jpg)
//:
//: [Previous](@previous)
//:
//: ## Associated Values
//: One of the key features of enumerated types in Swift are *associated values*. This is the idea that each possible enumeration case can have one or more elements of data associated with it. This is always specified as a tuple.
enum Vehicle {
   case car(petrol: Bool, sizeCC: Int)
   case plane(engines : Int)
   case other(String)
   case none
}
//: The values in an enumeration are typically related, and are known as **enumeration cases** (I often shorten this to *cases*).
//: The items in parenthesis are the type of data associated with each case. **Labels are optional** but can help make your code more readable.
//: For this example, the possible cases are a category of Vehicle and the associated data are relevant properties of each category.
//:
//: Let's look at some examples:
var commute2work : Vehicle = .car(petrol: true, sizeCC: 1600)
let goOnHoliday = Vehicle.plane(engines: 4)
let moveInsideOffice = Vehicle.other("Hover boots")
//: Here we see how associated values are specified (as tuples) for each enumeration case. Naturally, we also need to know how to access this data. You will see the terms *pattern matching* and *binding* - don't be put off by this. It's a concept that is found in other languages such as Scala and Erlang. Along with its terminology, this concept may seem unfamiliar (I know how you feel, I tried to ignore it for ages!). However, you are likely to encounter code that uses it, and you might even discover you like it :o)
//:
//:   *Enumeration case patterns* feature alongside `switch`, `if-let`, `while`, `guard` and `for-in` statements

//: ### Pattern matching with `if case`
//: An `if case` can be used to extract associated values as shown below:
if case .car(let petrol, let cc) = commute2work {
   if petrol {
      print("Don't forget to get petrol (gasoline)")
   } else {
      print("Remember! Don't put petrol(gasoline) in a Diesel!")
   }
   print("That's \(cc) of raw power")
}
//: This shows an example of a enumeration case pattern: `.car(let petrol, let cc)`
//:
//: This is somewhat similar to `if let` used in optional binding. In this example, the constants `petrol` and `cc` are only assigned if it is meaningful to do so - that is, if `commuteToWork` is matched to `Vehicle.car`.
//: - Note: You can read it as "If the case *matches* `.car`, then `petrol` and `cc` are *bound* (with `let`) to the respective associated data stored in `commute2work`". The basic idea is this: *Defined items on the left hand side of the expression, such as types, values and ranges are matched to items on the right. If the match is positive, then undefined items on the left are bound to associated values on the right.*
//:
//: Here is another example:
//:
if case .car(true, let cc) = commute2work {
   print("Don't forget to get petrol (gasoline)")
   print("That's \(cc) of raw power")
}
//: Here, we test that the case `.car` matches `commute2wor`k **and** the associated type for petrol matches `true`. If so, then `cc` is bound to the respetive associated data.
//:
//: - Experiment: For the example above, try changing `true` to `false`
//:
//: You can do more with pattern matching. Here is an interesting example:
if case .car(true, 600...1000) = commute2work {
   print("That's a modest engine")
}
//: Here, we match the case `.car` to `commute2work`, the associated type for petrol as true and the engine size to be in a specific range.
//: - Experiment: Try changing the range so that the print statement runs.
//: Another example:
commute2work = .other("Pogo stick")
if case .other(let s) = commute2work {
   print("Seriously - \(s)?")
}
//: Again, let's pull this apart.
//:
//: We are *matching* the case `.other` to `commute2work`. If it matches, so `s` is bound with `let` to the associated string data.
//:
//: If we specify a value for the associated data, then it too will be used for matching:
if case .other("Pogo stick") = commute2work {
   print("Ok, you are serious!")
}
//: Here we are *matching* both the case `.other` to `commute2work` **and** the associated data to a value (a string literal in this example).
//: - Experiment: Try changing the literal string to "Pogo Stick"
//:
//: The wildcard `_` is useful to match *any* associated value (in other words, ignore it):
if case .other(_) = commute2work {
   print("Still not telling")
}
//: We are again *matching* the case `.other` to `commute2work` **and** the associated data with the wildcard `_`. In doing do, we are effectively disregarding the associated data with a "don't care" condition.
if case .other = commute2work {
   print("Still not telling")
}
//: This is short hand for the previous example.
//:
//: See the section "Expression Pattern" in [The Swift Programming Language](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Patterns.html#//apple_ref/doc/uid/TP40014097-CH36-ID419) if you want to know how to match other types of expression.

//: ### Comparing Enumerated Types
//:
//: For much of your Swift code, you will be familiar with the `==` operator for testing equality. There are restrictions on using `==` with enumerated types. For enumerated types *without* associated data, it's unambiguous as each case is a unique value in itself.
//:
//: Let's revisit the `ResponseType` enumerated type we met on the [first page](Introduction)
enum ResponseType {
   case disagree
   case slightlyDisagree
   case slightlyAgree
   case agree
}

var p1 = ResponseType.agree
var p2 = ResponseType.agree
if (p1 == p2) {
   print("How very diplomatic")
}
p2 = .disagree
if (p1 != p2) {
   print("Check for Trolls")
}
//: - Experiment: Use the playground to check if instances of `ResponseType` have a `rawValue` property.
//:
//: This type has no raw value. However, each case is a value in its own right, so even without raw values, enumerated types are still comparable.
//:
//: Where things change is *where enumerated types have associated data*. In such cases, you cannot use the `==` operator because equality is not clearly defined.
//: - is it enough that both should be the same case?
//: - should the associated data be equal for both?
//:
//: Let's look at some examples
var myJourney : Vehicle = .none
//: - Experiment: Uncomment the following code - why does it not compile?
//:
//if myJourney == .none {
//   print("None")
//}
//myJourney = .plane(engines: 2)
//if myJourney == Vehicle.plane(engines: 2) {
//   print("Off to the airport you go")
//}
//: We cannot use the `==` operator because `Vehicle` includes cases with associated data. Instead we can use `if case` pattern matching to make comparisons.
//:
//: In the following example, the associated data is disregarded for the purposes of comparison:
myJourney = .plane(engines: 2)
if case .plane(_) = myJourney {
   print("Flying somewhere nice?")
} else {
   print("Ok, none of my business I suppose")
}
//: or simply drop the parenthesis
if case .plane = myJourney {
   print("Flying somewhere nice?")
} else {
   print("Ok, none of my business I suppose")
}
//: Consider the following:
myJourney = .other("Pogo Stick")
if case .other("Pogo Stick") = myJourney {
   print("Hop off then")
}
//: Again the case `.other` and the associated data "Pogo Stick" must both match in order to enter the conditional block.
//: 
//: - Note: It is important to contrast `if` and `if case`

//: **Multiple Conditions**
//:
//: Again, as stated above, for enumerated types without associated data, you can compare using conditional operators such as `==` or `!=` as shown below:
enum BandMember : String {
   case guitarist = "Brian"
   case vocalist = "Freddy"
   case drummer = "Roger"
   case bassist = "John"
}

var track1 : BandMember = .guitarist
var track2 : BandMember = .vocalist
if track1 != track2 {
   print("That's no harmony")
}
//: However, you cannot use conditional operators for enumerated types with associated data.
myJourney = .other("Pogo Stick")
var myOtherJourney = Vehicle.none
//:
// This does not compile
// if (myJourney == myOtherJourney) {
//   print("Don't change your habbits much?")
// }
//:
//: So again, we can use `if case`. 
//:
//: In this first example, the associated data is ignored:
let j1 = Vehicle.plane(engines: 2)
var j2 = Vehicle.plane(engines: 4)
//j2 = Vehicle.other("Flying Carpet")
if case (.none, .none) = (j1, j2) {
   print("Both none")
} else if case (.other, .other) = (j1, j2) {
   print("Both other")
} else if case (.plane, .plane) = (j1, j2) {
   print("Both planes")
} else if case (.car, .car) = (j1, j2) {
   print("Both cars")
} else {
   print("Different")
}
//: - Experiment: Uncomment the line above that reads j2 = .other("Flying carpet")
//:
//: If by equality you wish to include the values of the associated data, then you can extract and test it alongside the case.
//:
//: In this second example, associated data is included in the comparison:
if case .none = j1, case .none = j2 {
   print("Both none")
} else if case .other(let s1) = j1, case .other(let s2) = j2, s1 == s2 {
   print("Both other")
} else if case .plane(let e1) = j1, case .plane(let e2) = j2, e1 == e2 {
   print("Both planes")
} else if case .car(let p1, let c1) = j1, case .car(let p2, let c2) = j2, p1 == p2 && c1 == c2 {
   print("Both cars")
} else {
   print("Different")
}
//: Or more concise:
if case .none = j1, case .none = j2 {
   print("Both none")
} else if case .other(let s) = j1, case .other(s) = j2 {
   print("Both other")
} else if case .plane(let e) = j1, case .plane(e) = j2 {
   print("Both planes")
} else if case .car(let p, let c) = j1, case .car(p, c) = j2 {
   print("Both cars")
} else {
   print("Different")
}
//: In words, all the following patterns need to be matched:
//:
//: - if `j1` is *matched* to the `.plane` case then `e1` is bound to the associated data in `j1`
//: - if `j2` is *matched* to the `.plane` with associated data `e2` matching the associated data in `j2
//:
//: - Note: `if`, `while` and `guard` statements use comma separated lists instead of `where` clauses
//:
//: - Experiment: try the following
//: - *Change the associated data so that `j1` and `j2` are equal*
//: - *Change the case so that `j1` and `j2` are not equal*
//:
//: You can also use a `switch`. I've wrapped the two instances in a tuple and employed tuple pattern matching
switch (j1,j2) {
case (.plane(let e1), .plane(let e2)) where e1 == e2:
   print("Probably the same journey")
case (.car(let p1, let c1), .car(let p2, let c2)) where p1 == p2 && c1 == c2:
   print("Maybe the same car journey")
case (.other(let s1), .other(let s2)) where s1 == s2:
   print("Might be the same journey")
case (.none, .none):
   print("Just stayed home")
default:
   print("Not the same journey")
}
//: - Note:
//:   - Associated data can bring ambiguity when comparing enumerated types. [Later](Advanced) we see how a custom `==` operator could be written to define equality for a given enumerated type with associated data.
//:
//:   - Unlike the `if-case`, you cannot do the following:
//:      ````
//:      switch (j1,j2) {
//:         case (.plane(let e1), .plane(e1)):
//:            print("Probably the same journey")
//:         default:
//:            print("Surely a different journey")
//:      }
//: ````

//: ### More pattern matching - `switch case`
//:
//: There is a lot you can do with pattern matching in Swift. So much so that it probably deserves its own tutorial. However, for now, let's consider some examples with switch case:
commute2work = .car(petrol: true, sizeCC: 2500)
switch commute2work {
case .car(petrol: let petrol, sizeCC: let cc):
   //If it matches the .car case, then bind petrol and cc to the associated data
   //Note the labels are optional
   if petrol && (cc > 1900) {
      print("Dont forget to get petrol (gasoline) - you're going to need it with a \(cc) engine!")
   }
case .plane(let E):
   print("Thats a plane with \(E) engines")
case .other(let s):
   print("So you're travelling by \(s)")
case .none:
   print("Looks like you're walking")
}
//: - Note: case statements don't automatically fall through
//:
//: To give you an idea of the power of pattern matching in Swift, now look at the following example:
commute2work = .car(petrol: true, sizeCC: 2500)
//commute2work = .plane(engines: 4)
switch commute2work {
case .car(true, let cc) where cc > 1900:
   //If the pattern matches .car, and it's petrol, then cc is 'bound' to the associated data where is it greater than 1900
    print("Dont forget to get petrol (gasoline) - you're going to need it with a \(cc) engine!")
case .car(true, 0...1000):
   //Matching the case that this is simply a petrol car with a small engine.
    print("Good fuel economy I assume")
case .car:
    print("It's a car - drive safely")
case .plane(4):
   //A very specific condition: it's a plane with 4 engines
    print("That's the older type of plane - not so good for long-haul")
    fallthrough
default:
   print("Happy travels!")
}
//: Read the comments in this code.
//:
//: - Consider the first case: here we've **matched** both the particular case `.car` *and* associated data `petrol` to be true, and *bound* the engine size to local variable cc, but only where the engine size is over 1900cc. That's quite a lot of logic for a single concise line.
//: - Note how the matching is performed in order. The case `.car:` would also match, *but it wasn't the first case to be matched*, so it is ignored.
//: - An observation here is that we've building a linear and complex set of conditions, but also avoiding unreadable nesting. `switch-case` pattern matching would seem to scale well.
//:
//: - Experiment: Try the case `.plane` with 4 engines
//:
//: - Note: Pattern matching is only performed on one case. The specific case of `.plane(4)` is allowed to *unconditionally* fall through into the next case. Note that you can only fallthough into a case that performs no binding.
//:
//: ### Pattern matching with guard case
//:
//: Similar to `if case`, you can also perform pattern matching with `guard case`
func doJourney(mode : Vehicle) {
   guard case .plane(let E) = mode else {
      return
   }
   print("Definately a plane with \(E) engines")
}

doJourney(mode: .plane(engines: 2))

//: - Note: The name `guard` is very appropriate. You cannot get past the guard unless the patterns match. This is useful to eliminate conditions upfront so that the code that follows can be simplified. Where the patterns do match, then any bound values remain in scope.
//:
//: ### A note about Optionals
//:
//: Until now, we've used Optionals without really questioning what they really are. In fact, *Optionals are an enumerated type with associated data*. They are similar to the following:
//:
//:   ````
//:   public enum Optional<Wrapped> {
//:      case none
//:      case some(Wrapped)
//:   }
//:   ````
//: Note:
//: 
//: - the `.some` case has associated data of type `Wrapped` - this is a *generic* data type
//: - the `.none` does not have associated data
//: - this only illustrates a partial implementation of the Optional enumerated type
//:
//: Treating an Optional as an enumerated type, we access it in various ways:
var optA : Int? = 2
//: Of course, we have the very concise `if let`
if let aVal = optA {
   print("value is \(aVal)")
}
//: Treating as an enumerated type, the syntax is no different to any other enumerated type:
if case .none = optA {
   print("Nothing here")
}
if case .some(let aVal) = optA {
   print("value is \(aVal)")
}
//: The *optional pattern* can be used
if case let aVal? = optA {
   print("value is \(aVal)")
}
//: Alternatively, we can use switch
switch optA {
case .none:
   print("Nothing here")
case .some(let aVal):
   print("value is \(aVal)")
}

//: ### Pattern matching with `for-case-in`
//:
//: `for-in` can use enumeration case patterns to match elements in an array. Let's start with an array of enumerated types
let arrayOfEnums : [Vehicle] = [
   .plane(engines: 2),
   .car(petrol: true, sizeCC: 1100),
   .plane(engines: 4),
   .car(petrol: false, sizeCC: 1600),
   .car(petrol: true, sizeCC: 600),
   .other("Pogo Stick")
]
//: We can match patterns while iterating over the array
for case .car(true, let engineSize) in arrayOfEnums {
   print("Car size = \(engineSize)")
}
//: This illustrates well the value of pattern matching. We can do something similar with Optionals
let arrayOfOpt : [Int?] = [
   nil, 3, 5, 7, nil, 13
]
for case .some(let u) in arrayOfOpt {
   print("u=\(u)")
}
//:Alternatively, use the *optional pattern*:
for case let u? in arrayOfOpt {
   print("u=\(u)")
}

//: ### Pattern matching with `while case`
//:
//: You can use `while case` to iterate while a case and/or its associated data still match.
enum Stimulus {
   case nothing
   case caffeine(Int)
   
   //Calculates the caffeine after an hour - yes, you can have functions inside enumerated types!
   private func afterAnHour() -> Stimulus {
      switch self {
      case .caffeine(let c) where c > 1:
         return .caffeine(c-1)
      default:
         return .nothing
      }
   }
   
   //Updates
   mutating func waitAnHour() {
      self = self.afterAnHour()
   }
}

//: Start with 5 units - stop when in state `.nothing`
var myState = Stimulus.caffeine(5)
while case .caffeine = myState {
   print("Still waiting")
   myState.waitAnHour()
}
//: Start again - stop when caffeine drops below 3
myState = .caffeine(5)

while case .caffeine(3...5) = myState {
   print("Still wired")
   myState.waitAnHour()
}
//:
//: There are many more examples that could be given. See the reference section in the [advanced section.](Advanced)
//:
//: In the last example, we saw how functions can be added to enumerated types. In the next section, we look at this a bit more closely.
//:
//: ----
//: [Next - Methods](@next)

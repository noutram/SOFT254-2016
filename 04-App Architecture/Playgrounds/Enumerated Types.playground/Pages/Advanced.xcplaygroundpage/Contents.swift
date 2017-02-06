//: ![banner](banner.jpg)
//:
//: [Previous](@previous)
//:

//:
//: ## Nested Pattern matching
//:

//: Enumerated types can contain associated values that are also enumerated types. Let's look at an example:
enum SchoolMember {
   enum Salutation {
      case byFirstName(String)
      case formal(String)
   }
   case teacher(Salutation)
   case pupil(String)
}
//: Now create some instances if this type
let head = SchoolMember.teacher(.formal("Head Master"))
let compSciTeacher = SchoolMember.teacher(.formal("Prof Pompous"))
let teachingAssistant1 = SchoolMember.teacher(.byFirstName("Mr. Swift"))
let teachingAssistant2 = SchoolMember.teacher(.byFirstName("Mrs. Coder"))
let class1 : [SchoolMember] = [compSciTeacher, teachingAssistant1, teachingAssistant2, .pupil("Stevie"), .pupil("Mick"), .pupil("Christine"), .pupil("Lindsey"), .pupil("John")]

//: Simple iteration with for case - finding all pupil names
for case .pupil(let p) in class1 {
   p.lowercased()
}
//: The following two are equivalent
for case .teacher(let t) in class1 {
   if case .formal(let name) = t {
      name
   }
}
for case let .teacher(t) in class1 {
   if case .formal(let name) = t {
      name
   }
}
//: We can avoid the if statements and perform quite complex pattern matching - patterns inside patterns
for case .teacher(.formal(let t)) in class1 {
   t.lowercased()
}

for case let .teacher(.formal(t)) in class1 {
   t.lowercased()
}
//: see [\[2\]](References) for more examples.

//: ## Custom Operators
//: You don't just have the option to write methods. You can also redefine operators inside an enumerated type.
//:
//: You may recall that for enumerated types with associated data, it is not clear what the operator `==` actually means. Therefore, it is not defined. You can of course create your own. Let's now extend `Vehicle` to define an `==` operator
//:
//: Here is the original `Vehicle` enum type
enum Vehicle {
   case car(petrol: Bool, sizeCC: Int)
   case plane(engines : Int)
   case other(String)
   case none
}
//: Now we extend it
//:
//: In this example, we define equality as the same case with the same associated data.
extension Vehicle {
   
   //First a function to define what we mean by equality.
   func isEqualTo(_ other : Vehicle) -> Bool {
      
      switch (self, other) {
         
      case (.car(let p1, let c1), .car(let p2, let c2)) where (p1 == p2) && (c1 == c2):
         return true
         
      case (.plane(let e1), .plane(let e2)) where e1 == e2:
         return true
         
      case (.other(let s1), .other (let s2)) where s1 == s2:
         return true
         
      case (.none, .none):
         return true
         
      default:
         return false
      }
      
   }
   //Now we use an operator method on the enum type to make our code more readable
   static func == (_ lhs : Vehicle, _ rhs : Vehicle) -> Bool {
      return lhs.isEqualTo(rhs)
   }
}
//:Let's test - a bug will appear as a run-time error
let vh1 = Vehicle.car(petrol: true, sizeCC: 1900)
let vh2 = Vehicle.car(petrol: true, sizeCC: 1600)
let vh3 = Vehicle.car(petrol: true, sizeCC: 1900)
let vh4 = Vehicle.plane(engines: 4)
assert(vh1.isEqualTo(vh1) == true)
assert(vh1.isEqualTo(vh2) == false)
assert(vh1.isEqualTo(vh3) == true)
assert(vh1.isEqualTo(vh4) == false)
assert(vh2.isEqualTo(vh2) == true)
assert(vh2.isEqualTo(vh3) == false)
assert(vh2.isEqualTo(vh4) == false)
assert(vh3.isEqualTo(vh3) == true)
assert(vh3.isEqualTo(vh4) == false)
assert(vh4.isEqualTo(vh4) == true)
//: or alternatively
assert((vh1 == vh1) == true)
assert((vh1 == vh2) == false)
assert((vh1 == vh3) == true)
assert((vh1 == vh4) == false)
assert((vh2 == vh2) == true)
assert((vh2 == vh3) == false)
assert((vh2 == vh4) == false)
assert((vh3 == vh3) == true)
assert((vh3 == vh4) == false)
assert((vh4 == vh4) == true)
//: **Challenge**
//: Modify the code above to only require the same case (and ignore the associated data)

//:### Recursive associated values
//: Now this takes some explaining, so don't worry if you don't understand it - (you can blame me as I'm not sure how well I can explain it ;o).
//: (I wrote this example after several strong cups of coffee and the solution came to me as I did it)
//: This really enters the world of functional programming which is half the problem. It is also not optimised for performance... Anyway....
//:
//: This example is about complex numbers. In brief, these are numbers which can be likened to 2D coordinates. Think of the real part as being on the x-axis and the imaginary part on the y. If (a,b) is a coorinate, then we write it as a complex number in the form "a+ib" where i is defined as the square root of -1. Don't worry why - that just makes the maths work when you do things with them.
//:
//: We say that:
//: * a is the real part
//: * b is the imaginary part
//:
//: When you add two complex numbers together, you simple add the real parts and the complex parts separately.
//: * For addition, (a+ib) + (x+iy) = (a+x) + i(b+y)
//: * For multiplication: (a+ib) * (x+iy) = ax + iay + ibx - by
//:
//: Note that i*i = -1. Grouping the real and imaginary parts you get:
//: * (ax-by) + i(ay+bx)
//:
//: *This is used heavily in engineering and mathematics.*
//:
//: The key thing to note is that the enumerated type below, which represents a number - be it just a normal (real) number or a complex number. Note the case where the type is complex. The associated data is also of type `Number`.
//: This means that you can embed Numbers inside Numbers.
indirect enum Number {
   case real(Double)
   case imag(Double)
   case complex(Number, Number)
   
   //Recursively sum all the real components
   func realComponent() -> Double {
      switch (self) {
      case .real(let r):
         return r
      case .imag(_):
         return 0.0
      case .complex(let n1, let n2):
         return n1.realComponent()+n2.realComponent()
      }
   }
   
   //Recursively sum all the imaginary components
   func imagComponent() -> Double {
      switch (self) {
      case .real(_):
         return 0.0
      case .imag(let i):
         return i
      case .complex(let n1, let n2):
         return n1.imagComponent()+n2.imagComponent()
      }
   }
   
   //Calculate the magnitude (Pythagoras theorem)
   func magnitude() -> Double {
      let r = self.realComponent()
      let i = self.imagComponent()
      return (r*r+i*i).squareRoot()
   }
   
   //Sum two numbers
   //This is simply to combine them - no actuall additional is needed at this stage
   static func + (_ lhs : Number, _ rhs : Number) -> Number {
      return Number.complex(lhs, rhs)
   }
   
   //Multiply two numbers
   static func * (_ lhs : Number, _ rhs : Number) -> Number {
      // (a+jb)*(c+jd)=(ac-bd) + (ad+bc)j
      let a = lhs.realComponent()
      let b = lhs.imagComponent()
      let c = rhs.realComponent()
      let d = rhs.imagComponent()
      let r = Number.real(a*c-b*d)  //Resolve the real parts of
      let i = Number.imag(a*d+b*c)  //Resolve the imaginary parts
      let product = Number.complex(r , i)
      return product
    }
}
//: Let's look at some examples:
let ccr = Number.real(2.0)          //Real number only
let cci = Number.imag(4.0)          //Imaginary number only i4.0
let cc1 = Number.complex(ccr, cci)  //Complex number with associated values 2.0 + i4.0
let cc2 = Number.complex(cc1, .real(1.0)) //Another complex number, this time 2.0 + i4.0 and 1.0 are stored (but not added yet)
let rr = cc2.realComponent()        //This does the work - it will recursively sum all the real parts embedded within - note the result is the sum of all real parts.
let ii = cc2.imagComponent()        //Same again but for imaginary. Not the result is the sum of all imaginary parts
//: Note how the static function + only combines data together (very fast). It is the `realComponent()` and `imagComponent()` functions that do the work, recursively summing all numbers.
//:
//: We can now calculate the magnitude (length of the line from the origin to the point (real,imag)
cc2.magnitude()
//: It's a classic 3-4-5 triangle.
//:
//: Now using operators
let cn1 = .real(2.0) + .imag(4.0)              //2+4i
let cn2 = cn1 + .real(1.0)                   //2+4i,1 => 3+4i
cn2.realComponent()
cn2.imagComponent()
cn2.magnitude()

//: ### Protocols
//: Like structures and classes, **enumerated types can conform to protocols**
protocol Movable {
   func move()
}
//: Here I impose both requirement that `Vehicle` conforms to the protocol `Movable`, but code is added to make it conform
extension Vehicle : Movable {
   func move() {
      switch (self) {
      case .car(petrol: _, sizeCC: _):
         print("Brummmm")
      case .plane(engines: _):
         print("Whoosh")
      default:
         print("What was that?")
      }
   }
}
//: Let's now create a constant of type `Movable`
let transport : Movable = Vehicle.plane(engines: 2)
transport.move()
//: Without a type cast, the only method available is `move()`.
//: What is interesting is when we interrogate the type
type(of: transport)
if transport is Vehicle {
   "Yes"
}
//: It seems we know the concrete type.
//: If we look at this next example, the type is `Any`. By equating it to an instance of Vehicle, we can also test for type conformance.
var something : Any = transport
if something is Movable {
   "Yes again"
}
//: Indeed it comes up positive.
//: For a type `Any`, we can re-assign to another type and re-test
something = SchoolMember.pupil("Fred")
type(of: something)
if something is Movable {
   "Yes again"
} else {
   "Now for something completely different"
}
//: The variable no longer conforms to the protocol.
//:
//:
//: [Next - References](@next)


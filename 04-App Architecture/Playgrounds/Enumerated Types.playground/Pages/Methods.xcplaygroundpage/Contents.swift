//: ![banner](banner.jpg)
//:
//: [Previous](@previous)
//:

//: ## Methods
//:
//: As we saw in the previous section, enumerated types (like classes and structures) can also have methods and therefore computed properties.
//:
//: - **instance methods** - functions that a concerned with an instance of the enum, have access to `self` and can mutate `self` (known as *mutating* methods). You need an instance of a enum to use these.
//: - **type methods** - belong to the type and no particular instance. You can call these without an instance of an enum.
//:
//: Here is a simple example:
enum ToggleSwitch : String {
   
   //These are the two possible cases with raw types "on" and "off"
   case on
   case off
   
   //The following instance method simply returns another instance (note the name is an adjective)
   func toggled() -> ToggleSwitch {
      switch (self)
      {
      case .on:
         return .off
      case .off:
         return .on
      }
   }
   
   //Where a function name is a verb, by convention this suggests self-modification. Such methods change `self` (the instance), so must be marked as `mutating`
   mutating func toggle() {
      //The instance is replaced with a completely new instance (with a different case in this example)
      self = self.toggled()
   }
   
   //This type function does not operate on a particular instance, but is part of the Enumerated Type itself
   static func & (lhs: ToggleSwitch, rhs: ToggleSwitch) -> ToggleSwitch {
      //Here comes that pattern matching again - matching a tuple is always handy
      let tuple = (lhs, rhs)
      switch tuple {
      case (.on, .on):
         return .on
      default:
         return .off
      }
   }
   
   //Calculated properties are allowed (stored are not for enum) - they are a type of instance method
   var description : String  {
      get {
         if self == .on {
            return "SWITCH IS ON"
         } else {
            return "SWITCH IS OFF"
         }
      }
   }
   
   //The initialiser can also be defined. This one ensures the default to always be off. This is not mutating as it's involved in creation, not change
   init() {
      self = .off
   }
   
   //You can also write other initialisers
   init(isOn n : Bool) {
      if (n) {
         self = .on
      } else {
         self = .off
      }
   }
   
}
//: The enum has a number of methods. The initialisers `init()` and `init(isOn n : Bool)` are useful for safely setting the default state. You can therefore initialise this enum in various ways.
//:
//: 1. Simple assignment
let toggle0 : ToggleSwitch = .off
//: 2. Invoke the initialiser
let toggle1 = ToggleSwitch()
//: 3. Alternative initialiser (similar to a convenience initialiser)
let toggle2 = ToggleSwitch(isOn: true)
//: 4. Using a raw value
if let toggle3 = ToggleSwitch(rawValue: "on") { //With raw values, it could fail, so the return is Optional....
   toggle3
}
if let toggle4 = ToggleSwitch(rawValue: "ON") { //...as shown here
   toggle4
} else {
   print("That failed - wrong case?")
}
//: In this example, `toggle3` and `toggle4` are Optional types (remember that initialisation with raw values can fail). `toggle3` has a wrapped value whereas `toggle4` is `nil`.
//:
//: The enum has a number of methods. Starting with the initialiser `init()` we first set the default state to `.off`.
var sw1 = ToggleSwitch()
sw1.description
//: We can obtain another instance with the opposite state (original unmodified). Note the value semantics and the method naming convention used here (it's an adjective, not a verb).
let sw2 = sw1.toggled()
sw1.description
//: We can change the state of an instance (mutating). Note again the method naming convention is to use a verb in an imperative tense. This is an in-place modification.
sw1.toggle()
sw1.description
//: The custom operator & is a type-method (`self` is the Type, not an instance)
ToggleSwitch.on & ToggleSwitch.on
ToggleSwitch.on & ToggleSwitch.off
//:
//: Notes:
//:
//: - enums are value types
//: - enums cannot have stored properties
//: - enums can have computed properties and methods
//: - enums can have instance methods with access to the instance value self
//: - a method that changes self must be marked as mutating
//: - enums can have type methods where self refers to the type
//:

//: ## Extensions
//: Let's now add some further methods to the enum from outside the original definition. We use an *extension* to do this
extension ToggleSwitch {
   //Add an initialiser
   init(withString s : String) {
      if s.lowercased() == "on" {
         self = .on
      } else {
         self = .off
      }
   }
}
//: Note - an initialiser does not need `mutating` as `self` being initialised, not changed.
//:
//: Initialise with the new initialiser
let sw3 = ToggleSwitch(withString: "ON")
sw3.description
//: ## Value Semantics
//: Like structures, enumerated types are *value types*
var v1 = ToggleSwitch.on
var v2 = v1
//: `v2` is now a logical and independent copy of `v1`
v2.toggle()
//: `v2` is mutated by the `toggle` method while leaving `v1` unaffected.
v1.description
v2.description
//:By default, properties of value types are not mutated from within an instance method [\[1\]](References). The `toggle` method has the keyword `mutating` to override this.
//:

//: ### Subscripts
//: You can even define what it means to use a subscript

enum FemaleShoeSize {
   
   case uk(Int)
   case usa(Int)
   
   func ukSize() -> FemaleShoeSize {
      switch self {
      case .uk:
         return self
      case .usa(let s):
         return .uk(s-2)
      }
   }
   
   func usSize() -> FemaleShoeSize {
      switch self {
      case .uk(let s):
         return .usa(s+2)
      case .usa:
         return self
      }
   }
   
   subscript(index : Int) -> Int? {
      
      get {
         switch self {
         case .uk(1...10) where (index > 0 && index <= 10):
            return index
         case .usa(3...12):
            return index+2
         default:
            return nil
         }
      }

   }
}
//: Let's create an instance of this type with value `uk` and associated data (size) 8.
let shoe = FemaleShoeSize.uk(8)
shoe[0]
shoe[1]
shoe[2]
//: We can calculate the equivalent size in the USA
shoe.usSize()
//: We can then use subscripts to see all the sizes converted to the USA system
shoe.usSize()[1]
shoe.usSize()[2]

//: - Note: Just because this type has a subscript does not mean you can iterate over it. The following code will not compile as `FemaleShoeSize` does not conform to the `Sequence` protocol.
//:   ````
//:   for m in shoe {
//:      m
//:   }
//:   ````

//: [Next - Advanced Topics](@next)

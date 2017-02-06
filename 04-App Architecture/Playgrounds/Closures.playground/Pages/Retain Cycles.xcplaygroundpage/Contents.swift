//: [Previous](@previous)

import UIKit
import PlaygroundSupport
//: ![Closures](Banner.jpg)

//: ## Retain Cycles and Capture Lists
//:[The Swift Programming Language]: https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html#//apple_ref/doc/uid/TP40014097-CH20-ID48 "Open in Browser"
//:
//:For more information, see the chapter on Automatic Reference Counting in [The Swift Programming Language].

//: So far, we've not discussed memory management. The reason for this is simply that there was little need.
//: For value types (the majority), you can think of these like an `int` or `double` in C or C++. There is one copy, and one
//: (under the hood) reference to it. Assign a value type to another, and a copy is made. *The lifetime of value types is dictated by scope*.
//:
//: [Dangling Reference]: https://en.wikipedia.org/wiki/Dangling_pointer "Open in Browser"
//:
//: Reference types are different and present greater challenges in terms of memory management. 
//: * You can have multiple references to the same object. 
//: * Classes, closures and functions are all reference types.
//: * If an object is deallocated, but references to that object still exist, these are known as a [Dangling Reference] and if dereferened, can cause a crash.
//:
//: A system known as *reference counting* is used to decide when to deallocate an object.
//: * The **reference count** is simply the number of **strong** references to an object.
//: * **weak** or **unowned** references do not contribute to the reference count.
//: * when an object is first instantiated, it has a reference count of 1
//: * for each additional strong reference that is made, the reference count is automatically incremented by 1
//: * for every strong reference that is lost, the reference count is decremented by 1
//: * the increment and decrement of reference counts is performed by hidden code that is added to your source by the build tools
//: * when a reference count becomes zero, the object is dealloced AND all `weak` references are set to nil
//:    * **note**: You can only make `weak` references to Optional types (only Optionals can be `nil`)
//:    * for all others, you use `unowned`
//:

//: For example, in the figure below *object 2 has a retain count of RC = 2*
//: * `object 1` instantiates `object2`, and maintains a strong reference to it
//: * `object 3` also stores a strong reference to `object 2` (by assignment)
//: * `object 4` also stores a reference to `object 2`, but this is a *weak reference*. This has no impact on the retain count.

//: ![References](references.jpg)

//: To deallocate `object 2`, all strong references much be lost
//: * If `object 3` is deallocated, then then RC will drop to RC = 1
//: * If `object 1` is *then* delallocated two things will happen:
//:     * `object 2` will be deallocated because RC=0
//:     * The reference in `object 4` will become automatically set to `nil`

//: We can demonstrate this in code.
class Object2 {
   let _id : String
   
   init(id : String) {
      print("Init \(id)",separator: "", terminator: "")
      _id = id
   }
   deinit {
      print("deinit \(_id)",separator: "", terminator: "")
      if _id == "Object 2" {
         _id
      }
   }
   
}
class Object1or3 : Object2 {
   let strongReference : Object2
   
   override init(id : String) {
      strongReference = Object2(id: "Object 2")
      super.init(id: id)
   }
   
   init(id: String, ref: Object2) {
      strongReference = ref
      super.init(id: id)
   }

}

class Object4 : Object2 {
   //Put a property observer on this property
   weak var weakReference : Object2?
   
   init(id: String, ref: Object2) {
      weakReference = ref
      super.init(id: id)
   }
}

//: Create references for 1,3 and 4
var object1 : Object1or3?
var object3 : Object1or3?
var object4 : Object4?

//: To demonstrate the weak reference behaviour in a Playground, I need to write this in a function
func testARC() {
   
   //: Instantiate `object1`, which in turn instantiates `object2`
   object1 = Object1or3(id: "Object 1")
   //: We can confirm that `object2` also exists
   object1?.strongReference._id
   
   //:Instantiate `object3`, and give a reference to `object2`
   object3 = Object1or3(id: "Object 3", ref: object1!.strongReference)
   
   //:Instantuate `object4`, and give a weak reference to `object2`
   object4 = Object4(id: "Object 4", ref: object1!.strongReference)


//: **EXPERIMENT**
//: * Uncomment each of the following lines to dealocate the associated objects in turn.
//: * Observe the deinit methods on the above classes 
//:     * or view the timeline and look for the message "Object 2 is deallocated"
   
//   object1 = nil
//   object3 = nil

//: Note - the process of deallocation and setting weak pointers to nil may not complete immediately. If it does not, it will occur at the end of the current scope and/or run-loop. For those who were writing Objective C before ARC, this suggests it is *autoreleased*.
   object4?.weakReference?._id
}

//: Run the experiment
testARC()

//: **EXPERIMENT FOLLOW UP**
//: Here we see how the weak reference is now automatically set to `nil`. Comment out either of the two lines again and see this change.
object4?.weakReference?._id


//: Apple use a technology they call Automatic Reference Counting (ARC) to handle reference counting for you. For the most part, you don't have to do anything. However, there is one scenario where you need to intervene, and that is the avoidance *retain cycles*. This is not difficult to do, and is a small price to pay for the convenience ARC brings. Furthermore, ARC removes the need for a garbage collector.
//:
//: Remember - this discussion only applies to *reference types* (classes, closures and functions)

//: #### SCENARIO 1 - strong reverse reference

//: All pet owners need this basic skill
protocol CanOpenATin : class {
   func openPetFoodTin() -> Bool
}

//: Pet class - has a reverse reference back to the owner. This class does not instantiate the owner, so therefore should not noramlly maintain a strong reference to its owner.
class Pet {
   let timeLastFed = Date()
   let name : String
   var isHungry : Bool {
      get {
         let hrsElapsed = Date().timeIntervalSince(timeLastFed) / 3600.0
         return hrsElapsed > 12.0
      }
   }
   
   //Reverse reference
   weak var owner : CanOpenATin?
   
   //: **EXPERIMENT**
   //:
   //: * check the `deinit` function in `Owner` being called (also shown in the timeline)
   //: * now remove the word `weak` from the above statement and check again
   
   
   //Designated initialiser - must be called (so that all properties are initialised)
   init(name petName : String) {
      name = petName
   }
   
}

//: Owner class - instantiates the pet object, so maintans a strong reference to it.
//: It also conforms to the  protocol `CanOpenATin`, thus guaranteeing it will implement the method `openPetFoodTin() -> Bool`
class Owner : CanOpenATin {
   
   let onlyPet : Pet    //Strong reference
   
   func openPetFoodTin() -> Bool {
      return true
   }
   
   //Designated initialiser - must be called (so that all properties are initialised)
   init(withPet pet : Pet) {
      onlyPet = pet
      pet.owner = self
      pet.name
   }
   
   //This should be called once there are no more strong references to this instance
   deinit {
      print("Deallocating", terminator: "")
      onlyPet.name
   }
}

//: Two strong references to pets - these will survive
let cat = Pet(name: "Yoda")
let dog = Pet(name: "Chewy")

//: First, the owner with a cat
var owner = Owner(withPet: cat)

//: Double check everything is hooked up
if let opened = cat.owner?.openPetFoodTin(), opened == true {
   print("Purrrrrr",separator: "", terminator: "")
}

//: Now switch the reference to another instance of Owner. The old should be deallocated as this was the only reference.
//: This new owner wants a dog
owner = Owner(withPet: dog)

//: Perform the above experiement, and you will find that the first owner is never delalocated, yet we no longer have a reference to it!
//: This memory leak is caused by the strong reverse reference from the instance of cat back to its owner. I cannot deallocate cat, and I
//: don't want to as I might want to realocate to another owner.


//: #### SCENARIO 2 - closure properties referencing self

//: We have not yet discussed properties, although we've added them in view controllers in previous exercises. Whenever you add an instance variable to a class or strucure, you are in fact adding a property. Many properties are value types - this is simple. Problems with memory management can only occur with reference types. We saw previously how a reference to a class can lead to a retain cycle. Closures are also reference types, and thus need careful handling when set as a class property.

//: Let's go back to a simple idea
class Person {
   //Properties
   private let lastName : String
   private let title : String?     //Although Optional, I can use let because it is guaranteed to be initialised in init
   
   // Salutation is a reference type (a closure)
   lazy var giveTime : () -> String = {
      
      //Capture list - written in [ square braces] before the parameters and 'in'
      //Listing self as unowned prevents a retain cycle
      //Note that in this context, self cannot be nil, so we saw it is "unowned" as opposed to "weak"

//: **EXPERIMENT** Comment out the following line (capture list) - does the de-init still run? (check in the timeline for the words "Instance being deallocated Spock"
      [unowned self] in
      
//: NOTE how this closure makes reference to self, therefore captures it by default
      let tmStr = ", it is \(NSDate())"
      if let t = self.title {
         return t + " " + self.lastName + tmStr
      } else {
         return self.lastName + tmStr
      }
   }
   
   //Designated initialised - this has to be called so that the properties are initialised
   init(lastName name : String, title: String?) {
      self.lastName = name
      self.title = title
   }
   
   //This should run when deallocated
   deinit {
      print("Deallocating person \(lastName)", terminator: "")
      self.lastName
   }
   
}


var person : Person? = Person(lastName: "Spock", title: "Mr")
person?.giveTime()
person = nil
//: At this point the `deinit` method *should* run as the `Spock` instance has no remaining strong references.


//: [Next](@next)

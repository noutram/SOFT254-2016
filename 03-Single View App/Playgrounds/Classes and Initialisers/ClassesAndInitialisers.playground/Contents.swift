//: # Introduction to class properties and initialisers


import UIKit

//: **Person Base Class**
class Person {
//: These are **stored** properties
    var age : Int = 0       //Initialised
    let name : String       //Must be initialised in a designated initialiser
    var address : String?   //This is an Optional type
    
//: Designated initialiser
    init(personName: String) {
        self.name = personName
        //End of Phase 1 - all non-optional stored properties are initialised
    }
}

//: Instantiate an object of type Person
let me : Person = Person(personName: "Nick")
me.address = "UK"


//: **Employee subclass**
class Employee : Person {
    let id : Int
    
//: Designated initialiser
    init(personName: String, ident: Int) {
        self.id = ident
        super.init(personName: personName)
        //End of Phase 1 - all non-optional stored properties are initialised
    }
   
//: Convenience initialiser
   
    convenience override init(personName: String) {
        self.init(personName: personName, ident: 0)
        //End of Phase 1 - all non-optional stored properties are initialised
    }
   
}

//: Instantiate
let dev1 = Employee(personName: "Jane", ident: 123)
let intern = Employee(personName: "Jim")


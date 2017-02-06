//: ![banner](banner.jpg)
//:
//: [Previous](@previous)
//:
//: ## Raw Values
//: It is possible to assign actual values to the different cases in an enumerated type, as long as they are all unique and of the same type
enum PhoneExtension : Int {
 case presales = 1111
 case sales = 1112
 case aftersales = 1333
}
//: Note the enum name is followed by another type (`Int` in this case). By writing this, all raw values will have this type.
var v : PhoneExtension = .sales
v.rawValue

//: ### Implicitly assigned raw values
//: In languages such as C, enumerated types actually have an implied value (auto increasing integer). The same thing can be done in Swift as follows:
enum RankedMountains : Int {
   case everest = 1, k2, Kangchenjunga
}
let myClimb : RankedMountains = .k2
print("The ranking is: \(myClimb.rawValue)")
RankedMountains.Kangchenjunga.rawValue
//: Note how the raw values (type Int) automatically increment
//:
//: A more fun example using Emoji
enum CustomerRating : Int {
   case 😞 = 1, 😒, 😐, 😀, 😋
}
let review : CustomerRating = .😀
CustomerRating.😞.rawValue
CustomerRating.😐.rawValue
print("You café rating is\(review.rawValue)")
//: Again, because the type of the raw value was declared as type `Int`, so the raw values automatically increment.
//:
//: It's not just integers, you could use Strings. In the following example the raw values are set manually:
enum BandMember : String {
 case guitarist = "Brian"
 case vocalist = "Freddy"
 case drummer = "Roger"
 case bassist = "John"
}

let songwriter : BandMember = .vocalist
if songwriter.rawValue == "Freddy" {
   print("Alright!")
}
//: Where the raw values of type String are not explicitly specified, then the name of the (respective) case is automatically used. This is shown in the following example:
enum WinterClothes : String {
   case hat, gloves, socks, boots
}
let gift : WinterClothes = .socks
let giftString : String = gift.rawValue
WinterClothes.gloves.rawValue

//: ### Initialise with a raw value
//: You can also initialise such enumerated types using raw values.
let guest = BandMember(rawValue: "Brian")
let deptNumber = PhoneExtension(rawValue: 1333)
let deptNumber2 = PhoneExtension(rawValue: 1234) //Check the value returned from this
//: Of course, *this can fail if invalid raw values are provided*. When you initialise with an invalid raw value, you get back a `nil` (Optional type). We could test this first using Optional binding.
if let dn = PhoneExtension(rawValue: 1333) {
   print("That worked")
}
if let dn = PhoneExtension(rawValue: 1334) {
   print("That worked")
} else {
   print("That did not")
}
if let rocker = BandMember(rawValue: "Ozzy") {
   print("Bats be nervous")
} else {
   print("Wrong band")
}
//:
//: ----
//: [Next - Associated Values](@next)







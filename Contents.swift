import UIKit

// MARK: - SOLID Principles

/// SOLID is an acronomy for five design patterns to make software designs more understandable, flexible, and maintainable.

// Rigidity:- Software become difficult to change when changes causes other changes in dependent module which irrelevant. Simple changes become expensive.

// Fragility: - Fragile code more worse than agile code as it does not produce compile time error. Fixes introduces new bugs which contribute in regression issues.

// MARK: - Single Responsibility Principle:
// Single Responsibility Principle states that each software module or class should have one only one reason to change.

// Let’s first look at the code that does not comply with the SRP, and works under normal conditions.

class DataHandler {
    func handle() {
        let data = loadData()
        let list = parse(data: data)
        
        save(model: list)
    }
    
    func loadData() -> Data {
        return Data()
    }
    
    func parse(data: Data) -> Any {
        return ""
    }
    
    func save(model: Any) {
        //saveData
    }
}

/*
 We have a DataHandler class, which creates data, parses the data, and finally saves the data it has created. If you take this code and try to run it, it will compile without any problems. So what is the problem or problems here?
 
 When we look at the code, the DataHandler class has multiple responsibilities, such as parsing , saving, and creating data.
 */

// As a solution, the current responsibilities can be moved to different classes:

class APIHandler {
    func loadData() -> Data {
        return Data()
    }
}

class ParseHandler {
    func parse(data: Data) -> Any {
        return ""
    }
}

class StorageHandler {
    func save(model: Any) {
        //saveData
    }
}

class DataHandler {
    
    let apiHandler: APIHandler
    let parseHandler: ParseHandler
    let storageHandler: StorageHandler
    
    init(apiHandler: APIHandler, parseHandler: ParseHandler, storageHandler: StorageHandler) {
        self.apiHandler = apiHandler
        self.parseHandler = parseHandler
        self.storageHandler = storageHandler
    }
    
    func handle() {
        let data = apiHandler.loadData()
        let model = parseHandler.parse(data: data)
        storageHandler.save(model: model)
    }
}

// MARK: - Open/Closed Principle:
// Software Enities should be open for extension but closed for modifications.

// Explanations can be confusing at times. Let’s review the code:

class PaymentManager {
    func makeCashPayment(amount: Double) {
        //perform
    }

    func makeVisaPayment(amount: Double) {
        //perform
    }
}

/*
 Let’s imagine we have a PaymentManager. Let this manager support cash and Visa payment methods in the first stage. So far everything is great. After a while, we had to update the manager and we are expected to add MasterCard feature as a new feature.
 
 Let’s create a function called makeMasterCardPayment like the previous functions. Great, our code will continue to work. We complied with the requirements but we broke a rule that the class must be closed for modification. For a task that does a similar job, we shouldn’t add anything new to the class.
 */


class PaymentManager {
    func makeCashPayment(amount: Double) {
        //perform
    }

    func makeVisaPayment(amount: Double) {
        //perform
    }
    
    // v2
    func makeMasterCardPayment(amount: Double) {
        //perform
    }
}

/// Let’s see how we can solve this problem:

protocol PaymentProtocol {
    func makePayment(amount: Double)
}

// v1 features
class CashPayment: PaymentProtocol {
    func makePayment(amount: Double) {
        //perform
    }
}

class VisaPayment: PaymentProtocol {
    func makePayment(amount: Double) {
        //perform
    }
}

//v2 features
class MasterCardPayment: PaymentProtocol {
    func makePayment(amount: Double) {
        //perform
    }
}

class PaymentManager {
    func makePayment(amount: Double, payment: PaymentProtocol) {
        payment.makePayment(amount: amount)
    }
}

/*
 Let’s define the main task in the PaymentManager in an abstract structure (protocol), this structure will answer the requirements that PaymentManager expects.
 
 We also created a separate class for each Payment method, these classes will be in the abstract structure that PaymentMamager expects. So we can add as many new payment methods as we want without making any changes in the manager.

 So we kept our PaymentManager class open to extensions but closed to modifications.
 */

// MARK: - Liskov Substitution Principle:
// Subclasses should behave nicely when used in place of their base class.
// If S is subtype of T, then objects of type T may be replace with objects of type S, without breaking the brogram.

/*
 Suppose we have a class of rectangles, the rectangles have a width and a height, and their product is equal to the area.
 
 Whether we have a square class, theoretically a square is a rectangle, so we can inherit the class square from the class rectangle. So far everything is great.

 The following setSizeAndPrint function expects a rectangle type variable and assigns the rectangle width and height by default. It’s okay to call this function for the rectangle class, because width = 4, height = 5, area = 20.

 But the same is not true for a square that inherits from the rectangle class because the two sides of a square are equal. We can’t just assign 4 and 5 by default and expect it to behave like the class it inherits.

 At this point, classes that can’t act as inherited classes and need situation-specific development breaks the LSP.
*/

class Rectangle {
    
    var witdh: Float = 0
    var height: Float = 0
    
    func set(witdh: Float) {
        self.witdh = witdh
    }
    
    func set(height: Float) {
        self.height = height
    }
    
    func calculateArea() -> Float {
        return witdh * height
    }
    
}

class Square: Rectangle {
    
    override func set(witdh: Float) {
        self.witdh = witdh
        self.height = witdh
    }
    
    override func set(height: Float) {
        self.height = height
        self.witdh = witdh
    }
}

//breaks the lsp
func setSizeAndPrint(of rectangle: Rectangle) {
    rectangle.set(height: 5)
    rectangle.set(witdh: 4)
    print(rectangle.calculateArea())
}

func example() {
    let rectangle = Rectangle()
    setSizeAndPrint(of: rectangle)
    
    let square = Square()
    setSizeAndPrint(of: square)
}

/*
 As a solution, it is aimed for each class to perform its own tasks within itself, by keeping the common tasks between classes in a certain abstract structure (protocol).

 As in the example above, the common task between the Rectangle and Square classes is to calculate the area of the object. Both the rectangle and square classes inherit the Polygon abstract structure after this task is defined in a common protocol. Thus, each class fulfills the necessary tasks within itself and there is no need to make any special developments. Classes behave just like the structure they inherit.
 */

protocol Polygon {
    func calculateAre() -> Float
}

class Rectangle: Polygon {
    
    var witdh: Float = 0
    var height: Float = 0
    
    func set(witdh: Float) {
        self.witdh = witdh
    }
    
    func set(height: Float) {
        self.height = height
    }
    
    func calculateAre() -> Float {
        return witdh * height
    }
}

class Square: Polygon {
    
    var side: Float = 0
    
    func set(side: Float) {
        self.side = side
    }
    
    func calculateAre() -> Float {
        return pow(side,2)
    }
}

func printArea(polygon: Polygon) {
    print(polygon.calculateAre())
}

func example() {
    let rectangle = Rectangle()
    rectangle.set(witdh: 4)
    rectangle.set(height: 5)
    print(printArea(polygon: rectangle))
    
    let square = Square()
    square.set(side: 4)
    printArea(polygon: square)
}

// MARK: - Interface Segregation Principle:
// Interface Segregation Principle states that client should not be forced to depend on methods that they do not use.
// Convert fat protocols into small protocols based on group of methods

/*
 Let’s have an abstract structure called Worker, and in general, we expect those who inherit from the Worker class to be able to do the eat and work tasks.

 First, let’s have a class called Human and this class inherits from the abstract structure Worker. Theoretically, we expect a person to both eat and work. Then we needed a robot structure and we inherited it from the Worker structure because the robot can work.

 The problem starts here because Worker protocol has two functions, one is work and one is eating, there is no problem for the work function because the robot can run, but since we inherit from the worker structure, we have to add the eat function as well, which causes an unnecessary responsibility to be passed to the class. This is an ISP break.
 */

protocol Worker {
    func eat()
    func work()
}

class Human: Worker {
    func eat() {
        print("eating")
    }
    
    func work() {
        print("working")
    }
}


class Robot: Worker {
    func eat() {
        // Robots can't eat!
        fatalError("Robots does not eat!")
    }
    
    func work() {
        print("working")
    }
}

/*
 In order to solve this problem, we must divide our responsibilities, which have an abstract structure, into basic parts.

 We are creating a new abstract structure called Feedable for the eat function, and the Workable abstract structure for the work function. Thus, we have divided our responsibilities.

 Now the Human class will inherit from Feeble and Workable, and the Robot class from Workable only.

 Thus, we do not impose any unnecessary responsibility on any class and we create a structure suitable for the ISP.
 */

protocol Feedable {
    func eat()
}

protocol Workable {
    func work()
}

class Human: Feedable, Workable {
    func eat() {
        print("eating")
    }

    func work() {
        print("working")
    }
}

class Robot: Workable {
    func work() {
        print("working")
    }
}

// MARK: - Dependency Inversion Principle
// High level modules should not be depend on low level modules. Both should depend on Abstraction.
// Abstraction should not depend on details. Details should depend on abstraction.

// Let’s look at our example below with theoretical information.

struct Employee {
    func work() {
        print("working...")
    }
}

struct Employer {
    var employees: [Employee]
    
    func manage() {
        employees.forEach { employee in
            employee.work()
        }
    }
}

func run() {
    let employer = Employer(employees: [Employee()])
    employer.manage()
}

/*
 We have an employee structure and this structure has a work function. We also have an Employer structure and this structure enables existing employees to work.
 An employer object is created in the run function and by default, it takes the array Employee. Again, everything is fine so far, probably our project will work, but there is something we missed here. The Employer structure is directly linked to the non-abstract Employee structure. This is the point where we need the DIP.
 */

protocol Workable {
    func work()
}

struct Employee: Workable {
    func work() {
        print("working...")
    }
}

struct Employer {
    var workables: [Workable]
    
    func manage() {
        workables.forEach { workable in
            workable.work()
        }
    }
}

func example() {
    let employer = Employer(workables: [Employee()])
    employer.manage()
}

/*
 Using the theoretical knowledge of DIP, we know that structures should depend on an abstract model.

 So, we created an abstract Workable structure and depend the Employee class to Workable so that the Employee structure retains its original functions.

 The point is that the Employer class now expects the array of the abstract struct Workable instead of the array Employee. Thus, we have linked the dependency of the Employer structure to an abstract module. This means that the Employer structure has come to the point where it can run any structure depend to the Workable module.
 */

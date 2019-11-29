
### Chapter 2
Three steps towards better programmer:
`syntax` -> `semantics` -> `pragmatics`

#### Key Concepts
* Not every class is a program. In order to define a program, a class must include a subroutine named main.
* Interpreter calls the main function (which has to be public)
* classname must be consistent with filename.
* Most Java programmers do not use underscores in names
* primitives: byte, short, int, long, float, double, char, and boolean
* a numeric literal that begins with a 0 is interpreted as an octal number

| Type        | Byte    |
| :---------- | :------ |
| Short       | 2       |
| Int         | 4       |
| Long        | 8       |
| float       | 4       |
| double      | 8       |

```
# equivalent to x-= 1, y = x
y = --x
```
* **short-circuited** `&&` `||`:  second operand of && or || is not necessarily evaluated
* conditional operator: `next = (N % 2 == 0) ? (N/2) : (3*N+1);`
*  **Enum**: enum is a data type that can be created by a Java programmer to represent a small collection of possible values.
* an enum is a class and its possible values are objects.
* STATIC: class method
* non static: instance method

```Java
enum Season { SPRING, SUMMER, FALL, WINTER }
Season vacation = Season.SPRING;
int idx = Season.SPRING.ordinal():
```

#### Control Structure
```Java
int number; // The number to be printed.
number = 1; // Start with 1.
while(number<6){ //Keepgoingaslongasnumberis<6.
   System.out.println(number);
   number = number + 1;  // Go on to the next number.
}
System.out.println("Done!");

if ( x > y ) {
  int temp;
  temp = x;
  x = y;
  y = temp;
}

/**
 * It is valid only within the for statement and does not extend
 * to the remainder of the block that contains the for statement.
 */
for(years=0; years<5; years++){
  interest = principal * rate;
  principal += interest;
  System.out.println(principal);
}

if (temperature < 50)
  System.out.println("It’s cold.");
else if (temperature < 80)
  System.out.println("It’s nice.");
else
  System.out.println("It’s hot.");

switch ( N ) {   // (Assume N is an integer variable.)
  case 1:
    System.out.println("The number is 1.");
    break;
  case 2:
  case 4:
  case 8:
    System.out.println("The number is 2, 4, or 8.");
    System.out.println("(That’s a power of 2!)");
    break;
  case 3:
  case 6:
  case 9:
    System.out.println("The number is 3, 6, or 9.");
    System.out.println("(That’s a multiple of 3!)");
    break;
  case 5:
    System.out.println("The number is 5.");
    break;
  default:
    System.out.println("The number is 7 or is outside the range 1 to 9.");
}

// BRACKET IS MANDATORY, EVEN IF ONLY HAS ONE-LINE STATEMENT
try {
  double x;
  x = Double.parseDouble(str);
  System.out.println( "The number is " + x );
}
catch ( NumberFormatException e ) {
  System.out.println( "Not a legal number." );
}
```

#### Pragmatics
* Declare important variables at the beginning of the subroutine, and use a comment to explain the purpose of each variable.

___
### Chapter IV Subroutine
Every subroutine in Java must be defined inside some class.

```
⟨modifiers ⟩ ⟨return-type ⟩ ⟨subroutine-name ⟩ ( ⟨parameter-list ⟩ ) {
  ⟨statements ⟩
}
```

* access specifiers: `public`, `private`, `protected`
  - `final`: read only, *named constant*: `final static double INTEREST RATE = 0.05;` full-cap naming convention
  - enums are named constant `enum Alignment { LEFT, RIGHT, CENTER }`, three constants are public final static members of that class.
* It is not legal to have one subroutine physically nested inside another.
* *member variables*: not part of any subroutine
  * static member var (class var) is created as soon as the class is loaded by the Java interpreter, and the initialization is also done at that time.
  * can do `static double interestRate = 0.05;`, but cannot break into two lines.
* static variable: can be set in one subroutine and used in another subroutine.
  * outside any subroutine (although it still has to be inside a class)
```
static String usersName;
public static int numberOfPlayers;
private static double velocity, time;
```
* Overloading: same name, provided that their signatures are different
  * illegal to have two subroutines in the same class that have the same signature but that have different return types
* Exception check
```Java
if (usersGuess <= 0) {
    throw new IllegalArgumentException("Must be 1~100!");
}
```

* Main function takes array type parameter: `public static void main(String[] args) { ... }`
* Import: `import java.awt.Color;`, later just use `Color`
* `java.lang` is so fundamental, all the classes in java.lang are auto- matically imported into every program

#### javadoc
Doc tags:
* @param ⟨parameter-name⟩ ⟨description-of-parameter⟩
* @return ⟨description-of-return-value⟩
* @throws ⟨exception-class-name⟩ ⟨description-of-exception⟩

```
/**
  * This subroutine computes the area of a rectangle, given its width
  * and its height.  The length and the width should be positive numbers.
  * @param width the length of one side of the rectangle
  * @param height the length the second side of the rectangle
  * @return the area of the rectangle
  * @throws IllegalArgumentException if either the width or the height
  *    is a negative number.
  */
```

* Be careful when initializing multiple parameters:

```
char firstInitial = ’D’, secondInitial = ’E’;
int x, y = 1; // OK, but only y has been initialized!
intN=3,M=N+2; //OK,Nisinitialized
              //        before its value is used.
```

> And in fact such “toolmaking” programmers often have more prestige than the applications programmers who use their tools.

#### Scope
* The scope of a static subroutine is the entire source code of the class in which it is defined.
* It is legal to have a local variable or a formal parameter that has the same name as a member variable.
  - to use member variable in local scope, use `⟨className⟩.⟨variableName⟩`
* It is not legal to redefine the name of a formal parameter or local variable within its scope,

```
void  badSub(int y) {
  int x;
  while (y > 0) {
    int x; // ERROR: x is already defined.
  }
}
```

___
### Chapter V: Objects & Classes
* A variable can only hold a reference to an object.
* there is a special portion of memory called the `heap` where objects live
* test null pointer: `if (std == null) . . .`
* `!=` test reference, not values
  - This explains why using the == operator to test strings for equality is not a good idea.
* declaring a variable to be final only makes the reference read-only, the object itself can change
* declare all variables private, use getter & setter to access it
  - By convention, the name of an accessor method for a variable is obtained by capitalizing the name of variable and adding “get” in front of the name.
  - The name of a setter method should consist of “set” followed by a capitalized copy of the variable’s name
  - Allows for flexible implementation without changing public interface.
  - can define get and set methods even if there is no variable.
  - A getter and/or setter method defines a **property** of the class, that might or might not correspond to a variable.

> Well-designed classes are software components that can be reused without editing. A well- designed class is not carefully crafted to do a particular job in a particular program. Instead, it is crafted to model some particular type of object or a single coherent concept.

```java
public String getTitle() {
  return title;
}

public void setTitle( String newTitle ) {
  title = newTitle;
}
```

* Init instance vars the same way as class var
  - class var default var is assigned only once
  - instance var default vat is assigned to every instantiation
```java
public class PairOfDice {
  public int die1 = 3;   // Number showing on the first die.
  public int die2 = 4;   // Number showing on the second die.
  public void roll() {
    // Roll the dice by setting each of the dice to be
    // a random number between 1 and 6.
    die1 = (int)(Math.random()*6) + 1;
    die2 = (int)(Math.random()*6) + 1;
  }
} // end class PairOfDice
```

#### Constructor
* A constructor does not have any return type (not even void).
* The name of the constructor must be the same as the name of the class in which it is defined.
* The only modifiers that can be used on a constructor definition are the access modifiers public, private, and protected. (no static)
* It is illegal to assign a value to a final instance variable, except inside a constructor.

```java
public class PairOfDice {
   public int die1;   // Number showing on the first die.
   public int die2;   // Number showing on the second die.
   public PairOfDice() {
       // Constructor.  Rolls the dice, so that they initially
       // show some random values.
       roll();  // Call the roll() method to roll the dice.
   }
   public PairOfDice(int val1, int val2) {
       // Constructor.  Creates a pair of dice that
       // are initially showing the values val1 and val2.
       die1 = val1;  // Assign specified values
       die2 = val2;  //            to the instance variables.
   }
   public void roll() {
       // Roll the dice by setting each of the dice to be
       // a random number between 1 and 6.
       die1 = (int)(Math.random()*6) + 1;
       die2 = (int)(Math.random()*6) + 1;
   }
} // end class PairOfDice
```

#### Built-in Classes
* The class StringBuffer makes it possible to be effi- cient about building up a long string from a number of smaller pieces.

```java
StringBuffer buffer = new StringBuffer();
buffer.append(x);
buffer.toString();
```

#### Wrapper Class
Wrap primitives as object.
```Java
Double d = new Double(6.0221415e23);
Integer answer = new Integer(42);

// after Java 5.0, autoboxing
Integer answer = 42;

// auto-unboxing: convert object to primitive
int = answer * 2;

// other useful functions
Integer.MIN_VALUE
Integer.MAX_VALUE
Double.MIN_VALUE
Double.MAX_VALUE
Float.MIN_VALUE
Float.MAX_VALUE
Double.POSITIVE_INFINITY
Double.NEGATIVE_INFINITY
Double.NaN
Double.isInfinite(x)
Double.isNaN(x)

// warning: the following are always false
x == Double.NaN
x != Double.NaN
```

#### Base Class: Object
* Overwrite ` public String toString() {` for debugging

#### Software lifecycle
1. specify problem
2. analysis
3. design
4. coding
5. testing, debug
6. maintenance

#### Subclassing
`public class BlackjackHand extends Hand {...}`
* **protected**
  - that member can be used in subclasses—direct or indirect—of the class in which it is defined, but it cannot be used in non-subclasses.
  - A protected member can also be accessed by any class in the same package as the class that contains the protected member.
  - strictly more liberal than using no modifier at all, accessible from subclasses that are not in the same package
  - it is part of the implementation of the class, rather than part of the public interface of the class.
  - An even better idea would be to define protected setter methods for the variables
* A variable that can hold a reference to an object of class A can also hold a reference to an object belonging to any subclass of A.
 - opposite direction, use type-casting (`ClassCastException` is caught at run time, not compile time)

#### Polymorphism
A method is polymorphic if the action performed by the method depends on the actual type of the object to which the method is applied.

* Polymorphism just means that different objects can respond to the same message in different ways.
* Superclass methods are declared **abstract**

#### Abstract Classes
* Used to make subclasses
* The opposite is **concrete class**
* Cannot instantiate objects

```Java
public abstract class Shape {
  Color color;   // color of shape.
  void setColor(Color newColor) {
    // method to change the color of the shape
    color = newColor; // change value of instance variable
    redraw(); // redraw shape, which will appear in new color
  }
  abstract void redraw();
  // abstract method---must be defined in
  // concrete subclasses

} // end of class Shape
```

#### This & Super
**this** used in the source code of an instance method to refer to the object that contains the method
* One common use of this is in constructors.

```Java
public class Student {
  private String name;  // Name of the student.
  public Student(String name) {
    // Constructor.  Create a student with specified name.
    this.name = name;
  }
}
```

**super** forgets that the object belongs to the class you are writing, and it remembers only that it belongs to the superclass of that class.
* access to things in the superclass that are hidden by things in the subclass.
* The major use of super is to override a method with a new method that extends the behavior of the inherited method, instead of replacing that behavior entirely.

**constructors** are not inherited. That is, if you extend an existing class to make a subclass, the constructors in the superclass do not become part of the subclass.
* It looks like you are calling super as a subroutine `super()`;

#### Interface
* In Java, a type can be either a class, an interface, or one of the eight built-in primitive types.
* Similar to abstract class
* A class can implement multiple interfaces
* Can use interface as type

```java
public interface Drawable {
    public void draw(Graphics g);
}

public class Line implements Drawable {
   public void draw(Graphics g) {
       . . . // do something---presumably, draw a line
   }
   . . . // other methods and variables
}
```

___
### Data Structure
Array is filled with default: zero for numbers, false for boolean, the character with Unicode number zero for char, and null for objects.

Variable length array: `import java.util.ArrayList;`
```Java
int[] list;
list = new int[5]; // must specify length (final)
int[] list = { 1, 4, 9, 16, 25, 36, 49 }; // init with known values, cannot assign to existing var
list = new int[] { 1, 8, 27, 64, 125, 216, 343 }; // can assign to existing var

// both are acceptable
int[] list; // java encouraged
int list[]; // same as C, C++

// do any necessary initialization
// use <, not <=
for (int i = 0; i < A.length; i++) {
   // process A[i]
}

// copy array
double B = new double[A.length];
System.arraycopy(A, 0, B, 0, A.length);

// fast enumeration
// for-each loop processes the values in the array, not the elements
for ( int item : A )
  System.out.println( item );

```

Variable arity array as arguments
- treated as an array
- can also pass in array
- `...` applied only to the last formal parameter in a method definition.
```Java
public static double average( double...  numbers ) {

public static String concat( Object... values ) {
   StringBuffer buffer;  // Use a StringBuffer for more efficient concatenation.
   buffer = new StringBuffer();  // Start with an empty buffer.
   for ( Object obj : values ) { // A "for each" loop for processing the values.
       buffer.append(obj); // Add string representation of obj to the buffer.
   }
   return buffer.toString(); // return the contents of the buffer
}
```

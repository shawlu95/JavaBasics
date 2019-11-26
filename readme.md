
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
#### Enum
An enum is a data type that can be created by a Java programmer to represent a small collection of possible values.
* an enum is a class and its possible values are objects.

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

for(years=0; years<5; years++){
  interest = principal * rate;
  principal += interest;
  System.out.println(principal);
}
```

#### Pragmatics
* Declare important variables at the beginning of the subroutine, and use a comment to explain the purpose of each variable.
*

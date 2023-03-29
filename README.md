# Command Interpreter
The interpreter command function expects two parameters: a string representing a program consisting of multiple lines, and a file path to specify where the output will be written. It will then execute the program and log the evaluated output into the specified file. Upon completion, the function will return a unit value indicating the completion of the operation.

## Requirements
The interpreter requires OCaml and preferably [UTop](https://opam.ocaml.org/blog/about-utop/) for the execution of code.

## Usage
The interpreter can be used by utilizing UTop and calling various functions provided below.
```
utop
#use "inter.ml";;
interpreter "<commands>" "<file name>"
```
Example:
```
utop
#use "inter.ml";;
interpreter "Push 5\nPush 5\nAdd\nQuit" "output"
```

## Functions
### Push
Regardless of the type of constant, all are added to the stack in the same manner. The constant value is evaluated and then added to the stack in its appropriate data type format.

### Pop
The Pop function removes the highest value from the stack. However, the program will stop with an error message if any of the following situations occur:

* The stack contains less than one element.
* There are no values left in the stack to remove.

### Add
The Add function retrieves the two highest values from the stack, adds them together, and then adds the sum back to the stack. However, the program will stop with an error message in any of the following situations:

* The stack contains less than two values.
* The top two values on the stack are not both integers.

### Sub
The Sub function retrieves the two highest values from the stack, subtracts the second value from the top value, and then adds the difference back to the stack. However, the program will stop with an error message in any of the following situations:

* The stack contains less than two values.
* The top two values on the stack are not integers.

### Mul
The Mul function retrieves the two highest values from the stack, multiplies them together, and then adds the product back to the stack. However, the program will stop with an error message in any of the following situations:

* The stack contains less than two values.
* The top two values on the stack are not integers.

### Div
The Div function retrieves the two highest values from the stack, divides the top value by the second value, and then adds the quotient back to the stack. However, the program will stop with an error message in any of the following situations:

* The stack contains less than two values.
* The second value is zero, which would result in a division by zero error.
* The top two values on the stack are not integers.

### Swap
The Swap function rearranges the order of the two highest values in the stack. However, if the stack contains less than two items, the program will stop and display an error message.

### Neg
The Neg operation changes the sign of the value at the top of the stack. If the top value is not an integer, the program will stop with an error. Similarly, if the stack is currently empty, the program will terminate with an error.

### Concat
The Concat function takes the two highest values on the stack as input, combines them into a single string, and then adds this new string back to the stack.

### Quit
The Quit command will halt the interpreter at any point in the program, not just at the end. Once executed, the program will write the current stack to a specified output file, which is the second argument of the main function. Any commands that come after the Quit call will not be evaluated.

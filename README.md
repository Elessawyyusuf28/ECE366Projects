# ECE 366 Project 2 - Progress Report 1

**Course:** ECE 366 - Computer Organization  
**Semester:** Fall 2026  
**Date:** November 11, 2026

## Team Members

- Yusuf Elessawy - yeles
- Husaam Khan - hkhan216
- Salah El Hilo - selhi

## Summary of Project Status

For Progress Report 1, we implemented the Fibonacci(n) function using MIPS assembly in the MARS simulator. The program loads a nonnegative integer from memory, calculates the nth Fibonacci number, and stores the result in a separate memory location.

The program handles the base cases where n = 0 or n = 1 and uses a loop to calculate the Fibonacci number for larger values.

## Team Member Responsibilities

- Yusuf Elessawy: Fibonacci program implementation and simulation.
- Husaam Khan: IsOdd program using division by repeated subtraction.
- Salah El Hilo: Integration of the Fibonacci and IsOdd functions and final program testing.

## How to Run the Program

1. Open the MARS MIPS simulator.
2. Open Fibonacci.asm.
3. Change the value of n in the data section to the desired input.
4. Assemble the program by pressing F3.
5. Run the program by pressing F5.
6. View the result in the Data Segment at memory address 0x10010004.

The input is stored at memory address 0x10010000.

## Simulation Results

The program was tested using the following inputs in MARS:

| Input | Expected Output | Actual Output |
|---|---|---|
| 0 | 0 | 0 |
| 1 | 1 | 1 |
| 5 | 5 | 5 |
| 7 | 13 | 13 |
| 10 | 55 | 55 |

All five test cases produced the expected results.

## Next Steps

For Progress Report 2, we will implement the IsOdd function using division by repeated subtraction. For the final report, we will combine both functions to determine whether the nth Fibonacci number is odd.

## GitHub Repository

https://github.com/Elessawyyusuf28/ECE366Projects
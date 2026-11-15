# ECE 366 Project 2 - Progress Report 2

**Course:** ECE 366 - Computer Organization  
**Semester:** Fall 2026  
**Date:** November 14, 2026

## Team Members
- Yusuf Elessawy (yeles)
- Husaam Khan (hkhan216)
- Salah El Hilo (selhi)

## Project Summary
For this progress report, we completed Part B of Project 2, which determines whether a number is odd or even using MIPS assembly. The program uses division by repeated subtraction to find the remainder when a number is divided by 2.

If the remainder is 0, the program returns 0 for even. Otherwise, it returns 1 for odd. The result is stored in memory.

## Contributions
- Yusuf: Program testing and verification in MARS.
- Husaam: Implementation of the IsOdd function and division by repeated subtraction.
- Salah: Preparation for combining the Fibonacci and IsOdd functions in Part C.

## How to Run
1. Open IsOdd.asm in MARS.
2. Change the value of m in the data section.
3. Assemble the program using F3.
4. Run the program using F5.
5. Check the result in the Data Segment at address 0x10010004.

A result of 0 means even, and a result of 1 means odd.

## Testing Results

| Input | Expected Output | Actual Output |
|---|---|---|
| 0 | 0 | 0 |
| 1 | 1 | 1 |
| 2 | 0 | 0 |
| 7 | 1 | 1 |
| 8 | 0 | 0 |
| 15 | 1 | 1 |

All six test cases passed successfully in MARS.

## Next Steps
For the final report, we will combine the Fibonacci and IsOdd functions to determine whether the nth Fibonacci number is odd.

## GitHub
https://github.com/Elessawyyusuf28/ECE366Projects

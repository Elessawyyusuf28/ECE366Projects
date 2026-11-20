# ECE 366 Project 2 Final Report

ECE 366 Computer Organization, Fall 2026  
November 19, 2026

## Team Members and Contributions

| Team member | NetID | Contribution |
|---|---|---|
| Yusuf Elessawy | yeles | Program testing and verification in MARS for Progress Report 2. |
| Husaam Khan | hkhan216 | Implemented IsOdd and division by repeated subtraction. |
| Salah El Hilo | selhi | Integrated Fibonacci and IsOdd into the final IsFibonacciOdd program. |

Each team member completed their assigned part and sent their work to Yusuf. Yusuf then organized the files and uploaded the team's work to the GitHub repository.

## Project Summary

The program reads the nonnegative integer `n` from memory. `IsFibonacciOdd`
calls `Fibonacci` to compute the nth Fibonacci number and passes it to
`IsOdd`. The division routine subtracts 2 repeatedly to find the remainder.
The program stores that remainder at `result`, where 1 means odd and 0 means even.

## How to Run

1. Extract the submission archive and open `IsFibonacciOdd.asm` in MARS.
2. If MARS is set to assemble all files in the directory, turn that setting off
   before assembling. This file contains the full program.
3. Set `n` in the data section. Use small nonnegative values for quick runs.
4. Assemble with F3 and run with F5. Reassemble after each change to `n`.
5. Read `result` in the Data Segment. With the default memory configuration,
   it is the second word at `0x10010004`.

The Fibonacci number must fit in a signed 32-bit word (up to n = 46).
Repeated subtraction can make larger inputs slow to run.

## Expected Results

| n | Fibonacci(n) | Value at result |
|---:|---:|---:|
| 0 | 0 | 0 |
| 1 | 1 | 1 |
| 2 | 1 | 1 |
| 3 | 2 | 0 |
| 9 | 34 | 0 |
| 10 | 55 | 1 |

## GitHub

[Team repository](https://github.com/Elessawyyusuf28/ECE366Projects)

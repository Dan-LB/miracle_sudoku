# Miracle Sudoku Solver and Generator
## Overview
This project consists in a MiniZinc solver for *Miracle Sudoku*, a Sudoku variant with additional constraints of various kinds, and a Miracle Sudoku generator, able to produce (uniquely determined) Sudoku with a desidered ruleset from a large selection.

## So, what is a Miracle Sudoku?
The first, original "Miracle Sudoku" was ideated by Mitchell Lee and presented on YouTube by Simon Anthony of *Cracking the Cryptic* in [this](https://www.youtube.com/watch?v=yKf9aUIxdb4) video. It consists in a Sudoku board with only $2$ given digits and a slightly more complex ruleset, in particular in addition to the classic Sudoku rules, there are
* Two *uniqueness* rules:
	* Cells which are separated by a Chess King's move (adjacent  cells) cannot contain the same digit
	* Cells which are separated by a Chess Knight's move (**L** spaced cells) cannot contain the same digit
* A *successor* rule:
	* Orthogonally adjacent cells cannot contain consecutive digits.

The interesting thing about this puzzle is that, despite having a very small amount of starting digits, it is fully resolvable (i.e. it has only one possible solution).



   <details>
      <summary>The original Miracle Sudoku</summary>
      
	    - - -  - - -  - - -  
	    - - -  - - -  - - -  
	    - - -  - - -  - - -  
	    
	    - - -  - - -  - - -  
	    - - 1  - - -  - - -  
	    - - -  - - -  2 - -  
	    
	    - - -  - - -  - - -  
	    - - -  - - -  - - -  
	    - - -  - - -  - - - 
 
</details>



<details>
  <summary>And the solution</summary>

	4 8 3  7 2 6  1 5 9  
	7 2 6  1 5 9  4 8 3  
	1 5 9  4 8 3  7 2 6  

	8 3 7  2 6 1  5 9 4  
	2 6 1  5 9 4  8 3 7  
	5 9 4  8 3 7  2 6 1  

	3 7 2  6 1 5  9 4 8  
	6 1 5  9 4 8  3 7 2  
	9 4 8  3 7 2  6 1 5
    
</details>


More in general, with Miracle Sudoku I will consider Sudoku variants with any sort of combinatorial constraints, such that with a somewhat small amount of starting digits leads to a single, unique solution.

For more examples, you can check [The Dutch Miracle](https://www.youtube.com/watch?v=wUnnXwLTbnA&t=457s) by Aad Van De Wetering, or [Dotless Kropki Sudoku X](https://www.youtube.com/watch?v=1QP7yviZYTU&t=262s) by Phistomefel, again on Cracking the Cryptic.

## Constraints

Constraints for a Miracle Sudoku could be very different from each other. For the sake of simplicity I decided to consider only "structure independent" constraints, i.e. constraints that do not require any kind of additional input. The considered constraints can  be divided into $6$ groups. Here it follows the groups list with a few examples:
1. Uniqueness:
	* Each digits appears exactly once in a principal diagonal 
	* Each digits appears at most once in every diagonal along a specified direction
2. Chess-like:
	* The same digits are not connected by a knight move 
3. Successor:
	* No digits in vertically or horizontally adjacent cells can be consecutive digits 
4. "Whisper":
	* Digits in vertically or horizontally adjacent cells must differ at least **n**
5. Order:
	* Digits in the first column are in ascending or descending order (e.g. 456789123)
6. Parity:
	* Digits in the center of each subsquare is even

Of course, some constraints are stronger than others. It is interesting to note that uniqueness rules are combinatorial, therefore given a solution $S$ and a permutation $\rho$ of digits in $1..9$, then $\rho(S)$ is a new solution. This means that an empty board with only combinatorial constraints has either no solutions (for example, in the case of uniqueness rule for every diagonals), or at least $9!$.
Solutions for successor rules are not permutation invariant, but they are invariant under shifts (i.e. $1\to 2, 2\to 3,\dots$), so if there are a solution for an empty board, there are at least 9 of them. 
Whisper rules are far more restrictive, and in general the solutions are not shift-invariant.

For the full list of constraints actually avaible, check the  `constraint_list` file.

## MiniZinc Solver Syntax

The syntax of the Data files for the solver is very straightforward. The starting position is given by the `start` array, as in the MiniZinc [tutorial](https://www.minizinc.org/doc-2.5.5/en/modelling2.html?highlight=sudoku) for the sudoku solver. The rules must be declared as boolean variables. Here it follows the Data file for the original Miracle Sudoku:  

	%	 ___________________
	%	|     RULE LIST     |
	%	|___________________|
	
	
	%  UNIQUENESS RULES
	DIAGONAL_LtR = false;
	DIAGONAL_RtL = false;

	MULTI_DIAGONAL_LtR = false;
	MULTI_DIAGONAL_RtL = false;

	SQUARE_POS = false;

	%  CHESS RULES
	KING = true;
	KNIGHT = true;
	PLUS =  false;
	CROSS = false;

	%  SUCCESSOR RULES
	ORTHOGONAL = true;
	DIAGONAL = false;

	%  WHISPER RULES
	ORTHOGONAL_WHISPER = false;

	DIAGONAL_WHISPER_LtR = false;
	DIAGONAL_WHISPER_RtL = false;

	%	ORDER RULES
	FIRST_COLUMN_ORDER = false;
	FIRST_ROW_ORDER = false;

	LAST_COLUMN_ORDER = false;
	LAST_ROW_ORDER = false;

	%  PARITY RULES
	CENTER_EVEN = false;
	CENTER_ODD = false; 

	%	 ___________________
	%	| STARTING BOARD    |
	%	|___________________|

	start=[|
	0, 0, 0, 0, 0, 0, 0, 0, 0|
	0, 0, 0, 0, 0, 0, 0, 0, 0|
	0, 0, 0, 0, 0, 0, 0, 0, 0|
	0, 0, 0, 0, 0, 0, 0, 0, 0|
	0, 0, 1, 0, 0, 0, 0, 0, 0|
	0, 0, 0, 0, 0, 0, 2, 0, 0|
	0, 0, 0, 0, 0, 0, 0, 0, 0|
	0, 0, 0, 0, 0, 0, 0, 0, 0|
	0, 0, 0, 0, 0, 0, 0, 0, 0|];

## The Generator
The generator is a small program in Python that uses the Solver to generate an uniquely determined Sudoku board with a given set of rules and with some starting numbers.
The idea is to:
* Read the starting digits in the file `starting_board`
* Pass the rules from the list of constraints
* As long as the solution of the sudoku is not uniquely determined, keep adding digits to reduce the number of solutions
* Give in output (in the file `solution`) the completed starting board and the solution.

For example, for the original Miracle Sudoku, you can write in the command line
    `python Generator.py  KNIGHT KING ORTHOGONAL`
and provide the starting digits.
Due to the fact that a Miracle with these starting digits is already uniquely determined, the generator will generate the given board! However, you can provide a different starting board (even an empty one!) and get a different uniquely determined board.

If you want to use non-boolean constraints (for example, whispers), then the syntax is slightly different, as you need to provide the int value in this way: "rule_name=n". For example, if you want to add a diagonal whisper rule you can write
    `python Generator.py  KNIGHT DIAGONAL_WHISPER_LtR=3`

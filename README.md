# Miracle Sudoku Solver and Generator
## Overview
This project consists in a MiniZinc solver for *Miracle Sudoku*, a Sudoku variant with additional constraints of various kinds (check [this](https://www.youtube.com/watch?v=yKf9aUIxdb4) for the original Miracle Sudoku, by Mitchell Lee), and a Miracle Sudoku generator, able to produce (uniquely determined) Sudoku with a desidered ruleset from a large selection.

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

	    7 9 2  4 8 6  1 5 3  
	    3 1 5  7 9 2  4 8 6  
	    6 4 8  3 1 5  7 9 2  
	    
	    2 7 9  6 4 8  3 1 5  
	    5 3 1  2 7 9  6 4 8  
	    8 6 4  5 3 1  2 7 9  
	    
	    9 2 7  8 6 4  5 3 1  
	    1 5 3  9 2 7  8 6 4  
	    4 8 6  1 5 3  9 2 7 
    
</details>


More in general, with Miracle Sudoku I will consider Sudoku variants with any sort of combinatorial constraints, that with a somewhat small amount of starting digits leads to a single, unique solution.

For more examples, you can check [The Dutch Miracle](https://www.youtube.com/watch?v=wUnnXwLTbnA&t=457s) by Aad Van De Wetering, or [Dotless Kropki Sudoku X](https://www.youtube.com/watch?v=1QP7yviZYTU&t=262s) by Phistomefel, again on Cracking the Cryptic.

## Currently available constraints

Constraints for a Miracle Sudoku could be very different from each other. For the sake of simplicity I decided to consider only "structure independent" constraints, i.e. constraints that do not require any kind of input. The considered constraints could be divided into $3$ groups:
1. Uniqueness rules:
	* Each digits appears exactly once in a principal diagonal 
	* Each digits appears at most once in every diagonal along a specified direction
	* The same digits are not king-knight move connected
	* The same digits are not chess-knight move connected
2. Successor rules:
	* No digits in vertically or horizontally adjacent cells can be consecutive digits 
	* No digits in diagonal adjacent cells can be consecutive digits 
3. "Whisper" rules:
	* Digits in vertically or horizontally adjacent cells must differ at least **n**
	* Digits in diagonal adjacent cells must differ at least **n**

Of course, some constraints are stronger than others. It is interesting to note that uniqueness rules are combinatorial, therefore given a solution $S$ and a permutation $\rho$ of digits in $1..9$, then $\rho(S)$ is a new solution. Successor rules are not permutation invariant, but they are invariant under shifts (i.e. $1\to 2, 2\to 3,\dots$), while whisper rules are more complex, and in general they are not shift-invariant.

## MiniZinc Solver Syntax

The syntax of the Data files for the solver is very straightforward. The starting position is given by the `start` array, as in the MiniZinc [tutorial](https://www.minizinc.org/doc-2.5.5/en/modelling2.html?highlight=sudoku) for the sudoku solver. The rules must be declared as boolean variables. Here it follows the Data file for the original Miracle Sudoku:  

    %UNIQUENESS RULES
	DIAGONAL_LtR = false;
	DIAGONAL_RtL = false;

	MULTI_DIAGONAL_LtR = false;
	MULTI_DIAGONAL_RtL = false;

	KING = true;
	KNIGHT = true;

	%SUCCESSOR RULES
	ORTHOGONAL = false;
	DIAGONAL = false;

	%WHISPER RULES
	ORTHOGONAL_WHISPER = false;

	DIAGONAL_WHISPER_LtR = false;
	DIAGONAL_WHISPER_RtL = false;



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


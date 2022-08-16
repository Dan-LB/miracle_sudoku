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

# Constraint list
Here it follows the list of actually available constraints with a very short description.
Each of them should be declared in the Data file for the solver, as, for example, `DIAGONAL_LtR = false;`.
For the Generator you have to provide just the rules you want to use.


For the diagonal rules, LtR ("Left to Right") can be seen as the diagonal connecting the "North West" corner to the "South East" one, and RtL as the NE to SW one.

## Uniqueness
* DIAGONAL_LtR
* DIAGONAL_RtL
Along the LtR or RtL diagonal there are not repeating digits.

* MULTI_DIAGONAL_LtR
* MULTI_DIAGONAL_RtL
Along every diagonal oriented as the LtR or RtL diagonal there are not repeating digits.

* SQUARE_POS
Each digits appear only once in each subsquare position (for example, there is a subsquare in which the digit 1 appears in the first cell, a subsquare in which it appears in the second cell, and so on).

## Chess
Chess constraints can be combined in interesting ways, e.g. KNIGHT, PLUS and CROSS, or KING, PLUS and CROSS.

* KING
Cells which are separated by a Chess King's move (adjacent cells) cannot contain the same digit.

* KNIGHT
Cells which are separated by a Chess Knight's move (L spaced cells) cannot contain the same digit.

* PLUS
Cells which are separated by a cell in horizontal or vertical cannot contain the same digit (the forbidden cells are in a '+' shape).

* CROSS
Cells which are separated by a cell in diagonal cannot contain the same digit (the forbidden cells are in a 'X' shape).

## Successor 
* ORTHOGONAL
Orthogonally adjacent cells cannot contain consecutive digits.
  
* DIAGONAL
Diagonally adjacent cells cannot contain consecutive digits.

## Whisper Rules
Whisper rules should be set as `false` or as a natural number `k`, e.g. `ORTHOGONAL_WHISPER=3;`

* ORTHOGONAL_WHISPER
Digits in vertically or horizontally adjacent cells must differ at least k.

* DIAGONAL_WHISPER_LtR
* DIAGONAL_WHISPER_RtL
Digits sharing the NW/SE (or the NE/SW) corner must differ at least k.

## Order
* FIRST_COLUMN_ORDER
* FIRST_ROW_ORDER
* LAST_COLUMN_ORDER
* LAST_ROW_ORDER
Digits in the specified line must be in ascending or descending order (e.g. 456789123)

## Parity
* CENTER_EVEN
* CENTER_ODD
Digits in the center of each subsquare must be of the specified parity.



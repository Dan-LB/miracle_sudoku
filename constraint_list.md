# Constraint list
Here it follows the list of actually available constraints with a very short description.
Each of them should be declared in the Data file for the solver, as, for example, `DIAGONAL_LtR = false;`.


For the diagonal rules, LtR ("Left to Right") can be seen as the diagonal connecting the "North West corner" to the "South East" one, and RtL as the NE to SW one.

## Uniqueness Rules

	DIAGONAL_LtR
	DIAGONAL_RtL
Along the LtR or RtL diagonal there are not repeating digits.

	MULTI_DIAGONAL_LtR
	MULTI_DIAGONAL_RtL
Along every diagonal oriented as the LtR or RtL diagonal there are not repeating digits.

	KING
Cells which are separated by a Chess King's move (adjacent cells) cannot contain the same digit.

	KNIGHT
Cells which are separated by a Chess Knight's move (L spaced cells) cannot contain the same digit.

## Successor Rules
	ORTHOGONAL
Orthogonally adjacent cells cannot contain consecutive digits.
  
	DIAGONAL
Diagonally adjacent cells cannot contain consecutive digits.
## Whisper Rules
Whisper rules should be set as `false` or as a natural number `k`, e.g. `ORTHOGONAL_WHISPER = 3;`

	ORTHOGONAL_WHISPER

Digits in vertically or horizontally adjacent cells must differ at least k.

	DIAGONAL_WHISPER_LtR
	DIAGONAL_WHISPER_RtL
Digits sharing the NW/SE (or the NE/SW) corner must differ at least k.

include "alldifferent.mzn";

%    UNIQUENESS RULES
bool: DIAGONAL_LtR;
bool: DIAGONAL_RtL;

bool: MULTI_DIAGONAL_LtR;
bool: MULTI_DIAGONAL_RtL;

bool: SQUARE_POS;

%    CHESS RULES
bool: KING;
bool: KNIGHT;
bool: PLUS;
bool: CROSS;

%    SUCCESSOR RULES
bool: ORTHOGONAL;
bool: DIAGONAL;

%    WHISPER RULES
int: ORTHOGONAL_WHISPER;

int: DIAGONAL_WHISPER_LtR;
int: DIAGONAL_WHISPER_RtL;

%	  ORDER RULES
bool: FIRST_COLUMN_ORDER;
bool: FIRST_ROW_ORDER;

bool: LAST_COLUMN_ORDER;
bool: LAST_ROW_ORDER;

%	PARITY
bool: CENTER_EVEN;
bool: CENTER_ODD;

%SETTINGS

int: S = 3;
int: N = 9;
int: digs = ceil(log(10.0,int2float(N))); % digits for output

set of int: PuzzleRange = 1..N;
set of int: SubSquareRange = 1..S;

array[1..N,1..N] of 0..N: start; %% initial board 0 = empty
array[1..N,1..N] of var PuzzleRange: puzzle;

% fill initial board
constraint forall(i,j in PuzzleRange)(
    if start[i,j] > 0 then puzzle[i,j] = start[i,j] else true endif );


%._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._.
%|.|             SUDOKU  RULES                                                     |.|
%._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._.


% All different in rows 
constraint forall (i in PuzzleRange) (
                   alldifferent( [ puzzle[i,j] | j in PuzzleRange ]) ); 

% All different in columns.
constraint forall (j in PuzzleRange) (
                   alldifferent( [ puzzle[i,j] | i in PuzzleRange ]) ); 

% All different in sub-squares:
constraint
        forall (a, o in SubSquareRange)(
                alldifferent( [ puzzle[(a-1) *S + a1, (o-1)*S + o1] |
                                        a1, o1 in SubSquareRange ] ) );


%._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._.
%|.|             SPECIAL  RULES                                                    |.|
%._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._.


%|    UNIQUENESS RULES  |
% \_____________________/

%  diagonal_LtR
constraint if DIAGONAL_LtR then
  alldifferent( [ puzzle[ i, i] |
    i in 1..N ] )  
endif;

%  diagonal_RtL
constraint if DIAGONAL_RtL then
  alldifferent( [ puzzle[10-i, i] |
    i in 1..N ] )  
endif;

%  multi_diagonal_LtR
constraint if MULTI_DIAGONAL_LtR then
  forall (i in 1..N) (
    alldifferent( [ puzzle[j+9-i, j] |
      j in 1..i ] ) /\
    alldifferent( [ puzzle[ 1+i-j, 10-j] | %reflection: (x,y) -> (10-x, 10-y)
      j in 1..i ] )       
      ) 
endif;

%  square_pos
constraint if SQUARE_POS then
  forall (k, l in 1..3) (
    alldifferent( [puzzle[ k+3*n, l+3*m ] |
      n, m in 0..2] )
     )      
endif;

%  multi_diagonal_RtL
constraint if MULTI_DIAGONAL_RtL then
  forall (i in 1..N) (
    alldifferent( [ puzzle[ i+1-j, j] |
      j in 1..i ] ) /\
    alldifferent( [ puzzle[ 10-j, 9-i+j] | %reflection: (x,y) -> (10-y, 10-x)
      j in 1..i ] )          
      ) 
endif;
      
 %|      CHESS RULES    |
% \_____________________/     
      
%  king             
constraint if KING then 
  forall (i, j in 1..8) (
    puzzle[i, j] != puzzle[i+1, j] /\
    puzzle[i, j] != puzzle[i, j+1] /\
    puzzle[i, j] != puzzle[i+1, j+1]  /\
    puzzle[i, j+1] != puzzle[i+1, j]
) endif;

%  knight
constraint if KNIGHT then
  forall (i in 1..7) (
    forall (j in 1..8) (
      puzzle[i, j] != puzzle[i+2, j+1]
)) endif;

constraint if KNIGHT then 
  forall (i in 1..7) (
    forall (j in 2..9) (
      puzzle[i, j] != puzzle[i+2, j-1]
)) endif;

constraint if KNIGHT then 
  forall (i in 1..8) (
    forall (j in 1..7) (
      puzzle[i, j] != puzzle[i+1, j+2]
)) endif;

constraint if KNIGHT then 
  forall (i in 2..9) (
    forall (j in 1..7) (
      puzzle[i, j] != puzzle[i-1, j+2]
)) endif;

%  plus
constraint if PLUS then 
  forall (i in 1..7) (
    forall (j in 1..9) (
        puzzle[i, j] != puzzle[i+2, j] /\
        puzzle[j, i] != puzzle[j, i+2]
)) endif;

%  cross
constraint if CROSS then 
  forall (i in 1..7) (
    forall (j in 1..7) (
        puzzle[i, j] != puzzle[i+2, j+2] /\
        puzzle[i, j+2] != puzzle[i+2, j]
)) endif;


%|    SUCCESSOR RULES   |
% \_____________________/

%  orthogonal
constraint if ORTHOGONAL then
  forall (i, j in 1..8) (
    puzzle[i, j] != puzzle[i+1, j] +1 /\
    puzzle[i, j] != puzzle[i+1, j] -1 /\
    puzzle[i, j] != puzzle[i, j+1] +1 /\
    puzzle[i, j] != puzzle[i, j+1] -1) 
  /\
  forall (i in 1..8) (
    puzzle[9,i] != puzzle[9, i+1] +1 /\
    puzzle[9,i] != puzzle[9, i+1] -1 /\
    puzzle[i,9] != puzzle[i+1, 9] +1 /\
    puzzle[i,9] != puzzle[i+1, 9] -1)  
  endif;

% diagonal          
constraint if DIAGONAL then
  forall (i, j in 1..8) (
    puzzle[i, j] != puzzle[i+1, j+1] +1 /\
    puzzle[i, j] != puzzle[i+1, j+1] -1 /\
    puzzle[i, j+1] != puzzle[i+1, j] +1 /\
    puzzle[i, j+1] != puzzle[i+1, j] -1)
  endif;       
                            

%|       WHISPER RULES  |
% \_____________________/

%  orthogonal_whisper
constraint if ORTHOGONAL_WHISPER != 0 then
  forall (i, j in 1..8) (
    (puzzle[i, j] - puzzle[i+1, j] >=  ORTHOGONAL_WHISPER \/
    puzzle[i, j] - puzzle[i+1, j] <=  -ORTHOGONAL_WHISPER) /\
    (puzzle[i, j] - puzzle[i, j+1] >=  ORTHOGONAL_WHISPER \/
    puzzle[i, j] - puzzle[i, j+1] <=  -ORTHOGONAL_WHISPER))
  /\
  forall (i in 1..8) (
    (puzzle[i, 9] - puzzle[i+1, 9] >=  ORTHOGONAL_WHISPER \/
    puzzle[i, 9] - puzzle[i+1, 9] <=  -ORTHOGONAL_WHISPER) /\
    (puzzle[9, i] - puzzle[9, i+1] >=  ORTHOGONAL_WHISPER \/
    puzzle[9, i] - puzzle[9, i+1] <=  -ORTHOGONAL_WHISPER))
endif;  

%  diagonal_whisper_LtR
constraint if DIAGONAL_WHISPER_LtR != 0 then
  forall (i in 1..(N-1)) (
    forall (j in 1..(N-1)) (
      puzzle[i, j] - puzzle[i+1, j+1] >= DIAGONAL_WHISPER_LtR \/
      puzzle[i, j] - puzzle[i+1, j+1] <= -DIAGONAL_WHISPER_LtR
))endif;                                                                                    
         
%  diagonal_whisper_RtL                                                                 
constraint if DIAGONAL_WHISPER_RtL != 0 then
  forall (i in 1..(N-1)) (
    forall (j in 2..N) (
    puzzle[i, j] - puzzle[i+1, j-1] >= DIAGONAL_WHISPER_RtL \/
    puzzle[i, j] - puzzle[i+1, j-1] <= -DIAGONAL_WHISPER_RtL
))endif; 


%|         ORDER RULES  |
% \_____________________/

%  first_column_order                                                                 
constraint if FIRST_COLUMN_ORDER then
  forall (i in 1..(N-1)) (
    (puzzle[i, 1] - puzzle[i+1, 1] + 9) mod 9 = 1) \/
  forall (i in 1..(N-1)) (
    (puzzle[i, 1] - puzzle[i+1, 1] + 9) mod 9 = 8) 
endif;

%  first_row_order                                                                 
constraint if FIRST_ROW_ORDER then
  forall (i in 1..(N-1)) (
    (puzzle[1, i] - puzzle[1, i+1] + 9) mod 9 = 1) \/
  forall (i in 1..(N-1)) (
    (puzzle[1, i] - puzzle[1, i+1] + 9) mod 9 = 8) 
endif;

%  last_column_order 
constraint if LAST_COLUMN_ORDER then
  forall (i in 1..(N-1)) (
    (puzzle[i, N] - puzzle[i+1, N] + 9) mod 9 = 1) \/
  forall (i in 1..(N-1)) (
    (puzzle[i, N] - puzzle[i+1, N] + 9) mod 9 = 8) 
endif;

%  last_row_order                                                                 
constraint if LAST_ROW_ORDER then
  forall (i in 1..(N-1)) (
    (puzzle[N, i] - puzzle[N, i+1] + 9) mod 9 = 1) \/
  forall (i in 1..(N-1)) (
    (puzzle[N, i] - puzzle[N, i+1] + 9) mod 9 = 8) 
endif;


%|       PARITY RULES   |
% \_____________________/

%  center even
constraint if CENTER_EVEN then 
  forall (k in 0..2) (
    forall (l in 0..2) (
        (puzzle[2+3*k, 2+3*l] mod 2) = 0
)) endif;

%  center odd
constraint if CENTER_ODD then 
  forall (k in 0..2) (
    forall (l in 0..2) (
        (puzzle[2+3*k, 2+3*l] mod 2) = 1
)) endif;


%._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._.
%|.|             SOLVING                                                           |.|
%._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._.

solve satisfy;



%._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._.
%|.|             OUTPUT PRINTING                                                   |.|
%._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._._.~._.

output  [ show_int(digs,puzzle[i,j]) ++ " " ++ 
         if j mod S == 0 then " " else "" endif ++ %primo "" -> " "
         if j == N then
             if i != N then 
                if i mod S == 0 then "\n\n" else "\n" endif 
         else "" endif else "" endif  
         | i,j in PuzzleRange ] ++ ["\n"];

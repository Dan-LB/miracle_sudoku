import random
import numpy as np
from minizinc import Instance, Model, Solver

import sys
import os

def print_sol(data):
    for i in range(0,9):
        for j in range(0, 9):
            d = int(data[i][j])
            if(d==0):
                d = "-"
            print(d, end=' ')  
            if(j%3 == 2):
                print(" ", end='')
        print("\n", end='')       
        if(i%3 == 2):
            print("\n", end='')
        
def save_sol(data):
    sol = ''
    for i in range(0,9):
        for j in range(0, 9):
            d = str(int(data[i][j]))
            if(d=="0"):
                d = "-"
            sol += d
            sol += " "
            if(j%3 == 2):
                sol += " "
        sol += "\n"      
        if(i%3 == 2):
            sol += "\n"
    return sol

def read_input():
    if(os.path.exists("starting_board.txt")):
        f = open("starting_board.txt", "r")
        B = np.zeros((9,9))
        raw = f.read()
        raw = raw.split("\n")
        while('' in raw):
            raw.remove('')
        i = 0
        for x in raw:
            row = x.split(" ")
            while('' in row):
                row.remove('')
            for j in range(0, 9):
                d = row[j]
                if (d == "-"):
                    d = 0
                B[i,j] = int(d)
            i += 1
        return B
    else:
        print("File starting_board.txt not found. Empty board created.")
        f = open("starting_board.txt", "a")
        empty_board = save_sol(np.zeros((9,9)))
        f.write(empty_board)
        f.close()
        return np.zeros((9,9))
    

#example rules            
def give_rules():
    return("""
            %  UNIQUENESS RULES
            DIAGONAL_LtR = false;
            DIAGONAL_RtL = false;
            
            MULTI_DIAGONAL_LtR = false;
            MULTI_DIAGONAL_RtL = false;
            
            SQUARE_POS = false;
            
            %  CHESS RULES
            KING = false;
            KNIGHT = false;
            PLUS =  false;
            CROSS = false;
            
            %  SUCCESSOR RULES
            ORTHOGONAL = false;
            DIAGONAL = false;
            
            %  WHISPER RULES
            ORTHOGONAL_WHISPER = false;
            
            DIAGONAL_WHISPER_LtR = false;
            DIAGONAL_WHISPER_RtL = false;
            
            %	  ORDER RULES
            FIRST_COLUMN_ORDER = false;
            FIRST_ROW_ORDER = false;
            
            LAST_COLUMN_ORDER = false;
            LAST_ROW_ORDER = false;
            
            %  PARITY RULES
            CENTER_EVEN = false;
            CENTER_ODD = false; 
           """)


#write the board in the MiniZinc Syntax
def from_matrix_to_board(matrix):
    board = "start=[|\n"
    for i in range(0,9):
        for j in range(0,9):
            board += str(int(matrix[i,j]))
            if(j != 8):             
                board += ", "
        if(i != 8):
            board += "|\n"
    board += "|];\n"
    return board




def compute_puzzle(B = np.zeros((9,9)), max_sol = 256, rules = give_rules(), rule_comment = None):
    gecode = Solver.lookup("gecode")
    
    given_board = B.copy()
    
    it = 1    
    print("Starting board:")
    
    while(True):
        
        if(it>1):            
            print("Iteration number "+str(it))
        it += 1
        board = from_matrix_to_board(B)
        print_sol(B)
        model = Model("miracle_sudoku_solver.mzn")
        model.add_string(rules)
        model.add_string(board)
        
        instance = Instance(gecode, model)
        
        results = instance.solve(nr_solutions = max_sol, optimisation_level = 5, processes = 4)
        
        nsol = len(results)
        if(nsol < max_sol and nsol > 1):
            print("There are exactly "+str(nsol)+" solutions.")
        elif(nsol > 1):
            print("There are at least "+str(max_sol)+" solutions.")

    
        
        if(nsol == 1):
            print("Uniqueness reached!")
            complete_board = results[0].puzzle
            print("\n Sudoku Solution: \n")
            print_sol(complete_board)
            
            f = open("solution.txt", "w")
            comment = "Your rules:\n" + "\n".join(rule_comment) + "\n\nUniqueness reached after "+str(it) +" iterations.\n\n"
            
            
            comment += "Given board:\n"
            given_string = save_sol(given_board)
            comment += given_string
            
            comment += "\nStarting board:\n"
            start_string = save_sol(B)
            comment += start_string
            
            comment += "\nSolution:\n"
            sol_string = save_sol(complete_board)
            comment += sol_string
            f.write(comment)
            f.close()
            
            return 0
        elif(nsol == 0):
            print("No solutions found.\nEither provide a less-restrictive starting board or remove some rules.")
            return 1
        else:
            keep_adding = True
            first_sol = results[0].puzzle
            second_sol = results[1].puzzle
            while(keep_adding):
                i = random.randint(0, 8)
                j = random.randint(0, 8)          
                
                if (first_sol[i][j] != second_sol[i][j]):
                    keep_adding = False
                    first_sol = results[0].puzzle
                    B[i,j] = first_sol[i][j]
                    
                    
        print("")

def read_rules(string):
    if(os.path.exists(string + "_constraint_list.txt")):
        f = open(string + "_constraint_list.txt", "r")
        rules_list = f.read().split('\n')
        f.close()
        while('' in rules_list):
            rules_list.remove('')
        return rules_list
    else:
        print("ERROR! \n File not found: " + string + "_constraint_list.txt.")
        return 0



def main():

    starting_board = read_input()
    args = sys.argv[1:]
    rule_string = ''  
    
    bool_rules = read_rules('bool')
    int_rules = read_rules('int')
    
    for rule in bool_rules:
        if(rule in args):
            new_s =  rule +" = true;\n"       
        else:
            new_s =  rule +" = false;\n"
        rule_string += new_s
        
    for rule in int_rules:
        done = False
        for arg in args:
            if(arg.split('=')[0] == rule):
                # exists
                new_s =  rule +" = " + arg.split('=')[1] + ";\n"
                done = True             
        if(done == False):
            new_s =  rule +" = false;\n"     
        rule_string += new_s
        
    
    print("----RULE STRING-----")
    print(" ".join(args))
    

    compute_puzzle(B = starting_board, max_sol = 256, rules = rule_string, rule_comment = args)

if __name__ == '__main__':
    main()












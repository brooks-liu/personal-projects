def make_board(numbers: list) -> list:
    '''make a sudoku board with indices, with 0 representing empty squares'''
    board = []
    for i in range(9):
        board.append([])  # set up the board


    for i in range(9):
        for j in range(9):
            board[i].append(numbers[i * 9 + j])   # board[i] is a list

    return board

def make_options_list(board: list) -> list:
    '''makes a list that stores the options of numbers that can go into an empty square, with 0 representing a filled square'''
    options = []
    for i in range(9):
        options.append([])  # set up the board again

    for i in range(9):
        for j in range(9):
            options[i].append([])  # get all squares
    
    for i in range(9):
        for j in range(9):
            if board[i][j] == 0:
                options[i][j] = [1, 2, 3, 4, 5, 6, 7, 8, 9]
            else:
                options[i][j] = 0
    
    return options

def remove_option(options: list, row: int, col: int, number: int):
    '''removes the already filled number from the options of empty squares in the same row/column/box'''
    # remove from rows first
    for i in range(9):
        if i == col or options[row][i] == 0:
            continue
        if number in options[row][i]:
            options[row][i].remove(number)
    
    # remove from columns
    for i in range(9):
        if i == row or options[i][col] == 0:
            continue
        if number in options[i][col]:
            options[i][col].remove(number)

    # remove from box
    if row < 3:
        box_row = 0
    elif row < 6 and row >= 3:
        box_row = 1
    else:
        box_row = 2
    
    if col < 3:
        box_col = 0
    elif col < 6 and col >= 3:
        box_col = 1
    else:
        box_col = 2

    for i in range(box_row * 3, box_row * 3 + 3):
        for j in range(box_col * 3, box_col * 3 + 3):
            if options[i][j] == 0:
                continue
            if number in options[i][j]:
                options[i][j].remove(number)

def reduce_options(board:list, options: list):
    '''fully reduces options based on the current numbers on the board'''
    for row in range(9):
        for col in range(9):
            if board[row][col] != 0:
                remove_option(options, row, col, board[row][col])

def insert_solved(board: list, options: list):
    '''given an updated list of options, if an empty square only has one option, fill in the option on the board, and remove it from options'''
    for row in range(9):
        for col in range(9):
            if options[row][col] != 0:
                if len(options[row][col]) == 1:
                    board[row][col] = options[row][col][0]
                    options[row][col] = 0
                if options[row][col] == []:
                    print("Invalid Board")
                    return   # +++++ note that if we have harder boards in the future, will have to remove this if we are guessing numbers+++++++

def is_board_consistent(board:list):
    '''finds if the board is consistent with the current numbers no the board'''


def solve_sudoku(board: list, options: list):
    '''takes in a board and solves it'''
    unsolved = True
    while unsolved:
        reduce_options(board, options)
        insert_solved(board, options)

        unsolved = False
        for row in board:
            for col in row:
                if col == 0:
                    unsolved = True

def check_insufficiency_contradiction(board: list, options: list):
    pass



    






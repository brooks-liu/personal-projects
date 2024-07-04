import sudoku_solver as ss

if __name__ == "__main__":
    numbers = 0, 7, 0, 5, 8, 3, 0, 2, 0, 0, 5, 9, 2, 0, 0, 3, 0, 0, 3, 4, 0, 0, 0, 6, 5, 0, 7, 7, 9, 5, 0, 0, 0, 6, 3, 2, \
        0, 0, 3, 6, 9, 7, 1, 0, 0, 6, 8, 0, 0, 0, 2, 7, 0, 0, 9, 1, 4, 8, 3, 5, 0, 7, 6, 0, 3, 0, 7, 0, 1, 4, 9, 5, 5, 6, 7, \
        4, 2, 9, 0, 1, 3
    board = ss.make_board(numbers)
    options = ss.make_options_list(board)

    numbers2 = 0, 0, 0, 2, 6, 0, 7, 0, 1, 6, 8, 0, 0, 7, 0, 0, 9, 0, 1, 9, 0, 0, 0, 4, 5, 0, 0, \
    8, 2, 0, 1, 0, 0, 0, 4, 0, 0, 0, 4, 6, 0, 2, 9, 0, 0, 0, 5, 0, 0, 0, 3, 0, 2, 8, \
    0, 0, 9, 3, 0, 0, 0, 7, 4, 0, 4, 0, 0, 5, 0, 0, 3, 6, 7, 0, 3, 0, 1, 8, 0, 0, 0
    board2 = ss.make_board(numbers2)
    options2 = ss.make_options_list(board2)

    print("Sodoku board:")
    print(board2)

    print("Options:")
    print(options2)

    # ss.remove_option(options, 0, 1, board[0][1])
    # print("\n Options:")
    # print(options)

    # ss.reduce_options(board2, options2)
    # print("Options:")
    # print(options2)
    # ss.insert_solved(board2, options2)
    # print("Board:")
    # print(board2)


    ss.solve_sudoku(board2, options2)
    print("Solution:")
    print(board2)

    



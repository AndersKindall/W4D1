require_relative 'tic_tac_toe'

class TicTacToeNode
    attr_reader :board, :next_mover_mark, :prev_move_pos
    def initialize(board, next_mover_mark, prev_move_pos = nil)
        @board = board
        @next_mover_mark = next_mover_mark
        @prev_move_pos = prev_move_pos
    end

    def losing_node?(evaluator)
        if board.over? 
            winner = board.winner
            return true if winner && winner != evaluator
            return false
        end

        if evaluator == next_mover_mark
            return true if children.all? do |child|
                child.losing_node?(evaluator) 
            end
        else
            return true if children.any? do |child|
                child.losing_node?(evaluator)
            end
        end
        false
    end

    def winning_node?(evaluator)
        if board.over?
            winner = board.winner
            return true if winner && winner == evaluator
            return false
        end

        if evaluator == next_mover_mark
            return true if children.any? do |child|
                child.winning_node?(evaluator)
            end
        else
            return true if children.all? do |child|
                child.winning_node?(evaluator)
            end
        end
        false
    end

    def other_mark
        next_mover_mark == :x ? :o : :x
    end

    # This method generates an array of all moves that can be made after
    # the current move.
    def children
        moves = []
        board.rows.each_with_index do |row, i|
            row.each_with_index do |space, j|
                if !space
                    duped_board = board.dup
                    duped_board[[i, j]] = next_mover_mark
                    node = TicTacToeNode.new(duped_board, other_mark, [i, j])
                    moves << node
                end
            end
        end
        moves
    end

    
end

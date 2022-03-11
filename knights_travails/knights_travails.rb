require_relative "tree_node"

class KnightPathFinder
    attr_reader :root_node
    def initialize(start)
        @root_node = PolyTreeNode.new(start)
        @considered_positions = [start]
        build_move_tree
    end

    def build_move_tree
        q = [@root_node]
        until q.empty?
            node = q.shift
            new_moves = new_move_positions(node.value)
            new_moves.each do |pos|
                new_node = PolyTreeNode.new(pos)
                new_node.parent = node
                q << new_node
            end
        end
    end

    def new_move_positions(pos)
        moves = KnightPathFinder.valid_moves(pos)
        new_moves = moves.select do |move|
            @considered_positions.none? do |seen|
                move[0] == seen[0] && move[1] == seen[1]
            end
        end
        @considered_positions.concat(new_moves)
        new_moves
    end

    def trace_path_back(node)
        return [] unless node
        trace_path_back(node.parent).push(node.value)
    end
    
    def find_node(end_pos, current_node)
        return current_node if end_pos == current_node.value
        current_node.children.each do |child|
            target = find_node(end_pos, child)
            return target if target
        end
        nil
    end

    def find_path(end_pos)
        n_node = find_node(end_pos, @root_node)
        trace_path_back(n_node)
    end

    def self.valid_moves(pos)
        #[0, 0]
        arr = []
        (-1).step(1, 2) do |i| # [-1, 1].each
            (-2).step(2, 4) do |j| # [-2, 2].each
                arr << [i, j]
                arr << [j, i]
            end
        end
        arr = arr.select do |(row, col)|
            (pos[0] + row).between?(0, 7) && (pos[1] + col).between?(0, 7)
        end
        arr.map do |(row, col)|
            [pos[0] + row, pos[1] + col]
        end

    end


end

kpf = KnightPathFinder.new([0, 0])
p kpf.find_path([7, 6]) # => [[0, 0], [1, 2], [2, 4], [3, 6], [5, 5], [7, 6]]
p kpf.find_path([6, 2]) # => [[0, 0], [1, 2], [2, 0], [4, 1], [6, 2]]
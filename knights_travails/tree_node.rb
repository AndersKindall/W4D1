

class PolyTreeNode
    attr_accessor :parent, :value, :children
    def initialize(value)
        @value = value
        @parent = nil
        @children = []
    end

    def parent=(parent_node)
        if parent
            @parent.children.delete_at(@parent.children.index(self))
        end
        @parent = parent_node
        if parent_node
            parent_node.children << self
        end
    end

    def add_child(child_node)
        child_node.parent = self
    end

    def remove_child(child_node)
        if children.include?(child_node)
            child_node.parent = nil
        else
            raise "Not a child"
        end
    end

    def dfs(target)
        return self if target == value
            
        @children.each do |child|
            found = child.dfs(target)
            return found if found
        end
        nil
    end

    def bfs(target)
        q = [self]
        until q.empty?
            node = q.shift
            
            return node if node.value == target
            q.concat(node.children).compact!
        end
        nil
    end

    def inspect
        @value.inspect + " C " + @children.inspect
    end

end
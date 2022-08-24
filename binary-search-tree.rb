array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]

class Node
  attr_accessor :left, :right, :value
  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end
end

class Tree
  attr_reader :array, :root
  def initialize(array)
    @array = array.uniq.sort
    @root = build_tree(@array)
    puts "Sorted Array: #{@array}"
    pretty_print
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def build_tree(array)
    length = array.length
    return Node.new(array[0]) if array[0] == @array[0] && length == 1
    return nil if length == 1

    middle = array.slice(length/2)
    left = array.slice(0, length/2)
    right = array.slice(length/2, length)

    center_node = Node.new(middle)
    center_node.left = (build_tree(left))
    center_node.right = (build_tree(right))

    return center_node
  end

  def find(value)
    current_node = @root

    while true
      return {parent: nil, target: @root} if value == @root.value

      if value < current_node.value
        if current_node.left.nil?
          puts "Node doesn't exist"
          return nil
        end

        if current_node.left.value == value
          puts "Node Found"
          return {parent: current_node, target: current_node.left}
        end

        current_node = current_node.left

      elsif value > current_node.value
        if current_node.right.nil?
          puts "Node doesn't exist"
          return nil
        end

        if current_node.right.value == value
          puts "Node Found"
          return {parent: current_node, target: current_node.right}
        end

        current_node = current_node.right
      end
    end
  end

  def delete(value)
    target = find(value)[:target]
    parent = find(value)[:parent]

    if target == @root
      unless target.right.nil?
        tracer = target.right

        until tracer.left == nil
          tracer = tracer.left
        end

        @root.value = delete(tracer.value)
        puts "Target deleted"
        pretty_print
        return value
      end
    end

    # Target has no children
    if target.left.nil? && target.right.nil?
      parent.left = nil if parent.left != nil && target.value == parent.left.value
      parent.right = nil if parent.right != nil && target.value == parent.right.value

      puts "Target deleted"
      pretty_print
      return value
    end

    # Target has two children
    unless target.left.nil? && target.left.nil?
      tracer = target.left

      until tracer.left == nil
        tracer = tracer.left
      end

      target.value = tracer.value
      target.left = tracer.right

      puts "Target deleted"
      pretty_print
      return value
    end

    # Target has one child
    if !target.left.nil? || !target.right.nil?
      unless target.left.nil?
        target.value = target.left.value
        target.left = nil
      end
      unless target.right.nil?
        target.value = target.right.value
        target.right = nil
      end

      puts "Target deleted"
      pretty_print
      return value
    end
  end

  def insert(value)
    current_node = @root

    while true
      if value < current_node.value
        if current_node.left.nil?
          puts "Inserting Node"
          current_node.left = Node.new(value)
          pretty_print
          return current_node.left
        end

        if current_node.left.value == value
          puts "Value already exists"
          return nil
        end

        current_node = current_node.left

      elsif value > current_node.value
        if current_node.right.nil?
          puts "Inserting Node"
          current_node.right = Node.new(value)
          pretty_print
          return current_node.right
        end

        if current_node.right.value == value
          puts "Value already exists"
          return nil
        end

        current_node = current_node.right
      end
    end
  end

  def level_order
    # unshift and pop or push and shift for First in First out 
    queue = []
    if block_given?

    else

    end
  end

end

tree = Tree.new(array)
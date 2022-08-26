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
  attr_reader :array, :root, :queue, :visited
  def initialize(array)
    @array = array.uniq.sort
    @root = build_tree(@array)
    @queue = []
    @visited = []
    @depth = 0
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
      return {parent: nil, target: @root, depth: @depth} if value == @root.value

      if value < current_node.value
        if current_node.left.nil?
          puts "Node doesn't exist"
          return nil
        end

        if current_node.left.value == value
          @depth += 1
          return {parent: current_node, target: current_node.left, depth: @depth}
        end

        @depth += 1
        current_node = current_node.left

      elsif value > current_node.value
        if current_node.right.nil?
          puts "Node doesn't exist"
          return nil
        end

        if current_node.right.value == value
          @depth += 1
          return {parent: current_node, target: current_node.right, depth: @depth}
        end

        @depth += 1
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

  def level_order(node = @root, &block)
    @visited << @root unless @visited.include?(@root)

    # Push all remaining queue to visited when all nodes are accounted for
    if node.nil? || (node.left.nil? && node.right.nil?)
      until @queue.empty?
        block.call(@queue[0]) if block_given?
        @visited << @queue.shift
      end

    else
      @queue << node.left unless node.left.nil?
      @queue << node.right unless node.right.nil?

      node = @queue[0]
      block.call(node) if block_given?

      @visited << @queue.shift
      level_order(node, &block)
    end

    if @queue.empty? && @visited.length > 0
      unless block_given?        
        return display_visited
      end
    end
  end

  def inorder(node = @root, &block)
    inorder(node.left, &block) unless node.left.nil?
    @visited << node
    inorder(node.right, &block) unless node.right.nil?
    block.call(node) if block_given?
    return display_visited unless block_given?
  end

  def preorder(node = @root, &block)
    @visited << node
    preorder(node.left, &block) unless node.left.nil?
    preorder(node.right, &block) unless node.right.nil?

    block.call(node) if block_given?

    return display_visited unless block_given?
  end
  
  def postorder(node = @root, &block)
    postorder(node.left, &block) unless node.left.nil?
    postorder(node.right, &block) unless node.right.nil?
    @visited << node
    block.call(node) if block_given?
    return display_visited unless block_given?
  end

  def display_visited
    array = []
    @visited.each { |node| array << node.value }
    return array
  end

  def clear_visited
    @visited.clear
  end

  def show_orders
    p "Preorder: #{preorder}"
    clear_visited
    p "Inorder: #{inorder}"
    clear_visited
    p "Postorder: #{postorder}"
    clear_visited
  end

  def height(node)
    if node.nil?
      return 0
    else
      return (height(node.left) > height(node.right) ? height(node.left) : height(node.right)) + 1
    end
  end

  def display_height(node_value)
    result = find(node_value)
    p "Height: #{height(result[:target]) - 1}" unless result.nil?
  end

  def display_depth(node_value)
    result = find(node_value)
    p "Depth: #{result[:depth]}" unless result.nil?
  end

  # def balanced?
    
  # end

  # def rebalance
    
  # end
end

tree = Tree.new(array)
tree.display_height(8)
tree.display_depth(6345)
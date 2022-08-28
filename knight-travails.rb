class Node
  attr_accessor :parent, :coordinate
  def initialize(parent, coordinate)
    @parent = parent
    @coordinate = coordinate
  end
end

class GameBoard
  attr_accessor :board, :shortest_path
  def initialize(knight_position, target_position)
    @knight_position = Node.new(nil, knight_position)
    @target_position = target_position

    @visited = []
    @queue = []
  end

  def knight_moves(current_position = @knight_position)
    possible_moves = get_possible_moves(current_position.coordinate)

    return nil if possible_moves.empty?

    # Confirm if possible moves include target, trace parents of current coordinate to knight position, print path
    if possible_moves.include?(@target_position)
      path = []
      path << @target_position
      path.unshift(current_position.coordinate)

      until current_position.parent.nil?
        path.unshift(current_position.parent.coordinate)
        current_position = current_position.parent
      end

      puts "You made it in #{path.length - 1} moves! Here's your path:"
      path.each_index do |index|
        print "Initial " if path[index] == @knight_position.coordinate
        if path[index] == path.last
          print "Target: #{path[index]}"
        else
          puts "Move #{index}: #{path[index]}"
        end
      end

      return path
    end

    # Add node to queue for each possible move with current position as its parent , able to trace back parents when target is found
    possible_moves.each do |coordinate|
      node = Node.new(current_position, coordinate)
      @queue << node
    end

    # Add first element in queue to @visited, recursively call with shifted value
    @visited << @queue[0]
    knight_moves(@queue.shift)
  end

  def get_possible_moves(position = @knight_position)
    possible_moves = []
    row = position[0]
    column = position[1]

    # Possible Horizontal moves
    possible_moves << [row + 1, column - 2] unless @visited.include?([row + 1, column - 2]) || (row + 1 > 7 || column - 2 < 0)
    possible_moves << [row - 1, column - 2] unless @visited.include?([row - 1, column - 2]) || (row - 1 < 0 || column - 2 < 0)
    possible_moves << [row + 1, column + 2] unless @visited.include?([row + 1, column + 2]) || (row + 1 > 7 || column + 2 > 7)
    possible_moves << [row - 1, column + 2] unless @visited.include?([row - 1, column + 2]) || (row - 1 < 0 || column + 2 > 7)

    # Possible Vertical moves
    possible_moves << [row - 2, column + 1] unless @visited.include?([row - 2, column + 1]) || (row - 2 < 0 || column + 1 > 7)
    possible_moves << [row - 2, column - 1] unless @visited.include?([row - 2, column - 1]) || (row - 2 < 0 || column - 1 < 0)
    possible_moves << [row + 2, column + 1] unless @visited.include?([row + 2, column + 1]) || (row + 2 > 7 || column + 1 > 7)
    possible_moves << [row + 2, column - 1] unless @visited.include?([row + 2, column - 1]) || (row + 2 > 7 || column - 1 < 0)

    # p "Possible Moves: #{possible_moves}"
    return possible_moves
  end
end

game_board = GameBoard.new([7, 0],[0, 7])
game_board.knight_moves
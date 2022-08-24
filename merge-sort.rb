def merge_sort(array)
  sorted_array = []
  # Base Case
  return array if array.length == 1

  # Recursive Case
  left_half = array.slice(0, array.length/2)
  right_half = array.slice(array.length/2, array.length)

  left_half = merge_sort(left_half)
  right_half = merge_sort(right_half)

  until sorted_array.length == (array.length)
    if left_half.compact.empty?
      right_half.each { |element| sorted_array << element }
      return sorted_array
    end

    if right_half.compact.empty?
      left_half.each { |element| sorted_array << element }
      return sorted_array
    end
    
    case left_half[0] <=> right_half[0]
    when 1
      sorted_array << right_half[0]
      right_half.shift
    when 0
      sorted_array << right_half[0]
      sorted_array << left_half[0]
      right_half.shift
      left_half.shift
    when -1
      sorted_array << left_half[0]
      left_half.shift
    else
      puts "ERROR"
    end
  end
end

test_array = [4, 3, 2, 1]
array = [9, 4, 3, 5, 7, 6, 2, 1, 8]
p merge_sort(array)